//
//  FlipNumberView.m
//
//  Created by Markus Emrich on 26.02.11.
//  Copyright 2011 Markus Emrich. All rights reserved.
//
//
//  based on
//  www.voyce.com/index.php/2010/04/10/creating-an-ipad-flip-clock-with-core-animation/
//

#import "JDFlipNumberView.h"
#import "AppDelegate.h"

static NSString* kFlipAnimationKey = @"kFlipAnimationKey";


@interface JDFlipNumberView (private)

- (void) initImages;
- (CGFloat) defaultAnimationDuration;
- (void) animateIntoCurrentDirectionWithDuration: (CGFloat) duration;
- (void) nextValueWithoutAnimation: (NSTimer*) timer;
- (void) updateFlipViewFrame;
- (NSUInteger) validValueFromInt: (NSInteger) index;

@end


@implementation JDFlipNumberView

@synthesize delegate;
@synthesize currentDirection = mCurrentDirection;
@synthesize currentAnimationDuration = mCurrentAnimationDuration;
@synthesize intValue = mCurrentValue;
@synthesize maxValue = mMaxValue;
@synthesize isMinus;
@synthesize isHour;

- (id) init
{
	return [self initWithIntValue: 0];
}

- (id) initWithType:(int)nType
{
    nNumberType = nType;
    return [self init];
}

- (id) initWithIntValue: (NSUInteger) startNumber
{
	//NSLog(@"initWithIntValue %d", startNumber);
	
    self = [super initWithFrame: CGRectZero];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
		
        isMinus = NO;
        isPast = YES;
        isHour = NO;
        mMaxValue = 9;
		mCurrentValue = [self validValueFromInt: startNumber];
		mCurrentState = eFlipStateFirstHalf;
        mCurrentDirection = eFlipDirectionDown;
		mCurrentAnimationDuration = 0.25;
		
		[self initImages];
		
		if (!mTopImages) {
			//NSLog(@"ERROR CREATING IMAGES!");
			return nil;
		}
		
		// setup frame
		UIImage* image = [mTopImages objectAtIndex: mCurrentValue];
		super.frame = CGRectMake(0, 0, image.size.width, image.size.height*2);
        //self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

// needed to release view properly
- (void) removeFromSuperview
{
	[self stopAnimation];
	[super removeFromSuperview];
}

- (void)dealloc
{
	// NSLog(@"dealloc (value: %d)", mCurrentValue);
	
	[mTopImages release];
	[mBottomImages release];
    
    [mMinusTopImages release];
    [mMinusBottomImages release];
	
	[mImageViewTop release];
	[mImageViewBottom release];
	[mImageViewFlip release];
    
    [mImageViewMinus release];
	
    [super dealloc];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) initImages
{
	NSMutableArray* filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"JDFlipNumberView.bundle/%d.png", i]];
	}
	
	NSMutableArray* images;// = [NSMutableArray arrayWithCapacity: [filenames count]*2];
	
    if (nNumberType == 0) {
        images = APP_DELEGATE.imagesType0;
    }
    else if (nNumberType == 1) {
        images = APP_DELEGATE.imagesType1;
    }
    
    mTopImages	  = [[images subarrayWithRange: NSMakeRange(0, [filenames count])] retain];
	mBottomImages = [[images subarrayWithRange: NSMakeRange([filenames count], [filenames count])] retain];
    
    [filenames removeAllObjects];
    filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"JDFlipNumberView.bundle/0%d.png", i]];
	}
	
    if (nNumberType == 0) {
        images = APP_DELEGATE.imagesMinusType0;
    }
    else if (nNumberType == 1) {
        images = APP_DELEGATE.imagesMinusType1;
    }
    
    
    mMinusTopImages	  = [[images subarrayWithRange: NSMakeRange(0, [filenames count])] retain];
	mMinusBottomImages = [[images subarrayWithRange: NSMakeRange([filenames count], [filenames count])] retain];

    mImageViewMinus	 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JDFlipNumberView.bundle/__.png"]];
    mImageViewMinus.frame = self.bounds;
    [self addSubview:mImageViewMinus];
    
	// setup image views
    if (isMinus == YES)
    {
        [mImageViewTop removeFromSuperview];
        [mImageViewBottom removeFromSuperview];
        [mImageViewFlip removeFromSuperview];

        [self addSubview:mImageViewMinus];
    }
    else
    {
        [mImageViewMinus removeFromSuperview];
        
        if (isPast == YES)
        {
            mImageViewTop	 = [[UIImageView alloc] initWithImage: [mMinusTopImages    objectAtIndex: mCurrentValue]];
            mImageViewBottom = [[UIImageView alloc] initWithImage: [mMinusBottomImages objectAtIndex: mCurrentValue]];
            mImageViewFlip	 = [[UIImageView alloc] initWithImage: [mMinusTopImages    objectAtIndex: mCurrentValue]];
        }
        else
        {
            mImageViewTop	 = [[UIImageView alloc] initWithImage: [mTopImages    objectAtIndex: mCurrentValue]];
            mImageViewBottom = [[UIImageView alloc] initWithImage: [mBottomImages objectAtIndex: mCurrentValue]];
            mImageViewFlip	 = [[UIImageView alloc] initWithImage: [mTopImages    objectAtIndex: mCurrentValue]];
        }
    }
    mImageViewFlip.hidden = YES;
	
	mImageViewBottom.frame = CGRectMake(0, mImageViewTop.image.size.height, mImageViewTop.image.size.width, mImageViewTop.image.size.height);
	
	// add image views
    if (isMinus == NO)
    {
        [self addSubview: mImageViewTop];
        [self addSubview: mImageViewBottom];
        [self addSubview: mImageViewFlip];
    }
	
	// setup default 3d transform
	[self setZDistance: (mImageViewTop.image.size.height*2)*3];
}

