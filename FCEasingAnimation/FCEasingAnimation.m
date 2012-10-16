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
    
    x_mid = (x1 + x2) / 2.f;
    y_mid = block(x_mid);
    
    float theta_1 = atan2f(block(x1+h)-block(x1-h), 2.f*h);
    float theta_2 = atan2f(block(x2+h)-block(x2-h), 2.f*h);
    float sin_1 = sinf(theta_1), cos_1 = cosf(theta_1);
    float sin_2 = sinf(theta_2), cos_2 = cosf(theta_2);
    
    float x_comb = 8*x_mid - 4*x1 - 4*x2;
    float y_comb = 8*y_mid - 4*y1 - 4*y2;
    float base = 3*(sin_2*cos_1 - sin_1*cos_2);
    
    out[0] = (sin_2*cos_1*x_comb - cos_2*cos_1*y_comb) / (base*(x2 - x1));
    
    out[1] = (sin_2*sin_1*x_comb - cos_2*sin_1*y_comb) / (base*(y2 - y1));
    
    out[2] = 1 - (sin_1*cos_2*x_comb - cos_1*cos_2*y_comb) / (base*(x2-x1));
    
    out[3] = 1 - (sin_1*sin_2*x_comb - cos_1*sin_2*y_comb) / (base*(y2-y1));

    /*
    y1_t = (block(x1+h) - block(x1-h))/(2.f*h);
    y2_t = (block(x2+h) - block(x2-h))/(2.f*h);
    
    out[0] =  (y2_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(x2-x1));
    out[1] =  y1_t * (y2_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(y2-y1));
    
    out[2] = 1 - (y1_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2))/ (3*(y2_t-y1_t)*(x2-x1));
    out[3] = 1 - y2_t * (y1_t*(8*x_mid - 4*x1 - 4*x2)-(8*y_mid - 4*y1 - 4*y2)) / (3*(y2_t-y1_t)*(y2-y1));
     */

}


@implementation FCEasingAnimation

@end
