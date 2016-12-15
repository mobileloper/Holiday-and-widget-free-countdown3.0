//
//  AppManager.m
//  Orange Harp
//
//  Created by umbrella on 8/8/14.
//  Copyright (c) 2014 Orange Harp. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (AppManager*)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[AppManager alloc] init];
    });
}

- (id)init {
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)saveAllSettings {
    [self save];
    //    [self saveLogin];
    //    [self saveDesignerGender];
}

- (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.userAuthToken      = [defaults objectForKey:@"userAuthToken"];
    self.activeUserID       = [defaults objectForKey:@"userID"];
    self.interrogations     = [defaults objectForKey:@"interrogations"];
    self.lastScan           = [defaults objectForKey:@"lastScan"];
    self.deviceToken        = [defaults objectForKey:@"deviceToken"];
    self.isAcceptTerms      = [defaults boolForKey:@"isAcceptTerms"];
    self.isIntroViewed      = [defaults boolForKey:@"isIntroViewed"];
    self.isCoachMarkViewed  = [defaults boolForKey:@"isCoachMarkViewed"];
    self.isLoginFromSocial  = [defaults boolForKey:@"isLoginFromSocial"];
    
    //    self.designerGender = [defaults stringForKey:@"designerGender"];
    //    self.isTourCamera = [defaults boolForKey:@"isTourCamera"];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userAuthToken       forKey:@"userAuthToken"];
    [defaults setValue:self.activeUserID        forKey:@"userID"];
    [defaults setValue:self.interrogations      forKey:@"interrogations"];
    [defaults setBool:self.isAcceptTerms        forKey:@"isAcceptTerms"];
    [defaults setValue:self.lastScan            forKey:@"lastScan"];
    [defaults setValue:self.deviceToken         forKey:@"deviceToken"];
    [defaults setBool:self.isIntroViewed        forKey:@"isIntroViewed"];
    [defaults setBool:self.isCoachMarkViewed    forKey:@"isCoachMarkViewed"];
    [defaults synchronize];
}

- (void)saveLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isLoginFromSocial forKey:@"isLoginFromSocial"];
    [defaults synchronize];
}

- (void)saveIsTourCamera {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.isTourCamera forKey:@"isTourCamera"];
    [defaults synchronize];
}

- (void)saveDesignerGender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:self.designerGender forKey:@"designerGender"];
    [defaults synchronize];
}

- (void)defaultSettings {
    [self save];
}

- (void)loadAppPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isGridView"] == nil) {
        [self defaultSettings];
    } else {
        [self load];
    }
}

- (void)resetTerms {
    self.isAcceptTerms = NO;
    [self save];
}

// clear defaults
- (void)reset {
    self.userAuthToken = nil;
    self.activeUserID = nil;
    self.interrogations = nil;
    self.lastScan = nil;
    self.isAcceptTerms = NO;
    self.isLoginFromSocial = NO;
    self.isCoachMarkViewed = NO;
    [self save];
    //    [self saveLogin];
}
@end
