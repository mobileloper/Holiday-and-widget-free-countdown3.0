//
//  FacebookFacade.h
//  Maliwan - Technology
//
//  Created by Maliwan - Technology on 11/24/14.
//  Copyright (c) 2014 Maliwan - Technology. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

typedef FBFriendPickerViewController FacebookFriendPickerViewController;

typedef void (^FacebookRequestHandler)(id result, NSError *error);
typedef void (^SocialRequestHandlerCompletion)(id responseObject, NSError *error);
typedef void (^SocialRequestHandlerFailure)(id error);
typedef void (^SocialRequestHandlerProgressBlock)(NSInteger progressCount, NSInteger totalCount);

typedef FBWebDialogHandler FacebookDialogHandler;
typedef void (^FacebookSessionStateHandler)(FBSessionState status, NSError *error);
typedef void (^SimpleBlock)();
typedef void (^FallbackHandler)(NSString *url);

@interface FacebookFacade : NSObject

+ (FacebookFacade *) sharedInstance;

- (FBSession *)activeSession;

- (BOOL)isSessionOpen;
- (BOOL)hasOpenState;
- (BOOL)hasStateCreatedTokenLoaded;
- (void)closeAndClearCache:(BOOL)clear;
- (NSString *)sessionAccessToken;
- (void)showRequestDialogWithTitle:(NSString *)title
                           message:(NSString *)message
                            params:(NSDictionary *)params
                   completionBlock:(FacebookDialogHandler)block;
- (void)startRequestForMeWithCompletionHandler:(FacebookRequestHandler)block;
- (void)startRequestForMyFriendsListWithCompletionHandler:(FacebookRequestHandler)block;
- (void)startRequestForNativeSocialWithCompletionHandler:(SocialRequestHandlerCompletion)completion
                                                 failure:(SocialRequestHandlerFailure)failure;
- (void)startRequestForLifeCircleFacebookSettingsWithCompletionHandler:(FacebookRequestHandler)block;

- (void)postOpenGraphStoryWithImage:(UIImage *)image
                          withTitle:(NSString *)title
                    completionBlock:(SimpleBlock)block
                    andFailureBlock:(SimpleBlock)failure;
/*!
 @abstract
 This is a simple method for opening a session with Facebook. Using sessionOpen logs on a user,
 and sets the static activeSession which becomes the default session object for any Facebook UI widgets
 used by the application. This session becomes the active session, whether open succeeds or fails.

 @param readPermissions     An array of strings representing the read permissions to request during the
 authentication flow. The basic_info permission must be explicitly requested at first login, and is no longer
 inferred, (subject to an active migration.) It is not allowed to pass publish permissions to this method.

 @param allowLoginUI    Sometimes it is useful to attempt to open a session, but only if
 no login UI will be required to accomplish the operation. For example, at application startup it may not
 be desirable to transition to login UI for the user, and yet an open session is desired so long as a cached
 token can be used to open the session. Passing NO to this argument, assures the method will not present UI
 to the user in order to open the session.

 @param handler                 Many applications will benefit from notification when a session becomes invalid
 or undergoes other state transitions. If a block is provided, the FBSession
 object will call the block each time the session changes state.

 @discussion
 Returns true if the session was opened synchronously without presenting UI to the user. This occurs
 when there is a cached token available from a previous run of the application. If NO is returned, this indicates
 that the session was not immediately opened, via cache. However, if YES was passed as allowLoginUI, then it is
 possible that the user will login, and the session will become open asynchronously. The primary use for
 this return value is to switch-on facebook capabilities in your UX upon startup, in the case were the session
 is opened via cache.

 */
- (BOOL)openActiveSessionWithReadPermissions:(NSArray*)readPermissions
                                allowLoginUI:(BOOL)allowLoginUI
                           completionHandler:(FacebookSessionStateHandler)handler;

/*!
 @abstract
 Method tries checks session state.
 If session is open and hasStateCreatedTokenLoaded just launch completion handler block
 otherwise it try to open session with openActiveSessionWithReadPermissions:@"email"
 and depending on result launch completion or failure blocks
 */
- (void)openSessionWithCompletionHandler:(SimpleBlock)block andFailureBlock:(SimpleBlock)failure;

/*!
 @abstract
 A helper method that is used to provide an implementation for
 [UIApplicationDelegate application:openURL:sourceApplication:annotation:]. It should be invoked during
 the Facebook Login flow and will update the session information based on the incoming URL.

 @param url The URL as passed to [UIApplicationDelegate application:openURL:sourceApplication:annotation:].
 */
- (BOOL)handleOpenURL:(NSURL*)url;

- (BOOL)handleOpenURL:(NSURL*)url andSourceApplication:(NSString *)srcApplication;

- (NSString *)userAvatarURLString:(NSString *)fbuid;
//- (void)profileImageWithFBID:(NSString *)fbuid completion:(CompletionBlock)completionBlock;

- (FacebookFriendPickerViewController*) friendPickerViewControllerWithTitle:(NSString *)title delegate:(id)delegate;

/*!
 @abstract
 return YES if Facebook Messenger is installed on device
 */
- (BOOL)canPresentMessageDialog;

- (void)presentMessageDialogWithCaption:(NSString *)caption andLink:(NSURL *)url;

@end
