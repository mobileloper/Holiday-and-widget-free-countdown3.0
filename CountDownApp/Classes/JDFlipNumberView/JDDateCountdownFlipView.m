//
//  JDCountdownFlipView.m
//
//  Created by Markus Emrich on 12.03.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//

#import "JDDateCountdownFlipView.h"

@implementation JDDateCountdownFlipView

@synthesize mFlipNumberViewDay;
@synthesize mFlipNumberViewHour;
@synthesize mFlipNumberViewMinute;
@synthesize mFlipNumberViewSecond;

- (id)init
{
    return [self initWithTargetDate: [NSDate date]];
}

- (id)initWithType:(int)nType
{
    nNumberType = nType;
    return [self init];
}

- (id)initWithTargetDate: (NSDate*) targetDate
{
    self = [super initWithFrame: CGRectZero];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		nDayCount = 4;
        mFlipNumberViewDay    = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: nDayCount Type:nNumberType];
        mFlipNumberViewHour   = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2 Type:nNumberType];
        mFlipNumberViewMinute = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2 Type:nNumberType];
        mFlipNumberViewSecond = [[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2 Type:nNumberType];
        
        mFlipNumberViewDay.delegate    = self;
        mFlipNumberViewHour.delegate   = self;
        mFlipNumberViewMinute.delegate = self;
        mFlipNumberViewSecond.delegate = self;
        
        mFlipNumberViewHour.maximumValue = 23;
        mFlipNumberViewMinute.maximumValue = 59;
        mFlipNumberViewSecond.maximumValue = 59;
        
        [self setZDistance: 60];
        
        CGRect frame = mFlipNumberViewHour.frame;
        
        CGFloat spacing = floorf(frame.size.width*0.1);
        
        self.frame = CGRectMake(0, 0, frame.size.width*4+spacing*3, frame.size.height);
        
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewHour.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewMinute.frame = frame;
        frame.origin.x += frame.size.width + spacing;
        mFlipNumberViewSecond.frame = frame;
        
        [self addSubview: mFlipNumberViewDay];
        [self addSubview: mFlipNumberViewHour];
        [self addSubview: mFlipNumberViewMinute];
        [self addSubview: mFlipNumberViewSecond];
        
        [self setTargetDate: targetDate];
        
    }
    return self;
}