- (void)setIsPast:(BOOL)past
{
    isPast = past;
}

- (BOOL) getIsPast
{
    return isPast;
}

- (void)setIsMinus:(BOOL)minus
{
    isMinus = minus;
    if (isMinus == YES)
    {
        [mImageViewTop removeFromSuperview];
        [mImageViewBottom removeFromSuperview];
        [mImageViewFlip removeFromSuperview];
        
        [self addSubview:mImageViewMinus];
        [self bringSubviewToFront:mImageViewMinus];
    }
}

- (CGSize) sizeThatFits: (CGSize) aSize
{
    if (!mTopImages || [mTopImages count] <= 0) {
        return [super sizeThatFits: aSize];
    }
    
    UIImage* image = (UIImage*)[mTopImages objectAtIndex: 0];
    CGFloat ratioW     = aSize.width/aSize.height;
    CGFloat origRatioW = image.size.width/(image.size.height*2);
    CGFloat origRatioH = (image.size.height*2)/image.size.width;
    
    if (ratioW>origRatioW)
    {
        aSize.width = aSize.height*origRatioW;
    }
    else
    {
        aSize.height = aSize.width*origRatioH;
    }
    
    return aSize;
}

#pragma mark -
#pragma mark external access

- (void) setFrame: (CGRect)rect
{
    [self setFrame:rect allowUpscaling:NO];
}

- (void) setFrame: (CGRect)rect allowUpscaling:(BOOL)upscalingAllowed
{
    if (!upscalingAllowed) {
        rect.size.width  = MIN(rect.size.width, mImageViewTop.image.size.width);
        rect.size.height = MIN(rect.size.height, mImageViewTop.image.size.height*2);
    }
    
    rect.size = [self sizeThatFits: rect.size];
	[super setFrame: rect];
    
    rect.origin = CGPointMake(0, 0);
    if (isMinus == NO)
        rect.size.height /= 2.0;
    mImageViewTop.frame = rect;
    rect.origin.y += rect.size.height;
    mImageViewBottom.frame = rect;
    
	if (mCurrentState == eFlipStateFirstHalf) {
        mImageViewFlip.frame = mImageViewTop.frame;
    } else {
        mImageViewFlip.frame = mImageViewBottom.frame;
    }
	
	[self setZDistance: self.frame.size.height*3];
    
    mImageViewMinus.frame = self.bounds;
}

- (void) setZDistance: (NSUInteger) zDistance
{
	// setup 3d transform
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;	
	self.layer.sublayerTransform = aTransform;
}

