//
//  FCValueTest.m
//  FCEasingAnimation

/*
 
 Created by Felix Chern on 12/10/25.
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

/*
 
 Scatch board for testing if those values can be determined at runtime
 
 Single float
 ============
 
 Use NSNumber
 
 borderWidth
 cornerRadius
 opacity
 shadowOpacity
 shadowRadius
 zPosition
 contents * Can use CATransition startProgress/endProgress to simulate it

 Double floats
 =============
 
 anchorPoint
 position
 shadowOffset
 
 Frame/bounds
 ============
 
 bounds
 contentsRect
 frame
 
 Color
 =====
 
 backgroundColor
 borderColor
 shadowColor
 
 Transform
 =========
 
 transform
 sublayerTransform
 
 */

#import <SenTestingKit/SenTestingKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface FCValueTest : SenTestCase
{
    CALayer* layer;
}
@end

@implementation FCValueTest

- (void)setUp
{
    [super setUp];
    layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 50, 50);
    layer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:0.5f] CGColor];
}

- (void)testNumberAndValue
{
    id value;
    
    value = [NSNumber numberWithFloat:0.3f];
    STAssertTrue([value isKindOfClass:[NSNumber class]], @"can detect NSNumber");
    
    value = [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)];
    STAssertTrue([value isKindOfClass:[NSValue class]], @"can detect NSValue");
    STAssertEquals(strcmp([value objCType], @encode(CGPoint)), 0, @"strcmp returns 0 when equal");
    
    value = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    STAssertTrue([value isKindOfClass:[NSValue class]], @"can detect NSValue");
    STAssertEquals(strcmp([value objCType], @encode(CGSize)), 0, @"strcmp returns 0 when equal");
    
    value = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    STAssertTrue([value isKindOfClass:[NSValue class]], @"can detect NSValue");
    STAssertEquals(strcmp([value objCType], @encode(CGRect)), 0, @"strcmp returns 0 when equal");
    
    CGAffineTransform t = CGAffineTransformMakeTranslation(200, 200);
    value = [NSValue valueWithCATransform3D:CATransform3DMakeAffineTransform(t)];
    STAssertEquals(strcmp([value objCType], @encode(CATransform3D)), 0, @"strcmp returns 0 when equal");
    // I don't think we can support transfrom interpolation currently...

}

- (void)testCGColorRef
{
    id value = (id)[[UIColor redColor] CGColor];
    STAssertTrue(![value isKindOfClass:[NSNumber class]], @"is not a NSNumber");
    STAssertTrue(![value isKindOfClass:[NSValue class]], @"is not a NSValue");
    STAssertEquals(CFGetTypeID((__bridge CFTypeRef)value), CGColorGetTypeID(), @"is a CGColor");
}

- (void)testCGImageRef
{
    NSString *path = nil;
    for (NSBundle* bundle in [NSBundle allBundles]) {
        path = [bundle pathForResource:@"Icon" ofType:@"png"];
        if (path!=nil) {
            break;
        }
    }
    STAssertNotNil(path, @"resource found");
    
    UIImage* img = [UIImage imageWithContentsOfFile:path];
    STAssertNotNil(img, @"image loaded");
    
    id value = (id)[img CGImage];
    
    STAssertTrue(![value isKindOfClass:[NSNumber class]], @"is not NSNumber");
    STAssertEquals(CFGetTypeID((__bridge CFTypeRef)value), CGImageGetTypeID(), @"is CGImage");
}


@end
