//
//  FCEasingAnimationTests.m
//  FCEasingAnimationTests
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

#import "FCEasingAnimationTests.h"
#import "FCAnimationFactory.h"
#import <math.h>

typedef float(^FCFloatBlock)(float);

FCFloatBlock genBezier (float p1, float p2)
{
    return ^float(float t){
        return 3*(1-t)*(1-t)*t*p1 + 3*(1-t)*t*t*p2 + t*t*t;
    };
}

FCFloatBlock genScaledBezier (float p1, float p2, float s1, float s2)
{
    return ^float(float t){
        return s1 + (3*(1-t)*(1-t)*t*p1 + 3*(1-t)*t*t*p2 + t*t*t)*(s2-s1);
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

- (void)testBezierBasicParameter
{
    float points[4];
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, ^float(float x) { return x*x; });
    STAssertEqualsWithAccuracy(points[1], 0.f, 0.0001f, @"control point p1 sholdn't have y component");
    STAssertEqualsWithAccuracy((1.f-points[3])/(1.f-points[2]), 2.f, 0.001, @"derivative on 1 should be 2.f");
}


/*
 * For raw accuracy test, we don't segment target function into pieces
 * and approximate it with fcSegment.
 * The raw accuracy of higher order function is low is reasonable and
 * acceptable.
 */

- (void)testRawLinearAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x));
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
}

- (void)testRawQuadAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return x*x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x)); 
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
}

- (void)testRawEaseOutQuadAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return -x*x + 2*x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x));
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
}

- (void)testRawCubicAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return x*x*x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x));
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
}

- (void)testRawQuartAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return x*x*x*x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x));
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.01, @"accuracy is acceptable in 0.01");
    /*
     * Accuracy is not as good as quad and cubic
     * It is 0.007612
     * Resonable since higher order is critical near boundaries
     */
}

- (void)testRawQuintAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return x*x*x*x*x;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t);
        sum += fabsf(y - f(x));
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.1, @"accuracy is acceptable in 0.1");
    /*
     * Accuracy of quint is not as good as well
     * It is 0.017502
     * Resonable since higher order is critical near boundaries
     */
}

- (void)testRawSineAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return sinf(x*M_PI_2);
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genBezier(points[0],points[2]);
    FCFloatBlock y_block = genBezier(points[1],points[3]);
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t), y_correct = f(x);
        sum += fabsf(y - y_correct);
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
    /*
     * Accuracy is 0.0044
     */
}

/*
 * Start from here, we use scaled bezier generator
 */

- (void)testCosineAccuracy
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return cosf(x*M_PI_2);
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genScaledBezier(points[0], points[2], 0, 1);
    FCFloatBlock y_block = genScaledBezier(points[1], points[3], f(0), f(1));
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t), y_correct = f(x);
        sum += fabsf(y - y_correct);
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
    
    /*
     * Accuracy is 0.000450
     */
}

- (void)testSegmentedQuintAccuracy
{
    float points[4];
    float sum = 0, num = 0, seg = 0.25;
    
    float(^f)(float) = ^float(float x) {
        return x*x*x*x*x;
    };
    
    for (float step = 0; step<1; step+=seg) {
        float roof = step+seg <= 1 ? step+seg : 1;
        fc_bezier_interpolation(&points[0],&points[2], step, roof, f);
        
        FCFloatBlock x_block = genScaledBezier(points[0], points[2], step, roof);
        FCFloatBlock y_block = genScaledBezier(points[1], points[3], f(step), f(roof));
        
        for (float t = 0; t < 1; t+=0.01){
            float x = x_block(t), y = y_block(t);
            sum += fabsf(y - f(x));
            num++;
        }
    }
    
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
    
    /*
     * Accuracy is 0.000746 with segment to half
     */
}


/* should fail
 * needed to add test nan functionality
 */

- (void)testOneFunction
{
    float points[4];
    float(^f)(float) = ^float(float x) {
        return 1;
    };
    fc_bezier_interpolation(&points[0],&points[2], 0, 1, f);
    
    FCFloatBlock x_block = genScaledBezier(points[0], points[2], 0, 1);
    FCFloatBlock y_block = genScaledBezier(points[1], points[3], f(0), f(1));
    
    float sum = 0, num = 0;
    for (float t = 0; t < 1; t+=0.01){
        float x = x_block(t), y = y_block(t), y_correct = f(x);
        sum += fabsf(y - y_correct);
        num++;
    }
    STAssertEqualsWithAccuracy(sum/num, 0.f, 0.001, @"accuracy is acceptable in 0.001");
    
    /*
     * Accuracy is 0.000450
     */
}

@end
