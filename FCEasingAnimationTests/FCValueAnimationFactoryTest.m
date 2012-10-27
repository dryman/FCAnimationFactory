//
//  FCValueAnimationFactoryTest.m
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

#import "FCValueAnimationFactoryTest.h"
#import "FCValueAnimationFactory.h"

@implementation FCValueAnimationFactoryTest


- (void)testQuintFunction
{
    FCValueAnimationFactory *factory = [[FCValueAnimationFactory alloc] init];
    factory.durations = @[@.5f];
    factory.timingBlocks = @[^float(float x){ return x*x*x*x*x;}];
    factory.values = @[@0.f, @1.f];
    CAKeyframeAnimation *animation = [factory animation];
    CAMediaTimingFunction *tFunc0 = [animation.timingFunctions objectAtIndex:0];
    CAMediaTimingFunction *tFunc1 = [animation.timingFunctions objectAtIndex:1];
    
    float c1[2], c2[2];
    [tFunc0 getControlPointAtIndex:1 values:c1];
    [tFunc0 getControlPointAtIndex:2 values:c2];
    
    STAssertEqualsWithAccuracy(c1[0], 0.249994f, 0.0001f, @"c1=(0.25,0)");
    STAssertEqualsWithAccuracy(c1[1],       0.f, 0.0001f, @"c1=(0.25,0)");
    STAssertEqualsWithAccuracy(c2[0],     0.75f, 0.0001f, @"c2=(0.75,-0.25)");
    STAssertEqualsWithAccuracy(c2[1],    -0.25f, 0.0001f, @"c2=(0.75,-0.25)"); // won't it blowup when we render it?
    
    [tFunc1 getControlPointAtIndex:1 values:c1];
    [tFunc1 getControlPointAtIndex:2 values:c2];
    
    STAssertEqualsWithAccuracy(c1[0], 0.31667f, 0.0001f, @"c1=(0,0)");
    STAssertEqualsWithAccuracy(c1[1], 0.05107f, 0.0001f, @"c1=(0,0)");
    STAssertEqualsWithAccuracy(c2[0], 0.68333f, 0.0001f, @"c2=(1,1)");
    STAssertEqualsWithAccuracy(c2[1], 0.18279f, 0.0001f, @"c2=(1,1)");
    
    STAssertEquals(animation.values.count, 3U, @"three values");
    STAssertEqualsWithAccuracy([[animation.values objectAtIndex:0] floatValue],      0.f, 0.0001, @"first value is 0");
    STAssertEqualsWithAccuracy([[animation.values objectAtIndex:1] floatValue], 0.03125f, 0.0001, @"first value is 0");
    STAssertEqualsWithAccuracy([[animation.values objectAtIndex:2] floatValue],      1.f, 0.0001, @"first value is 0");
}

@end
