//
//  FCEasingAnimationTests.m
//  FCEasingAnimationTests
//
//  Created by dryman on 12/10/15.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCEasingAnimationTests.h"
#import "FCEasingAnimation.h"

typedef float(^FCFloatBlock)(float);

FCFloatBlock genBezier (float input[2])
{
    float p1 = input[0], p2 = input[1];
    
    return ^float(float t){
        return 3*(1-t)*(1-t)*t*p1 + 3*(1-t)*t*t*p2 + t*t*t;
    };
}

@implementation FCEasingAnimationTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDerivative
{
    const float h = sqrtf(FLT_EPSILON);

    float(^block)(float x) = ^float(float x){
        return x*x;
    };
    
    float y1_t;
    y1_t = (block(0+h) - block(0-h))/(2.f*h);
    STAssertTrue(abs(y1_t-0) < 0.00001, @"y1_t correct");
    
    float y2_t;
    y2_t = (block(1+h) - block(1-h))/(2.f*h);
    STAssertTrue(abs(y2_t-2.f) < 0.000001, @"y2_t correct");
}

- (void)testBezierCurve
{
    float points[4];
    fcSegment(points, 0, 1, ^float(float x) { return x*x; });
    STAssertEqualsWithAccuracy(points[1], 0.f, 0.0001f, @"control point p1 sholdn't have y component");
}

@end
