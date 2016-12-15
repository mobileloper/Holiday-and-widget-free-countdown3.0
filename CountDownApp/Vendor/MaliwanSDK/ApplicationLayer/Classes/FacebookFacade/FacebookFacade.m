//
//  FacebookFacade.m
//  Maliwan - Technology
//
//  Created by Maliwan - Technology on 11/24/14.
//  Copyright (c) 2014 Maliwan - Technology. All rights reserved.
//

#import "FacebookFacade.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

//#import "NetworkReachability.h"
//#import "PNAppDelegate.h"

static NSString * const kFacebookToken          = @"facebookToken";
static NSString * const kFacebookKey            = @"198640436927703";
static NSString * const kFacebookAppIdKey       = @"ACFacebookAppIdKey";
static NSString * const kFacebookAudienceKey    = @"ACFacebookAudienceKey";
static NSString * const kFacebookPermissionsKey = @"ACFacebookPermissionsKey";

@interface FacebookFacade ()
//@property (strong, nonatomic) NetworkReachability *networkReachability;
- (BOOL)isSocialAvailable;
- (void)handleAuthError:(NSError *)error;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;

@property (strong, nonatomic) NSString *objectID;

@end

@implementation FacebookFacade

+ (FacebookFacade *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[FacebookFacade alloc] init];
    });
}

- (FBSession *)activeSession {
    return [FBSession activeSession];
}

- (BOOL)isSessionOpen {
    return [[FBSession activeSession] isOpen];
}

- (BOOL)hasOpenState {
    return FB_ISSESSIONOPENWITHSTATE([[self activeSession] state]);
}

- (BOOL)hasStateCreatedTokenLoaded {
    return [[FBSession activeSession] state] == FBSessionStateCreatedTokenLoaded;
}

- (void)closeAndClearCache:(BOOL)clear {
    if (clear) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    } else {
        [[FBSession activeSession] close];
    }
}

- (NSString *)sessionAccessToken {
    return [[[FBSession activeSession] accessTokenData] accessToken];
}

- (void)showRequestDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                            params:(NSDictionary *)params
                   completionBlock:(FacebookDialogHandler)block {

    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
                                                  message:message
                                                    title:title
                                               parameters:params
                                                  handler:block];
}

- (void)startRequestForMeWithCompletionHandler:(FacebookRequestHandler)block {
    FBRequest *me = [FBRequest requestForMe];
    [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                     id result,
                                     NSError *error) {
        if (error) {
            [self handleAuthError:error];
        }
        BLOCK_SAFE_RUN(block, result, error);
    }];
}

- (void)startRequestForMyFriendsListWithCompletionHandler:(FacebookRequestHandler)block {
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (error) {
            [self handleAuthError:error];
        }
        BLOCK_SAFE_RUN(block, result, error);
    }];
}

- (void)startRequestForLifeCircleFacebookSettingsWithCompletionHandler:(FacebookRequestHandler)block {
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
    | FBRequestConnectionErrorBehaviorAlertUser
    | FBRequestConnectionErrorBehaviorRetry;
    [connection addRequest:[FBRequest requestForMe]
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (error) {
                 BLOCK_SAFE_RUN(block, result, error);
             }
         }];
    [connection start];
}

- (FacebookFriendPickerViewController *)friendPickerViewControllerWithTitle:(NSString *)title
                                                                   delegate:(id)delegate {
    FBFriendPickerViewController *controller = [FBFriendPickerViewController new];
    controller.title = title;
    controller.delegate = delegate;
    return controller;
}

- (BOOL)openActiveSessionWithReadPermissions:(NSArray *)readPermissions
                                allowLoginUI:(BOOL)allowLoginUI
                           completionHandler:(FacebookSessionStateHandler)handler {

    return [FBSession openActiveSessionWithPublishPermissions:readPermissions
                                              defaultAudience:YES
                                                 allowLoginUI:allowLoginUI
                                            completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                BLOCK_SAFE_RUN(handler, status, error);

                                            }];
}

