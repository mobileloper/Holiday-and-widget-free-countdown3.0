//
//  XMLMoreAppsParser.h
//  CountDownApp
//
//  Created by Eagle on 11/30/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLMoreAppsParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *arrayApps;
@property (strong, nonatomic) NSMutableString *currChars;
@property (strong, nonatomic) NSMutableDictionary *currApp;

@end
