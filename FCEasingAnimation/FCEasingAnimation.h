//
//  FCEasingAnimation.h
//  FCEasingAnimation
//
//  Created by dryman on 12/10/15.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import <Foundation/Foundation.h>

void fcSegment(float *out, float x1, float x2, float(^block)(float x));

@interface FCEasingAnimation : NSObject

@end
