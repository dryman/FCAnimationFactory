//
//  FCValueAnimationFactory.m
//  FCEasingAnimation
//
//  Created by 陳仁乾 on 12/10/18.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCValueAnimationFactory.h"

@implementation FCValueAnimationFactory
@synthesize normalizedValues = _normalizedValues;
@synthesize fromValue = _fromValue;
@synthesize toValue = _toValue;


-(FCValueAnimationFactory*)init
{
    if (self=[super init]) {
        _normalizedValues = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.f],
                             [NSNumber numberWithFloat:1.f], nil];
        _fromValue = [NSNumber numberWithFloat:0.f];
        _toValue = [NSNumber numberWithFloat:1.f];
    }
    return self;
}

- (CAKeyframeAnimation*) animation
{
    // TODO: assert if count of normalizedTimes, normalizedValues and timingFunctions is correct
        
    NSMutableArray *keyTimes = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    float total_duration = self.totalDuration.floatValue;
    float to_value = self.toValue.floatValue, from_value = self.fromValue.floatValue;
    float value_diff = to_value - from_value;
    __block float time_accumulator = 0.f;
    __weak typeof(self) weakSelf = self;
    
    // durations are much more convinient to do calculations!
    [self.segmentedDurations enumerateObjectsUsingBlock:^(NSNumber* nsDuration, NSUInteger idx, BOOL *stop) {
        float (^block)(float) = [weakSelf.timingBlocks objectAtIndex:idx];
        float duration = nsDuration.floatValue;
        int count = (int)ceilf(duration*SEGMENT_FACTOR);
        float n_value0 = [[weakSelf.normalizedValues objectAtIndex:idx] floatValue];
        float n_value1 = [[weakSelf.normalizedValues objectAtIndex:idx+1] floatValue];
        
        float time_step = duration/(float)count;
        float n_step = 1.f/(float)count; // normalized
        float n_iter = 0.f;
        float value_step = value_diff*(n_value1 - n_value0)/(float)count;
        float value_accumulator = from_value + value_diff*n_value0;
        
        float c1[2], c2[2];
        
        for (int i = 0; i<count; i++) {
            fc_bezier_interpolation(c1, c2, n_iter, n_iter+n_step, block);
            [timingFunctions addObject:[CAMediaTimingFunction functionWithControlPoints:c1[0] :c1[1] :c2[0] :c2[1]]];
            
            [keyTimes addObject:[NSNumber numberWithFloat:time_accumulator/total_duration]];
            [values addObject:[NSNumber numberWithFloat:value_accumulator]];
            
            value_accumulator += value_step;
            n_iter += n_step;
            time_accumulator += time_step;
        }
    }];
    // last timestamp and value
    [keyTimes addObject:[NSNumber numberWithFloat:1.f]];
    [values addObject:self.toValue];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyTimes = keyTimes;
    animation.timingFunctions = timingFunctions;
    animation.duration = total_duration;
    animation.values = values;
    return animation;
}

@end
