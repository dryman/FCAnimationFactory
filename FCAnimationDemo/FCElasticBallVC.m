//
//  FCViewController.m
//  FCAnimationDemo
//

/*
 
 Created by Felix Chern on 12/10/18.
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

#import "FCElasticBallVC.h"
#import "FCBasicAnimationFactory.h"

@interface FCElasticBallVC ()

@end

@implementation FCElasticBallVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	_layer = [CALayer layer];
    _layer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:.4f] CGColor];
    _layer.bounds = CGRectMake(0, 0, 30, 30);
    _layer.position = CGPointMake(160.f, 100.f);
    _layer.cornerRadius = 15.f;
//    _layer.borderWidth = 3.f;
//    _layer.borderColor = [[[UIColor redColor] colorWithAlphaComponent:.5f] CGColor];
    self.atTop = YES;
    
    UIImage *touchImg = [UIImage imageNamed:@"touch.png"];
    CALayer *touchLayer = [CALayer layer];
    touchLayer.contentsScale = [[UIScreen mainScreen] scale];
    touchLayer.contents = (__bridge id)touchImg.CGImage;
    touchLayer.frame = CGRectMake(120, 150, 128, 128);
    touchLayer.opacity = 1.f;
    touchLayer.zPosition = 1;
    
    [self.view.layer addSublayer:_layer];
    [self.view.layer addSublayer:touchLayer];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shakeTheBall:)]];
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        touchLayer.opacity = 0;
        CABasicAnimation* ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
        ani.duration = .5f;
        ani.fromValue = @1.f;
        ani.toValue = @0.f;
        [touchLayer addAnimation:ani forKey:@"touchIcon"];
        [CATransaction commit];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shakeTheBall:(UIGestureRecognizer *)recognizer
{
    UIColor * __autoreleasing redColor = [[UIColor redColor] colorWithAlphaComponent:.4f];
    UIColor * __autoreleasing blueColor = [[UIColor blueColor] colorWithAlphaComponent:.4f];
    CGColorRef redRef = CGColorRetain(redColor.CGColor);
    CGColorRef blueRef = CGColorRetain(blueColor.CGColor);
    
    CGPoint nextPt = [recognizer locationInView:self.view];
    CGPoint curPt = _layer.position;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _layer.backgroundColor = blueRef;
    _layer.position = nextPt;
    CAKeyframeAnimation *colorAni = [FCBasicAnimationFactory animationWithName:@"circularEaseOut"
                                                                     fromValue:(__bridge id)redRef
                                                                       toValue:(__bridge id)blueRef
                                                                      duration:@1.5f];
    colorAni.keyPath = @"backgroundColor";
    [_layer addAnimation:colorAni forKey:@"mycolorKey"];
    CAKeyframeAnimation *animation = [FCBasicAnimationFactory animationWithName:@"elasticEaseOut"
                                                                      fromValue:[NSValue valueWithCGPoint:curPt]
                                                                        toValue:[NSValue valueWithCGPoint:nextPt]
                                                                       duration:@1.5f];
    animation.keyPath = @"position";
    [_layer addAnimation:animation forKey:@"myUselessKey"];
    [CATransaction commit];
    
    /*
    if (self.atTop) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _layer.backgroundColor = blueRef;
        _layer.position = CGPointMake(160.f, 300.f);
        CAKeyframeAnimation *colorAni = [FCBasicAnimationFactory animationWithName:@"circularEaseOut"
                                                                         fromValue:(__bridge id)redRef
                                                                           toValue:(__bridge id)blueRef
                                                                          duration:@1.5f];
        colorAni.keyPath = @"backgroundColor";
        [_layer addAnimation:colorAni forKey:@"mycolorKey"];
        CAKeyframeAnimation *animation = [FCBasicAnimationFactory animationWithName:@"elasticEaseOut"
                                                                          fromValue:@100.f
                                                                            toValue:@300.f
                                                                           duration:@1.5f];
        animation.keyPath = @"position.y";
        [_layer addAnimation:animation forKey:@"myUselessKey"];
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _layer.backgroundColor = redRef;
        _layer.position = CGPointMake(160.f, 100.f);
        CAKeyframeAnimation *colorAni = [FCBasicAnimationFactory animationWithName:@"circularEaseOut"
                                                                         fromValue:(__bridge id)blueRef
                                                                           toValue:(__bridge id)redRef
                                                                          duration:@1.5f];
        colorAni.keyPath = @"backgroundColor";
        [_layer addAnimation:colorAni forKey:@"mycolorKey"];
        CAKeyframeAnimation *animation = [FCBasicAnimationFactory animationWithName:@"elasticEaseOut"
                                                                          fromValue:@300.f
                                                                            toValue:@100.f
                                                                           duration:@1.5f];
        animation.keyPath = @"position.y";
        [_layer addAnimation:animation forKey:@"myUselessKey"];
        [CATransaction commit];
    }
    self.atTop = !self.atTop;
     */
    CGColorRelease(redRef);
    CGColorRelease(blueRef);
}
@end
