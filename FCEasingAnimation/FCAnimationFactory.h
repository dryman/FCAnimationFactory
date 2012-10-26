//
//  FCEasingAnimation.h
//  FCEasingAnimation
//

/*
 
 Created by Felix Chern on 12/10/15.
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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define SEGMENT_FACTOR (4.f)

void fc_bezier_interpolation(float c1[2], float c2[2], float x1, float x2, float(^block)(float x));

// Base class of animation factories
@interface FCAnimationFactory : NSObject <NSCopying>
{
    NSArray*  _normalizedTimings;
    NSArray*  _timingBlocks;
    NSNumber* _totalDuration;
}

@property (copy) NSArray* normalizedTimings;
@property (copy) NSArray* segmentedDurations;
@property (copy) NSArray* timingBlocks;
@property (copy) NSNumber* totalDuration;

// abstracted method, need to be implemented in subclass
- (CAKeyframeAnimation*) animation;

// internal use
- (id(^)(float))makeValueScalingBlockFromValue:(id)fromValue ToValue:(id)toValue;

@end
