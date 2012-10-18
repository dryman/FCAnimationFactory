//
//  FCEasingAnimation.h
//  FCEasingAnimation
//
//  Created by dryman on 12/10/15.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define SEGMENT_FACTOR (2.f)

void fc_bezier_interpolation(float c1[2], float c2[2], float x1, float x2, float(^block)(float x));

// Base class of animation factories
@interface FCAnimationFactory : NSObject
{
    NSArray*  _normalizedTimings;
    NSArray*  _timingBlocks;
    NSNumber* _totalDuration;
}

@property (copy) NSArray* normalizedTimings;
@property (copy) NSArray* segmentedDurations;
@property (copy) NSArray* timingBlocks;
@property (copy) NSNumber* totalDuration;

- (CAKeyframeAnimation*) animation;


@end
