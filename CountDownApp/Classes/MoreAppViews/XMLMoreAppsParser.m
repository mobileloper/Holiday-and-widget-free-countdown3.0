//
//  XMLMoreAppsParser.m
//  CountDownApp
//
//  Created by Eagle on 11/30/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "XMLMoreAppsParser.h"

@implementation XMLMoreAppsParser

@synthesize arrayApps;
@synthesize currApp;
@synthesize currChars;

- (id)init
{
	if ((self = [super init])) {
        
        arrayApps = [NSMutableArray array];
        
		NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.bigday-countdown.com/moreapps_xml.php"]];
		[xmlParser setDelegate:self];
		[xmlParser setShouldProcessNamespaces:NO];
		[xmlParser setShouldReportNamespacePrefixes:NO];
		[xmlParser setShouldResolveExternalEntities:NO];
		[xmlParser parse];
	}
	
	return self;
}

#pragma mark - NSXMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if (qName)
		elementName = qName;
    //NSLog(@"%@", elementName);
	
    if ([elementName isEqualToString:@"app"]) {
        self.currApp = [NSMutableDictionary dictionary];
    }
    else if ([elementName isEqualToString:@"id"] || [elementName isEqualToString:@"name"] || [elementName isEqualToString:@"bundleid"]
             || [elementName isEqualToString:@"feature"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"icon_link"]) {
        self.currChars = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currChars) {
        [self.currChars appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (qName)
		elementName = qName;
    //NSLog(@"%@", elementName);
	
	if ([elementName isEqualToString:@"app"]) {
        if (self.arrayApps && self.currApp) {
            [self.arrayApps addObject:self.currApp];
            self.currApp = nil;
        }
	}
    else if ([elementName isEqualToString:@"id"] || [elementName isEqualToString:@"name"] || [elementName isEqualToString:@"bundleid"]
             || [elementName isEqualToString:@"feature"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"icon_link"]) {
        if (self.currApp && self.currChars) {
            //NSLog(@"%@", currChars);
            [self.currApp setObject:self.currChars forKey:elementName];
            self.currChars = nil;
        }
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //NSLog(@"%@", parseError.domain);
    //NSLog(@"%d", parseError.code);
    
    NSLog(@"%@", parseError);
}

@end