- (void)openSessionWithCompletionHandler:(SimpleBlock)block
                         andFailureBlock:(SimpleBlock)failure {
    if ([self hasStateCreatedTokenLoaded] && [self isSessionOpen]) {
        BLOCK_SAFE_RUN(block);
    } else {
        [self openActiveSessionWithReadPermissions:@[@"publish_actions"]
                                      allowLoginUI:YES
                                 completionHandler:
         ^(FBSessionState status, NSError *error){
             if (error) {
                 [self handleAuthError:error];
                 BLOCK_SAFE_RUN(failure);
                 return;
             }
             switch (status) {
                 case FBSessionStateOpen:
                     BLOCK_SAFE_RUN(block);
                     break;

                 case FBSessionStateClosedLoginFailed:
                     BLOCK_SAFE_RUN(failure);
                     break;

                 case FBSessionStateClosed:
                     break;

                 default:
                     break;
             }
         }];
    }
}

- (BOOL)handleOpenURL:(NSURL*)url andSourceApplication:(NSString *)srcApplication {
    return [FBAppCall handleOpenURL:url sourceApplication:srcApplication];
}

//- (BOOL)handleOpenURL:(NSURL*)url andSourceApplication:(NSString *)srcApplication fallbackHandler:(FallbackHandler)fallbackHandler {
//    return [FBAppCall handleOpenURL:url sourceApplication:srcApplication fallbackHandler:^(FBAppCall *call) {
//        NSURL *targetURL = [[call appLinkData] targetURL];
//        BLOCK_SAFE_RUN(fallbackHandler, [targetURL absoluteString]);
//    }];
//}

- (BOOL)handleOpenURL:(NSURL*)url {
    return [[self activeSession] handleOpenURL:url];
}

- (NSString *)userAvatarURLString:(NSString *)fbuid {
    return [NSString stringWithFormat:@"%@", fbuid];
}

#pragma mark - Messaging methods
- (BOOL)canPresentMessageDialog {
    return [FBDialogs canPresentMessageDialog];
}

- (void)presentMessageDialogWithCaption:(NSString *)caption andLink:(NSURL *)url {
    if ([FBDialogs canPresentMessageDialog]) {
        [FBDialogs presentMessageDialogWithLink:url name:caption handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZED_STRING(@"Facebook error")
                                                            message:LOCALIZED_STRING(@"You need to install Facebook messenger application.")
                                                           delegate:nil
                                                  cancelButtonTitle:LOCALIZED_STRING(@"OK") otherButtonTitles: nil];
        [alertView show];

    }
}

#pragma mark - utility methods

