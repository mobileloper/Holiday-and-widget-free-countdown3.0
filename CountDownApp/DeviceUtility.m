//
//  DeviceUtility.m
//  HolidayCountdown
//
//  Created by Pavlo Tunyk on 1/22/15.
//  Copyright (c) 2015 Ariel. All rights reserved.
//
#import "UIDevice-Hardware.h"

#import "DeviceUtility.h"

@implementation DeviceUtility
+ (NSString *)modelName
{
    NSString *modelIdentifier = [[UIDevice currentDevice] modelIdentifier];

    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([modelIdentifier isEqualToString:@"iPhone1,1"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone1,2"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone2,1"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])    return @"iPhone4";
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])    return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPhone8,1"])    return @"iPhone5"; // iPhone 6s
    if ([modelIdentifier isEqualToString:@"iPhone8,2"])    return @"iPhone5"; // iPhone 6s plus
    if ([modelIdentifier isEqualToString:@"iPhone8,4"])    return @"iPhone5"; // iPhone SE
    
    // iPad http://theiphonewiki.com/wiki/iPad
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return @"iPad";
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return @"iPad";

    if ([modelIdentifier isEqualToString:@"iPad5,3"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad5,4"])      return @"iPad";
    
    // iPad Mini http://theiphonewiki.com/wiki/iPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return @"iPad";
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return @"iPad";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([modelIdentifier isEqualToString:@"iPod1,1"])      return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPod2,1"])      return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPod3,1"])      return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPod4,1"])      return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPod5,1"])      return @"iPhone5";
    if ([modelIdentifier isEqualToString:@"iPod7,1"])      return @"iPhone5";
    
    // Simulator
    if ([modelIdentifier hasSuffix:@"86"] || [modelIdentifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone5" : @"iPad");
    }
    
    return @"iPhone5";
}
@end
