//
//  FCViewController.h
//  FCAnimationDemo
//
//  Created by dryman on 12/10/18.
//  Copyright (c) 2012年 dryman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FCViewController : UIViewController

@property (nonatomic, strong) CALayer* layer;
@property (nonatomic, assign) BOOL atTop;
- (IBAction)buttonPressed:(id)sender;

@end
