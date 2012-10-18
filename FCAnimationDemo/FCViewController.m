//
//  FCViewController.m
//  FCAnimationDemo
//
//  Created by dryman on 12/10/18.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import "FCViewController.h"
#import "FCValueAnimationFactory.h"

@interface FCViewController ()

@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_layer = [CALayer layer];
    _layer.backgroundColor = [[[UIColor redColor] colorWithAlphaComponent:.2f] CGColor];
    _layer.bounds = CGRectMake(0, 0, 30, 30);
    _layer.position = CGPointMake(160.f, 50.f);
    _layer.cornerRadius = 15.f;
    _layer.borderWidth = 3.f;
    _layer.borderColor = [[[UIColor redColor] colorWithAlphaComponent:.5f] CGColor];
    self.atTop = YES;
    
    [self.view.layer addSublayer:_layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender
{
    if (self.atTop) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _layer.position = CGPointMake(160.f, 300.f);
        CAKeyframeAnimation *animation = [FCValueAnimationFactory animationWithName:@"cubicEaseIn" fromValue:@50.f toValue:@300.f duration:@1.f];
        animation.keyPath = @"position.y";
        [_layer addAnimation:animation forKey:@"myUselessKey"];
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _layer.position = CGPointMake(160.f, 50.f);
        CAKeyframeAnimation *animation = [FCValueAnimationFactory animationWithName:@"linear" fromValue:@300.f toValue:@50.f duration:@1.f];
        animation.keyPath = @"position.y";
        [_layer addAnimation:animation forKey:@"myUselessKey"];
        [CATransaction commit];
    }
    self.atTop = !self.atTop;
}
@end
