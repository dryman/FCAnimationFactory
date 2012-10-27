//
//  FCAnimationFactory.m
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

#import "FCAnimationFactory.h"


void fc_bezier_interpolation(float c1[2], float c2[2], float x1, float x2, float(^block)(float x))
{
    const float h = sqrtf(FLT_EPSILON);
    float y1, y2, x_mid, y_mid;
    
    y1 = block(x1);
    y2 = block(x2);
    
    x_mid = (x1 + x2) / 2.f;
    y_mid = block(x_mid);
    
    float theta_1 = atan2f(-1.5f*block(x1) + 2.f*block(x1+h) - .5f*block(x1+2.f*h), h);
    float theta_2 = atan2f( 1.5f*block(x2) - 2.f*block(x2-h) + .5f*block(x2-2.f*h), h);
    float sin_1 = sinf(theta_1), cos_1 = cosf(theta_1);
    float sin_2 = sinf(theta_2), cos_2 = cosf(theta_2);
    
    float x_comb = 8*x_mid - 4*x1 - 4*x2;
    float y_comb = 8*y_mid - 4*y1 - 4*y2;
    float base = 3*(sin_2*cos_1 - sin_1*cos_2);
    
    c1[0] = (sin_2*cos_1*x_comb - cos_2*cos_1*y_comb) / (base*(x2 - x1));
    
    c1[1] = (sin_2*sin_1*x_comb - cos_2*sin_1*y_comb) / (base*(y2 - y1));
    
    c2[0] = 1 - (sin_1*cos_2*x_comb - cos_1*cos_2*y_comb) / (base*(x2-x1));
    
    c2[1] = 1 - (sin_1*sin_2*x_comb - cos_1*sin_2*y_comb) / (base*(y2-y1));
}


@implementation FCAnimationFactory
@synthesize normalizedTimings = _normalizedTimings;
@synthesize timingBlocks = _timingBlocks;
@synthesize totalDuration = _totalDuration;

- (FCAnimationFactory*)init
{
    if (self = [super init]) {
        _normalizedTimings = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.f],
                               [NSNumber numberWithFloat:1.f], nil];
        _timingBlocks = [NSArray arrayWithObject:^float(float x){return x;}]; // linear interpolation
        
        _totalDuration = [NSNumber numberWithFloat:.25f];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FCAnimationFactory *factoryCopy = [[FCAnimationFactory allocWithZone:zone] init];
    factoryCopy.normalizedTimings = _normalizedTimings;
    factoryCopy.timingBlocks = _timingBlocks;
    factoryCopy.totalDuration = _totalDuration;
    return factoryCopy;
}

- (void)setDurations:(NSArray *)segmentedDurations
{
    // TODO: can add negative asssertions in future
    NSNumber* sum = [segmentedDurations valueForKeyPath:@"@sum.floatValue"];
    float totalDuration = sum.floatValue;
    float accumulator = 0.f;
    NSMutableArray* timings = [NSMutableArray arrayWithCapacity:segmentedDurations.count+1];
    [timings addObject:[NSNumber numberWithFloat:0.f]];
    
    for (NSNumber* nsDuration in segmentedDurations) {
        float duration = nsDuration.floatValue;
        accumulator += duration;
        [timings addObject: [NSNumber numberWithFloat:accumulator/totalDuration]];
    }
    self.normalizedTimings = timings;
    self.totalDuration = sum;
}

- (NSArray*)durations
{
    NSUInteger count = self.normalizedTimings.count - 1;
    float totalDuration = self.totalDuration.floatValue;
    NSMutableArray *retDurations = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        float a = [[self.normalizedTimings objectAtIndex:i] floatValue];
        float b = [[self.normalizedTimings objectAtIndex:i+1] floatValue];
        [retDurations addObject:[NSNumber numberWithFloat:(b-a)*totalDuration]];
    }

    return [NSArray arrayWithArray: retDurations]; // Cast to NSArray
}

