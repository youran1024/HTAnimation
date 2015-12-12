//
//  ViewController.m
//  SplashAnimation
//
//  Created by Mr.Yang on 15/12/10.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL _isPresented;
}

@property (nonatomic, strong)   UIImageView *imageView;
@property (nonatomic, strong)   CALayer *layer;
@property (nonatomic, strong)   UIView *maskBackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(300, 100, 60, 60);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"triger" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)initView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"home_demo"];
    }
    
    [self.view addSubview:_imageView];
    
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
        _layer.position = self.view.center;
        _layer.bounds = CGRectMake(0, 0, 60, 60);
    }
    
    //  遮盖的地方会显示出来，没遮盖的地方会变成透明
    _imageView.layer.mask = _layer;
    
    if (!_maskBackView) {
        _maskBackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskBackView.backgroundColor = [UIColor whiteColor];
    }
    
    [_imageView addSubview:_maskBackView];
}

- (void)doAnimation
{
    CGRect bounds1 = _layer.bounds;
    CGRect bounds2 = CGRectMake(0, 0, 50, 50);
    CGRect bounds3 = CGRectMake(0, 0, 2000, 2000);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.beginTime = CACurrentMediaTime() + 1.0f;
    animation.duration = 1.0f;
    
    animation.values = @[[NSValue valueWithCGRect:bounds1],
                         [NSValue valueWithCGRect:bounds2],
                         [NSValue valueWithCGRect:bounds3]];
    
    animation.keyTimes = @[@0, @.5, @1];
    
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [_imageView.layer.mask addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:.1 delay:1.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _maskBackView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        [_maskBackView removeFromSuperview];
        _maskBackView = nil;
    }];
    
    [UIView animateWithDuration:.25 delay:1.3 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        _imageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _imageView.transform = CGAffineTransformMakeScale(.95, .95);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.1 delay:.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                _imageView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    

}

@end
