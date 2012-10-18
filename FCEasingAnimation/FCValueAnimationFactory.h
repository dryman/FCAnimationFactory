//
//  FCValueAnimationFactory.h
//  FCEasingAnimation
//
//  Created by 陳仁乾 on 12/10/18.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCAnimationFactory.h"

@interface FCValueAnimationFactory : FCAnimationFactory <NSCopying>
{
    NSArray* _normalizedValues;
    NSNumber* _fromValue;
    NSNumber* _toValue;
}
@property (copy) NSArray* normalizedValues;
@property (copy) NSNumber* fromValue;
@property (copy) NSNumber* toValue;

+ (CAKeyframeAnimation*) animationWithName:(NSString*)name fromValue:(NSNumber*)fv toValue: (NSNumber*)tv duration:(NSNumber*)duration;

@end
