//
//  FCBeatingHeartVC.m
//  FCEasingAnimation
//

/*
 
 Created by Felix Chern on 12/10/28.
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


#import "FCBeatingHeartVC.h"
#import <QuartzCore/QuartzCore.h>

@interface FCBeatingHeartVC ()

@end

@implementation FCBeatingHeartVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImage *heartImg = [UIImage imageNamed:@"heart.png"];
    CALayer *heartLayer = [CALayer layer];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, 70, 70);
    maskLayer.bounds = CGRectMake(10,10,50,50);
    maskLayer.anchorPoint = CGPointMake(.5f, .5f);
    maskLayer.contents = (__bridge id)([heartImg CGImage]);
    heartLayer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:.5f] CGColor];
    heartLayer.mask = maskLayer;

    
    CGRect bounds = self.view.bounds;
    CGFloat dy = self.navigationController.navigationBar.bounds.size.height;
    heartLayer.frame = CGRectMake((bounds.size.width-70.f)/2.f, (bounds.size.height-dy-70.f)/2.f, 70, 70);
    [self.view.layer addSublayer:heartLayer];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    ani.fromValue = [NSValue valueWithCGSize:CGSizeMake(50, 50)];
    ani.toValue = [NSValue valueWithCGSize:CGSizeMake(70, 70)];
    ani.duration = 1.f;
    ani.repeatCount = HUGE_VALF;
    ani.autoreverses = YES;
    
    //[heartLayer addAnimation:ani forKey:@"beating"];
    [maskLayer addAnimation:ani forKey:@"beating"];
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
