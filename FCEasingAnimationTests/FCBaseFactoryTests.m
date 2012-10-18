//
//  FCBaseFactoryTests.m
//  FCEasingAnimation
//
//  Created by 陳仁乾 on 12/10/18.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCBaseFactoryTests.h"


@implementation FCBaseFactoryTests

- (void)setUp
{
    [super setUp];
    factory = [FCAnimationFactory factory];
}

- (void)testDefaultFactory_timingFunctionCount
{
    CAKeyframeAnimation *animation = [factory animation];
    NSArray *timingFunctions = animation.timingFunctions;
    STAssertEquals(timingFunctions.count, 1U, @"only one function here");
}

- (void)testDefaultFactory_timingFunction
{
    CAKeyframeAnimation *animation = [factory animation];
    NSArray *timingFunctions = animation.timingFunctions;
    CAMediaTimingFunction *tFunc = [timingFunctions objectAtIndex:0];
    
    float c0[2];
    [tFunc getControlPointAtIndex:0 values:c0];
    STAssertEqualsWithAccuracy(c0[0], 0.f, 0.00001f, @"c0[0] should be 0");
    STAssertEqualsWithAccuracy(c0[1], 0.f, 0.00001f, @"c0[1] should be 0");

    
    float c1[2], c2[2];
    [tFunc getControlPointAtIndex:1 values:c1];
    [tFunc getControlPointAtIndex:2 values:c2];
    
    STAssertEqualsWithAccuracy(c1[0], 0.f, 0.000001f, @"c1=(0,0)");
    STAssertEqualsWithAccuracy(c1[1], 0.f, 0.000001f, @"c1=(0,0)");
    STAssertEqualsWithAccuracy(c2[0], 1.f, 0.000001f, @"c2=(1,1)");
    STAssertEqualsWithAccuracy(c2[1], 1.f, 0.000001f, @"c2=(1,1)");
}

@end
