//
//  FCEasingAnimation.m
//  FCEasingAnimation
//
//  Created by dryman on 12/10/15.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCAnimationFactory.h"

void fc_bezier_interpolation(float c1[2], float c2[2], float x1, float x2, float(^block)(float x))
{
    const float h = sqrtf(FLT_EPSILON);
    float y1, y2, x_mid, y_mid;
    
    y1 = block(x1);
    y2 = block(x2);
    
    x_mid = (x1 + x2) / 2.f;
    y_mid = block(x_mid);
    
    float theta_1 = atan2f(block(x1+h)-block(x1-h), 2.f*h);
    float theta_2 = atan2f(block(x2+h)-block(x2-h), 2.f*h);
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
        _normalizedTimings = [NSArray arrayWithObject:^float(float x){return x;}]; // linear interpolation
        _timingBlocks = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:0.f],
                         [NSNumber numberWithFloat:1.f], nil];
        _totalDuration = [NSNumber numberWithFloat:.25f];
    }
    return self;
}

+ (FCAnimationFactory*)factory
{
    return [[FCAnimationFactory alloc] init];
}

- (void)setSegmentedDurations:(NSArray *)segmentedDurations
{
    NSNumber* sum = [segmentedDurations valueForKeyPath:@"@sum.floatValue"];
    NSMutableArray* timings = [NSMutableArray arrayWithCapacity:segmentedDurations.count];
    for (NSNumber* time in segmentedDurations) {
        [timings addObject: [NSNumber numberWithFloat:time.floatValue/sum.floatValue]];
    }
    self.normalizedTimings = timings;
    self.totalDuration = sum;
}

- (NSArray*)segmentedDurations
{
    NSMutableArray *retDurations = [NSMutableArray arrayWithCapacity:self.normalizedTimings.count];
    float totalDuration = self.totalDuration.floatValue;
    for (NSNumber* time in self.normalizedTimings) {
        [retDurations addObject:[NSNumber numberWithFloat:(time.floatValue * totalDuration)]];
    }
    return [NSArray arrayWithArray: retDurations]; // Cast to NSArray
}

- (CAKeyframeAnimation*) animation
{
    NSMutableArray *keyTimes = [NSMutableArray array];
    NSMutableArray *timingFunctions = [NSMutableArray array];
    
    // durations are much more convinient to do calculations!
    [self.segmentedDurations enumerateObjectsUsingBlock:^(NSNumber* nsDuration, NSUInteger idx, BOOL *stop) {
        float duration = nsDuration.floatValue;
        float step = duration/ceilf(duration*2.f);
        
    }];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyTimes = keyTimes;
    animation.timingFunctions = timingFunctions;
    return animation;
}

@end