- (void) setIntValue: (NSUInteger) newValue
{
	// save new value
	mCurrentValue = [self validValueFromInt: newValue];
	
	// display new value
    if (isMinus == YES)
    {
        [mImageViewTop removeFromSuperview];
        [mImageViewBottom removeFromSuperview];
        [mImageViewFlip removeFromSuperview];
        
        [self addSubview:mImageViewMinus];
    }
    else
    {
        [mImageViewMinus removeFromSuperview];
        
        if (isPast == YES)
        {
            mImageViewTop.image		= [mMinusTopImages    objectAtIndex: mCurrentValue];
            mImageViewBottom.image  = [mMinusBottomImages objectAtIndex: mCurrentValue];
            mImageViewFlip.image    = [mMinusTopImages    objectAtIndex: mCurrentValue];
        }
        else
        {
            mImageViewTop.image		= [mTopImages    objectAtIndex: mCurrentValue];
            mImageViewBottom.image  = [mBottomImages objectAtIndex: mCurrentValue];
            mImageViewFlip.image    = [mTopImages    objectAtIndex: mCurrentValue];
        }
    }
    
	// if animation is running in step2, top&bottom already show the next value
	if (mCurrentState == eFlipStateSecondHalf && !isMinus)
    {
        if (isPast == YES)
        {
            mImageViewTop.image	 = [mMinusTopImages objectAtIndex: [self nextValue]];
            mImageViewFlip.image = [mMinusBottomImages objectAtIndex: [self nextValue]];
        }
        else
        {
            mImageViewTop.image	 = [mTopImages objectAtIndex: [self nextValue]];
            mImageViewFlip.image = [mBottomImages objectAtIndex: [self nextValue]];
        }
	}
	// if animation is running in step1, top already shows next value
	else if ([mImageViewFlip.layer.animationKeys count] > 0 && !isMinus)
    {
        if (isPast == YES)
            mImageViewTop.image = [mMinusTopImages objectAtIndex: [self nextValue]];
        else
            mImageViewTop.image = [mTopImages objectAtIndex: [self nextValue]];
	}
	
	// inform delegate
	if ([delegate respondsToSelector: @selector(flipNumberView:didChangeValue:animated:)]) {
		[delegate flipNumberView: self didChangeValue: mCurrentValue animated: NO];
	}
}

#pragma mark -
#pragma mark animation

- (CGFloat) defaultAnimationDuration
{
	if (mTimer != nil) {
		return [mTimer timeInterval]/3.0;
	}
	
	return 0.15;
}

- (void) animateToNextNumber
{
	[self animateToNextNumberWithDuration: [self defaultAnimationDuration]];
}

- (void) animateToNextNumberWithDuration: (CGFloat) duration
{
    mCurrentDirection = eFlipDirectionUp;
    
    [self animateIntoCurrentDirectionWithDuration: duration];
}

- (void) animateToPreviousNumber
{
	[self animateToPreviousNumberWithDuration: [self defaultAnimationDuration]];
}

- (void) animateToPreviousNumberWithDuration: (CGFloat) duration
{	
    mCurrentDirection = eFlipDirectionDown;
    
    [self animateIntoCurrentDirectionWithDuration: duration];
}

- (void) animateIntoCurrentDirectionWithDuration: (CGFloat) duration
{
	mCurrentAnimationDuration = duration;
	
	// get next value
    NSUInteger nextIndex = [self nextValue];
    if (mCurrentDirection == eFlipDirectionDown) {
        nextIndex = [self previousValue];
    }
	
	// if duration is less than 0.05, don't animate
	if (duration < 0.05) {
		// inform delegate
		if ([delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
			[delegate flipNumberView: self willChangeToValue: nextIndex];
		}
		[NSTimer scheduledTimerWithTimeInterval: duration
										 target: self
									   selector: @selector(nextValueWithoutAnimation:)
									   userInfo: nil
										repeats: NO];
		return;
	}
	
	[self updateFlipViewFrame];
	
	// setup animation
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.duration	= MIN(0.35,mCurrentAnimationDuration);
	animation.delegate	= self;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    
	// exchange images & setup animation
	if (mCurrentState == eFlipStateFirstHalf)
	{
		// setup first animation half
		mImageViewFlip.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2.0);
        if (isMinus)
        {
            [mImageViewTop removeFromSuperview];
            [mImageViewBottom removeFromSuperview];
            [mImageViewFlip removeFromSuperview];
            
            [self addSubview:mImageViewMinus];
        }
        else
        {
            [mImageViewMinus removeFromSuperview];
            
            if (isPast == YES)
            {
                mImageViewFlip.image   = [mMinusTopImages	objectAtIndex: mCurrentValue];
                mImageViewBottom.image = [mMinusBottomImages objectAtIndex: mCurrentValue];
                mImageViewTop.image	   = [mMinusTopImages    objectAtIndex: nextIndex];
            }
            else
            {
                mImageViewFlip.image   = [mTopImages	objectAtIndex: mCurrentValue];
                mImageViewBottom.image = [mBottomImages objectAtIndex: mCurrentValue];
                mImageViewTop.image	   = [mTopImages    objectAtIndex: nextIndex];
            }
        }
        
		// inform delegate
		if ([delegate respondsToSelector: @selector(flipNumberView:willChangeToValue:)]) {
			[delegate flipNumberView: self willChangeToValue: nextIndex];
		}
		
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
	}
	else
	{
		// setup second animation half
        if (isPast == YES)
            mImageViewFlip.image = [mMinusBottomImages objectAtIndex: nextIndex];
        else
            mImageViewFlip.image = [mBottomImages objectAtIndex: nextIndex];
        
		animation.fromValue	= [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 0, 0)];
		animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 1, 0, 0)];
		animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	}
	
	// add/start animation
	[mImageViewFlip.layer addAnimation: animation forKey: kFlipAnimationKey];
	 
	// show animated view
	mImageViewFlip.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (!flag) {
		return;
	}
	
	if (mCurrentState == eFlipStateFirstHalf)
	{		
		// do second animation step
		mCurrentState = eFlipStateSecondHalf;
		[self animateIntoCurrentDirectionWithDuration: mCurrentAnimationDuration];
	}
	else
	{
		// reset state
		mCurrentState = eFlipStateFirstHalf;
		
		// set new value
		NSUInteger nextIndex = [self nextValue];
		if (mCurrentDirection == eFlipDirectionDown) {
			nextIndex = [self previousValue];
		}
		mCurrentValue = nextIndex;
		
		// update images
        if (isPast == YES)
            mImageViewBottom.image = [mMinusBottomImages objectAtIndex: mCurrentValue];
        else
            mImageViewBottom.image = [mBottomImages objectAtIndex: mCurrentValue];
        mImageViewFlip.hidden  = YES;
		
		// remove old animation
		[mImageViewFlip.layer removeAnimationForKey: kFlipAnimationKey];
		
		// inform delegate
		if ([delegate respondsToSelector: @selector(flipNumberView:didChangeValue:animated:)]) {
			[delegate flipNumberView: self didChangeValue: mCurrentValue animated: YES];
		}
	}
}