- (CAKeyframeAnimation*) animation
{
    NSAssert(0, @"Overwrite this method in subclass");
    return [CAKeyframeAnimation animation]; //cheat compiler warnings
}

- (id(^)(float))makeValueScalingBlockFromValue:(id)fromValue ToValue:(id)toValue
{
    if (fromValue==nil || toValue==nil) NSAssert(0, @"fromValue and toValue must not be nil");
    
    id value = fromValue;
    
    /*
     * single float is handled in NSNumber
     */
    if ([value isKindOfClass:[NSNumber class]]) {
        float v1 = [(NSNumber*)fromValue floatValue];
        float v2 = [(NSNumber*)toValue floatValue];
        float diffValue = v2 - v1;
        return ^id(float factor){
            float result = factor*diffValue + v1;
            return [NSNumber numberWithFloat:result];
        };
    }
    
    /*
     * NSValue handles CGPoint, CGSize, CGRect, and CATransform3D
     */
    if ([value isKindOfClass:[NSValue class]]) {
        const char* objCType = [value objCType];
        if (strcmp(objCType, @encode(CGPoint))) {
            CGPoint pt0, pt1;
            [(NSValue*)fromValue getValue:&pt0];
            [(NSValue*)toValue getValue:&pt1];
            return ^id(float factor){
                float x = (pt1.x - pt0.x)*factor + pt0.x;
                float y = (pt1.y - pt0.y)*factor + pt0.y;
                return [NSValue valueWithCGPoint:CGPointMake(x, y)];
            };
        } else if (strcmp(objCType, @encode(CGSize))) {
            CGSize size0, size1;
            [(NSValue*)fromValue getValue:&size0];
            [(NSValue*)toValue getValue:&size1];
            return ^id(float factor){
                float w = (size1.width - size0.width)*factor + size0.width;
                float h = (size1.height - size0.height)*factor + size0.height;
                return [NSValue valueWithCGSize:CGSizeMake(w, h)];
            };
        } else if (strcmp(objCType, @encode(CGRect))) {
            CGRect rect0, rect1;
            [(NSValue*)fromValue getValue:&rect0];
            [(NSValue*)toValue getValue:&rect1];
            return ^id(float factor){
                float x = (rect1.origin.x - rect0.origin.x)*factor + rect0.origin.x;
                float y = (rect1.origin.y - rect0.origin.y)*factor + rect0.origin.y;
                float w = (rect1.size.width - rect0.size.width)*factor + rect0.size.width;
                float h = (rect1.size.height - rect0.size.height)*factor + rect0.size.height;
                return [NSValue valueWithCGRect:CGRectMake(x, y, w, h)];
            };
        } else if (strcmp(objCType, @encode(CATransform3D))) {
            NSAssert(0, @"CATransform3D type currently not supported");
        } else {
            NSAssert(0, @"Unknown NSValue type %s",objCType);
        }
    }
    
    if (CFGetTypeID((__bridge CFTypeRef)value) == CGColorGetTypeID()) {
        return ^id(float factor){
            CGColorRef fromColor = (__bridge CGColorRef)fromValue;
            CGColorRef toColor = (__bridge CGColorRef)toValue;
            size_t num = CGColorGetNumberOfComponents(fromColor);
            const CGFloat *fromComp = CGColorGetComponents(fromColor);
            const CGFloat *toComp = CGColorGetComponents(toColor);
            
            CGFloat newComp[num]; // same as amalloc
            for (size_t i = 0; i < num; ++i) {
                newComp[i] = (toComp[i] - fromComp[i]) * factor + fromComp[i];
            }
            CGColorRef retColor = CGColorCreate(CGColorGetColorSpace(fromColor), newComp);
            return (__bridge_transfer id)retColor;
        };
    }
    if (CFGetTypeID((__bridge CFTypeRef)value) == CGImageGetTypeID()) {
        NSAssert(0, @"CGImageRef should be handled in another class");
    }
    
    NSAssert(0, @"value type unknown");
    return ^id(float factor){ return nil;};    // turn off compiler warnings
}

@end
