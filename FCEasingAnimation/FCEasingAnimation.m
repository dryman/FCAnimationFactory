//
//  FCEasingAnimation.m
//  FCEasingAnimation
//
//  Created by dryman on 12/10/15.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCEasingAnimation.h"

void fcSegment(float *out, float x1, float x2, float(^block)(float x))
{
    const float h = sqrtf(FLT_EPSILON);
    float y1, y2, y1_t, y2_t, x_mid, y_mid;
    
    y1 = block(x1);
    y2 = block(x2);
    
    y1_t = (block(x1+h) - block(x1-h))/(2.f*h);
    y2_t = (block(x2+h) - block(x2-h))/(2.f*h);

    x_mid = (x1 + x2) / 2.f;
    y_mid = block(x_mid);
    
    out[0] =  (y2_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(x2-x1));
    out[1] =  y1_t * (y2_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(y2-y1));
    
    out[2] = 1 - (y1_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2))/ (3*(y2_t-y1_t)*(x2-x1));
    out[3] = 1 - y2_t * (y1_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(y2-y1));

}


@implementation FCEasingAnimation

@end