- (void) nextValueWithoutAnimation: (NSTimer*) timer
{
	// get next value
    NSUInteger nextIndex = [self nextValue];
    if (mCurrentDirection == eFlipDirectionDown) {
        nextIndex = [self previousValue];
    }
	
	// set next value
	[self setIntValue: nextIndex];
	
	// inform delegate
	if ([delegate respondsToSelector: @selector(flipNumberView:didChangeValue:animated:)]) {
		[delegate flipNumberView: self didChangeValue: mCurrentValue animated: NO];
	}
}


#pragma mark -
#pragma mark timed animation


- (void) animateUpWithTimeInterval: (NSTimeInterval) timeInterval
{	
	timeInterval = MAX(timeInterval, 0.001);
	
	[self stopAnimation];
	mTimer = [[NSTimer scheduledTimerWithTimeInterval: timeInterval target: self selector: @selector(animateToNextNumber) userInfo: nil repeats: YES] retain];
}

- (void) animateDownWithTimeInterval: (NSTimeInterval) timeInterval
{	
	timeInterval = MAX(timeInterval, 0.001);
	
	[self stopAnimation];
	mTimer = [[NSTimer scheduledTimerWithTimeInterval: timeInterval target: self selector: @selector(animateToPreviousNumber) userInfo: nil repeats: YES] retain];
}


#pragma mark -
#pragma mark cancel animation


- (void) stopAnimation
{
	[mImageViewFlip.layer removeAllAnimations];
	mImageViewFlip.hidden = YES;
	
	if (mTimer)
	{
		[mTimer invalidate];
		[mTimer release];
		mTimer = nil;
	}
}


#pragma mark -
#pragma mark helper


- (NSUInteger) nextValue
{
	return [self validValueFromInt: mCurrentValue+1];
}

- (NSUInteger) previousValue
{
	return [self validValueFromInt: mCurrentValue-1];
}

- (NSUInteger) validValueFromInt: (NSInteger) index
{
    if (isHour == NO)
    {
        if (index < 0) {
            index += (mMaxValue + 1);
        }
        
        NSUInteger newIndex = index % (mMaxValue + 1);
        
        return newIndex;
    }
    else
    {
        NSUInteger newIndex = index % 10;
        
        if ([delegate respondsToSelector:@selector(validValue:value:)]) {
            newIndex = [delegate validValue:self value:index];
        }
        
        return newIndex;
    }
}

- (void) updateFlipViewFrame
{
    if (isMinus == YES)
    {
        [mImageViewTop removeFromSuperview];
        [mImageViewFlip removeFromSuperview];
        [mImageViewBottom removeFromSuperview];
        [self bringSubviewToFront:mImageViewMinus];
        mImageViewMinus.hidden = NO;
        return;
    }
    
	if (mCurrentState == eFlipStateFirstHalf)
	{
		mImageViewFlip.layer.anchorPoint = CGPointMake(0.5, 1.0);
		mImageViewFlip.frame = mImageViewTop.frame;
	}
	else
	{
		mImageViewFlip.layer.anchorPoint = CGPointMake(0.5, 0.0);
		mImageViewFlip.frame = mImageViewBottom.frame;
	}
}

@end
