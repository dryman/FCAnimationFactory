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
#import "FCValueAnimationFactory.h"

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
    
    CGFloat size = 130.f;
	UIImage *heartImg = [UIImage imageNamed:@"heart.png"];
    
    CALayer *heartLayer = [CALayer layer];
    heartLayer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:.5f] CGColor];
    heartLayer.frame = CGRectMake(0, 0, size, size);
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contentsScale = [[UIScreen mainScreen] scale];
    maskLayer.frame = CGRectMake(0, 0, size, size);
    maskLayer.bounds = CGRectMake(40, 40, 50, 50);
    maskLayer.contents = (__bridge id)([heartImg CGImage]);
    
    heartLayer.mask = maskLayer;
    
    CAReplicatorLayer *repLayer = [CAReplicatorLayer layer];
    [repLayer setContentsScale:[[UIScreen mainScreen] scale]];
    repLayer.bounds = CGRectMake(0, 0, size, size);
    repLayer.anchorPoint = CGPointMake(.5f, 0.f);
    CGFloat y = self.view.bounds.size.height;
    CGFloat dy = self.navigationController.navigationBar.bounds.size.height;
    repLayer.position = CGPointMake(160, (y-dy)/2.f-size);
    repLayer.instanceCount = 2;
    
    CATransform3D transform = CATransform3DScale(CATransform3DIdentity, 1, -1, 1);
    transform = CATransform3DTranslate(transform, 0, -size*2.f, 1.0);
    repLayer.instanceTransform = transform;
    
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.contentsScale = [[UIScreen mainScreen] scale];
    gradLayer.anchorPoint = CGPointMake(.5, 0);
    gradLayer.colors = @[
        (__bridge id)[[[UIColor whiteColor] colorWithAlphaComponent:.25f] CGColor],
        (__bridge id)[[UIColor whiteColor] CGColor]
    ];
    gradLayer.bounds = CGRectMake(0, 0, repLayer.frame.size.width, size);
    gradLayer.position = CGPointMake(self.view.frame.size.width/2.f, (y-dy)/2.f);
    gradLayer.zPosition = 1;
    
    [repLayer addSublayer:heartLayer];
    [self.view.layer addSublayer:repLayer];
    [self.view.layer addSublayer:gradLayer];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    FCValueAnimationFactory *aniFac = [[FCValueAnimationFactory alloc] init];
    aniFac.values = @[
        [NSValue valueWithCGSize:CGSizeMake(50, 50)],
        [NSValue valueWithCGSize:CGSizeMake(80, 80)],
        [NSValue valueWithCGSize:CGSizeMake(60, 60)],
        [NSValue valueWithCGSize:CGSizeMake(90, 90)],
        [NSValue valueWithCGSize:CGSizeMake(50, 50)]
    ];
    aniFac.timingBlocks = @[
        ^(float x){return x*x*x;},
        ^(float x){return 1.f +(x-1.f)*(x-1.f)*(x-1.f);},
        ^(float x){return x*x*x;},
        ^(float x){return sqrtf((2.f - x)*x);}
    ];
    aniFac.durations = @[
        @.5f,
        @.15f,
        @.15f,
        @.75f
    ];
    CAKeyframeAnimation *ani = [aniFac animation];
    ani.keyPath = @"bounds.size";
    ani.repeatCount = HUGE_VALF;

    [maskLayer addAnimation:ani forKey:@"beating"];
    [CATransaction commit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
