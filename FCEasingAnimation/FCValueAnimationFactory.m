//
//  FCValueAnimationFactory.m
//  FCEasingAnimation
//

/*
 
 Created by Felix Chern on 12/10/26.
 Copyright (c) 2012 Felix R. Chern. All rights reserved. (BSD LICENSE)
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the FCAnimationFactory nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL FELIX R. CHERN BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */


#import "FCValueAnimationFactory.h"

@implementation FCValueAnimationFactory
@synthesize values = _values;

- (id)copyWithZone:(NSZone *)zone
{
    FCValueAnimationFactory *factoryCopy = [[FCValueAnimationFactory allocWithZone:zone] init];
    factoryCopy.normalizedTimings = _normalizedTimings;
    factoryCopy.timingBlocks = _timingBlocks;
    factoryCopy.totalDuration = _totalDuration;
    factoryCopy.values = _values;
    return factoryCopy;
}


- (CAKeyframeAnimation*)animation
{
    NSMutableArray *keyTimes = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    NSMutableArray *resultValues = [NSMutableArray array];
    
    float total_duration = self.totalDuration.floatValue;
    __block float time_accumulator;
    [self.durations enumerateObjectsUsingBlock:^(NSNumber* nsDuration, NSUInteger idx, BOOL *stop) {
        id (^scalingBlock)(float) = [self makeValueScalingBlockFromValue:[self.values objectAtIndex:idx]
                                                                     ToValue:[self.values objectAtIndex:idx+1]];
        float (^timingBlock)(float) = [self.timingBlocks objectAtIndex:idx];
        float duration = nsDuration.floatValue;
        int count = (int)ceilf(duration*SEGMENT_FACTOR);
        
        float time_step = duration/(float)count;
        float n_step = 1.f /(float)count;
        float n_iter = 0.f;
        
        float c1[2], c2[2];
        
        for (int i=0; i<count; ++i) {
            fc_bezier_interpolation(c1, c2, n_iter, n_iter+n_step,timingBlock);
            [timingFunctions addObject:[CAMediaTimingFunction functionWithControlPoints:c1[0] :c1[1] :c2[0] :c2[1]]];
            [keyTimes addObject:[NSNumber numberWithFloat:time_accumulator/total_duration]];
            [resultValues addObject:scalingBlock(timingBlock(n_iter))];

            n_iter += n_step;
            time_accumulator += time_step;
        }
    }];
    [keyTimes addObject:[NSNumber numberWithFloat:1.f]];
    [resultValues addObject:[self.values lastObject]];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyTimes = keyTimes;
    animation.timingFunctions = timingFunctions;
    animation.values = resultValues;
    animation.duration = total_duration;
    return animation;
}

@end
