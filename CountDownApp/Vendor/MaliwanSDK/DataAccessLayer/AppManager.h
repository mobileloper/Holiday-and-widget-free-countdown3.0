//
//  AppManager.h
//  Orange Harp
//
//  Created by umbrella on 8/8/14.
//  Copyright (c) 2014 Orange Harp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

#pragma mark -  Class Methods

+ (AppManager *)sharedInstance;

#pragma mark -  Instantce Methods

- (void)load;
- (void)save;
- (void)reset;
- (void)resetTerms;
- (void)saveLogin;
- (void)saveAllSettings;
- (void)saveIsTourCamera;
- (void)loadAppPreferences;
- (void)saveDesignerGender;

#pragma mark - Properties

@property (nonatomic, strong) NSString     *activeUserID;
@property (nonatomic, strong) NSString     *userAuthToken;
@property (nonatomic, strong) NSString     *deviceToken;
@property (nonatomic, strong) NSNumber     *interrogations;
@property (nonatomic, strong) NSString     *lastScan;
@property (nonatomic, strong) NSDictionary *userProfile;

@property (nonatomic, assign) BOOL         isAcceptTerms;
@property (nonatomic, assign) BOOL         isIntroViewed;
@property (nonatomic, assign) BOOL         isCoachMarkViewed;
@property (nonatomic, assign) BOOL         isTourCamera;
@property (nonatomic, assign) BOOL         isLoginFromSocial;

@property (nonatomic, strong) NSDictionary *metadataInfoPhoto;
@property (nonatomic, assign) unsigned int distance;

@end