- (void)handleAuthError:(NSError *)error {
    NSString *alertText;
    NSString *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];

    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];

        } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            [self showMessage:alertText withTitle:alertTitle];

        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)startRequestForNativeSocialWithCompletionHandler:(SocialRequestHandlerCompletion)completion
                                                 failure:(SocialRequestHandlerFailure)failure {
    if ([self isSocialAvailable]) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSDictionary *options = @{kFacebookAppIdKey         : kFacebookKey,
                                  kFacebookPermissionsKey   : @[@"public_stream", @"email", @"user_friends"],
                                  kFacebookAudienceKey      : ACFacebookAudienceEveryone};
        [account requestAccessToAccountsWithType:accountType options:options
                                      completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES) {
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 if ([arrayOfAccounts count] > 0) {
                     ACAccount *facebookAccount = [arrayOfAccounts objectAtIndex:0];
                     NSURL *URL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
                     SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                             requestMethod:SLRequestMethodGET
                                                                       URL:URL
                                                                parameters:nil];
                     [request setAccount:facebookAccount]; // Authentication - Requires user context
                     [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError* error) {
                         // parse the response or handle the error
                         if (!error) {
                             NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                      options:NSJSONReadingMutableLeaves
                                                                                        error:&error];
                             if (userInfo[@"error"] != nil) {
                                 [account renewCredentialsForAccount:facebookAccount
                                                          completion:^(ACAccountCredentialRenewResult renewResult, NSError *error)
                                  {
                                      if(!error) {
                                          switch (renewResult) {
                                              case ACAccountCredentialRenewResultRenewed:
                                                  NSLog(@"Good to go");
                                                  break;

                                              case ACAccountCredentialRenewResultRejected:
                                                  NSLog(@"User declined permission");
                                                  break;

                                              case ACAccountCredentialRenewResultFailed:
                                                  NSLog(@"non-user-initiated cancel, you may attempt to retry");
                                                  break;

                                              default:
                                                  break;
                                          }

                                      } else {
                                          //handle error
                                          NSLog(@"error from renew credentials: %@",error);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          });
                                      }
                                  }];
                             } else {
                                 NSMutableDictionary *facebookUserInfo = [userInfo mutableCopy];
                                 [facebookUserInfo setObject:[[facebookAccount credential] oauthToken]
                                                      forKey:kFacebookToken];
                                 BLOCK_SAFE_RUN(completion, facebookUserInfo ,error);
                             }
                         } else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                     message:error.localizedDescription
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles:nil];
                                 [alertView show];
                             });
                         }
                     }];
                 } else {
                     BLOCK_SAFE_RUN(failure, error);
                 }
             } else {
                 BLOCK_SAFE_RUN(failure, error);
             }
         }];
    } else {
        BLOCK_SAFE_RUN(failure, NO);
    }
}

- (void)postOpenGraphStoryWithImage:(UIImage *)image
                          withTitle:(NSString *)title
                    completionBlock:(SimpleBlock)block
                    andFailureBlock:(SimpleBlock)failure {
    // stage an image
    [FBRequestConnection startForUploadStagingResourceWithImage:image
                                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if(!error) {
             // instantiate a Facebook Open Graph object
             NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
             // specify that this Open Graph object will be posted to Facebook
             object.provisionedForPost = YES;
//             NSLog(@"object:%@",object);
             // for og:title
             object[@"title"] = @"Holiday is coming up!";
             // for og:type, this corresponds to the Namespace you've set for your app and the object type name
             object[@"type"] = @"holidaycountdown:event";
             // for og:description
             object[@"description"] = title;
             // for og:url, we cover how this is used in the "Deep Linking" section below
             object[@"url"] = @"https://itunes.apple.com/app/id669398769?ls=1&mt=8";
             // for og:image we assign the image that we just staged, using the uri we got as a response
             // the image has to be packed in a dictionary like this:
             object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
             // Post custom object
             [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if(!error) {
                     // get the object ID for the Open Graph object that is now stored in the Object API
                     NSString *objectId = [result objectForKey:@"id"];
                     // Further code to post the OG story goes here
                     // create an Open Graph action
                     id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                     [action setObject: @"true" forKey: @"fb:explicitly_shared"];  // This is the key point!
                     [action setObject:objectId forKey:@"event"];

                     // create action referencing user owned object
                     [FBRequestConnection startForPostWithGraphPath:@"me/holidaycountdown:share"
                                                        graphObject:action
                                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                      if(!error) {
                                                          BLOCK_SAFE_RUN(block);
                                                      } else {
                                                          NSLog(@"Encountered an error posting to Open Graph: %@", error);
                                                          BLOCK_SAFE_RUN(failure);
                                                      }
                                                  }];
                 } else {
                     NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                     BLOCK_SAFE_RUN(failure);
                 }
             }];

         } else {
             NSLog(@"Error staging an image: %@", error);
             BLOCK_SAFE_RUN(failure);
         }
     }];
}

#pragma mark - Accessor overrides

//- (NetworkReachability *)networkReachability {
//    @synchronized(self) {
//        if (!_networkReachability) {
//            _networkReachability = [NetworkReachability sharedInstance];
//        }
//    }
//    return _networkReachability;
//}

- (BOOL)isSocialAvailable {
    return NSClassFromString(@"SLComposeViewController") != nil;
}

@end

