//
//  ViewController.m
//  AnimationDemo
//
//  Created by Mr.Yang on 15/12/3.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property (nonatomic, strong) CALayer *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *layer = [[CALayer alloc] init];
    _layer = layer;

    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0f, CGRectGetHeight(self.view.frame) / 2.0f);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.cornerRadius = 100 / 2.0f;
    
    layer.masksToBounds = YES;
    
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 2.0f;
    
    layer.delegate = self;
    
    [self.view.layer addSublayer:layer];
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"%@", anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@", anim);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];

    [CATransaction begin];
    [CATransaction setAnimationDuration:.250f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    _layer.borderColor = [UIColor greenColor].CGColor;
    _layer.borderWidth = 6.0f;
    _layer.transform = CATransform3DMakeScale(1.3f, 1, 1);
    [CATransaction setCompletionBlock:^{
        _layer.transform = CATransform3DIdentity;
        _layer.borderWidth = .0f;
    }];
    _layer.position = point;
    [CATransaction commit];
    
}


@end