- (void)dealloc
{
    
    mFlipNumberViewDay.delegate    = nil;
    mFlipNumberViewHour.delegate   = nil;
    mFlipNumberViewMinute.delegate = nil;
    mFlipNumberViewSecond.delegate = nil;
    
    [mFlipNumberViewDay release];
    [mFlipNumberViewHour release];
    [mFlipNumberViewMinute release];
    [mFlipNumberViewSecond release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark DEBUG

- (void) setDebugValues
{
    // DEBUG
    
    mFlipNumberViewHour.maximumValue = 2;
    mFlipNumberViewMinute.maximumValue = 2;
    mFlipNumberViewSecond.maximumValue = 4;
    
    mFlipNumberViewHour.intValue = 2;
    mFlipNumberViewMinute.intValue = 2;
    mFlipNumberViewSecond.intValue = 4;
    
    [mFlipNumberViewSecond animateDownWithTimeInterval: 0.5];
}

#pragma mark -

- (void) setFlipNumberType:(int)nType
{
    nNumberType = nType;
}

- (void) setZDistance: (NSUInteger) zDistance
{
    [mFlipNumberViewDay setZDistance: zDistance];
    [mFlipNumberViewHour setZDistance: zDistance];
    [mFlipNumberViewMinute setZDistance: zDistance];
    [mFlipNumberViewSecond setZDistance: zDistance];
}

- (void) setTargetDate: (NSDate*) targetDate
{
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components: flags fromDate: [NSDate date] toDate: targetDate options: 0];
    //NSLog(@"target - %@", targetDate.description);
    //NSLog(@"current - %@", [NSDate date]);
    
    NSInteger compare = [targetDate compare:[NSDate date]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *targetComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:targetDate];
    NSDateComponents *currentComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    if (targetComponents.year == currentComponents.year && targetComponents.month == currentComponents.month && targetComponents.day == currentComponents.day && targetComponents.hour == currentComponents.hour && targetComponents.minute == currentComponents.minute && targetComponents.second == currentComponents.second )
        compare = NSOrderedSame;
    
    if (compare == NSOrderedDescending || compare == NSOrderedSame) {
        isPast = NO;
        [mFlipNumberViewDay setIsPast:NO];
        [mFlipNumberViewDay setIsMinus:NO];
        mFlipNumberViewDay.intValue    = [dateComponents day];
        [mFlipNumberViewHour setIsPast:NO];
        [mFlipNumberViewHour setIsHour:YES];
        mFlipNumberViewHour.intValue   = [dateComponents hour];
        [mFlipNumberViewMinute setIsPast:NO];
        mFlipNumberViewMinute.intValue = [dateComponents minute];
        [mFlipNumberViewSecond setIsPast:NO];
        mFlipNumberViewSecond.intValue = [dateComponents second];
        
        [mFlipNumberViewSecond animateDownWithTimeInterval: 1.0];
    }
    else {
        isPast = YES;
        [mFlipNumberViewDay setIsPast:YES];
        [mFlipNumberViewDay setIsMinus:YES];
        mFlipNumberViewDay.intValue    = [dateComponents day];
        [mFlipNumberViewHour setIsPast:YES];
        [mFlipNumberViewHour setIsHour:YES];
        mFlipNumberViewHour.intValue   = [dateComponents hour] * -1;
        [mFlipNumberViewMinute setIsPast:YES];
        mFlipNumberViewMinute.intValue = [dateComponents minute] * -1;
        [mFlipNumberViewSecond setIsPast:YES];
        mFlipNumberViewSecond.intValue = [dateComponents second] * -1;
        
        [mFlipNumberViewSecond animateUpWithTimeInterval: 1.0];
    }
}

- (void) setFrame: (CGRect) rect
{
    if (nNumberType == 0)
    {
        CGFloat currentX   = 0;
        float offset = 6.0f;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            offset = 14.0f;
        
        float fWidth = rect.size.height * 0.70 + 1;
        float mWidth = fWidth + 3;
        mFlipNumberViewDay.frame = CGRectMake(currentX, 0, fWidth*nDayCount, rect.size.height);
        currentX   += mFlipNumberViewDay.frame.size.width;
        
        currentX += offset;
        mFlipNumberViewHour.frame = CGRectMake(currentX, 0, mWidth * 2, rect.size.height);
        
        currentX += mFlipNumberViewHour.frame.size.width;
        
        currentX += offset;
        mFlipNumberViewMinute.frame = CGRectMake(currentX, 0, mWidth * 2, rect.size.height);
        
        currentX += mFlipNumberViewMinute.frame.size.width;
        
        currentX += offset;
        mFlipNumberViewSecond.frame = CGRectMake(currentX, 0, mWidth * 2, rect.size.height);
        currentX += mFlipNumberViewSecond.frame.size.width;

        // take bottom right of last view for new size, to match size of subviews
        CGRect lastFrame = mFlipNumberViewSecond.frame;
        rect.size.width  = ceil(lastFrame.size.width  + lastFrame.origin.x);
        rect.size.height = ceil(lastFrame.size.height + lastFrame.origin.y);
    }
    else if (nNumberType == 1) {
        CGFloat currentX   = 7;
        
        float fWidth = rect.size.height * 0.73 + 1;
        mFlipNumberViewDay.frame = CGRectMake(currentX, 0, fWidth * nDayCount, rect.size.height);
        currentX   += mFlipNumberViewDay.frame.size.width;
        
        currentX += 14;
        mFlipNumberViewHour.frame = CGRectMake(currentX, 0, fWidth * 2, rect.size.height);
        
        currentX += mFlipNumberViewHour.frame.size.width;
        
        currentX += 12;
        mFlipNumberViewMinute.frame = CGRectMake(currentX, 0, fWidth * 2, rect.size.height);
        
        currentX += mFlipNumberViewMinute.frame.size.width;
        
        currentX += 12;
        mFlipNumberViewSecond.frame = CGRectMake(currentX, 0, fWidth * 2, rect.size.height);
        currentX += mFlipNumberViewSecond.frame.size.width;
        
        // take bottom right of last view for new size, to match size of subviews
        CGRect lastFrame = mFlipNumberViewSecond.frame;
        rect.size.width  = ceil(lastFrame.size.width  + lastFrame.origin.x);
        rect.size.height = ceil(lastFrame.size.height + lastFrame.origin.y);
    }
    else {
        CGFloat digitWidth = rect.size.width/10.0;
        CGFloat margin     = digitWidth/3.0;
        CGFloat currentX   = 0;
        
        mFlipNumberViewDay.frame = CGRectMake(currentX, 0, digitWidth*nDayCount, rect.size.height);
        currentX   += mFlipNumberViewDay.frame.size.width;
        
        for (JDGroupedFlipNumberView* view in [NSArray arrayWithObjects: mFlipNumberViewHour, mFlipNumberViewMinute, mFlipNumberViewSecond, nil])
        {
            currentX   += margin;
            view.frame = CGRectMake(currentX, 0, digitWidth*2, rect.size.height);
            currentX   += view.frame.size.width;
        }
        
        // take bottom right of last view for new size, to match size of subviews
        CGRect lastFrame = mFlipNumberViewSecond.frame;
        rect.size.width  = ceil(lastFrame.size.width  + lastFrame.origin.x);
        rect.size.height = ceil(lastFrame.size.height + lastFrame.origin.y);
    }
    
    [super setFrame: rect];
}

#pragma mark -
#pragma mark GroupedFlipNumberViewDelegate
- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue
{
//    LOG(@"ToValue: %d", newValue);
    
    JDGroupedFlipNumberView* animateView = nil;
    
    if (mFlipNumberViewDay.intValue == 0 && mFlipNumberViewHour.intValue == 0 && mFlipNumberViewMinute.intValue == 0 && mFlipNumberViewSecond.intValue == 1) {
        [mFlipNumberViewSecond stopAnimation];
        return;
    }
    
    if (groupedFlipNumberView == mFlipNumberViewSecond) {
        animateView = mFlipNumberViewMinute;
    }
    else if (groupedFlipNumberView == mFlipNumberViewMinute) {
        animateView = mFlipNumberViewHour;
    }
    else if (groupedFlipNumberView == mFlipNumberViewHour) {
        animateView = mFlipNumberViewDay;
    }
    
    if (animateView != nil)
    {
        if (isPast == NO && newValue == groupedFlipNumberView.maximumValue)
        {
            [animateView animateToPreviousNumber];
        }
        else if (isPast == YES && newValue == 0)
        {
            [animateView animateToNextNumber];
        }
    }
}

- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView didChangeValue: (NSUInteger) newValue animated: (BOOL) animated
{
}

@end
