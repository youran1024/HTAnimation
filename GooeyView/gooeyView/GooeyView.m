//
//  GoosyView.m
//  gooeyView
//
//  Created by Mr.Yang on 15/12/11.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "GooeyView.h"

static NSInteger extraLength = 50;
static NSInteger springWidth = 40;

@interface GooeyView ()
{
    UIColor *_backgroundColor;
    CGRect _startRect, _endRect;
    CGFloat _diff;
    BOOL _isPresented;
    NSInteger _animationCount;
}

@property (nonatomic, strong)   UIVisualEffectView *blurView;
@property (nonatomic, strong)   CADisplayLink *displayLink;

@property (nonatomic, strong)   UIView *springView1;
@property (nonatomic, strong)   UIView *springView2;

@end

@implementation GooeyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat width = CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame) / 2 + extraLength;
        self.frame = CGRectMake(-width, 0, width, CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame));
        
        _startRect = CGRectMake(-springWidth, CGRectGetHeight(self.frame) / 2 - springWidth  / 2, springWidth, springWidth);
        _endRect = CGRectMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2 - springWidth  / 2, springWidth, springWidth);
        
        [self addSubview:self.springView1];
        [self addSubview:self.springView2];
        
        _backgroundColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
        
    }

    return self;
}

- (void)trigger
{
    if (!self.blurView.superview) {
        [self.superview insertSubview:self.blurView belowSubview:self];
        self.blurView.frame = self.superview.bounds;
    }
    
    CGRect startFrame = CGRectOffset(self.bounds, - CGRectGetWidth(self.frame), 0);
    CGRect endFrame = self.bounds;
    
    CGRect animationFrame = _isPresented ? _startRect : _endRect;
    CGRect selfFrame = _isPresented ? startFrame : endFrame;
    CGFloat alpha = _isPresented ? .0f : 1.0f;
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.frame = selfFrame;
    }];

    [self beginTrack];
    [UIView animateWithDuration:.7 delay:.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _springView1.frame = animationFrame;
        
    } completion:^(BOOL finished) {
        [self endTrack];
    }];
    
    [self beginTrack];
    [UIView animateWithDuration:.7 delay:.0 usingSpringWithDamping:.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _springView2.frame = animationFrame;
        
    } completion:^(BOOL finished) {
        
        [self endTrack];
    }];
    
    
    [UIView animateWithDuration:.3 animations:^{
        _blurView.alpha = alpha;
    }];
    
    _isPresented = !_isPresented;
    
}

- (void)beginTrack
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(trackAndDisplay)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    _animationCount++;
}

- (void)endTrack
{
    _animationCount--;
    if (_animationCount == 0) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)trackAndDisplay
{
    CALayer *layer1 = [self.springView1.layer presentationLayer];
    CALayer *layer2 = [self.springView2.layer presentationLayer];
    
    _diff = CGRectGetMinX(layer1.frame) - CGRectGetMinX(layer2.frame);
 
    NSLog(@"%f", _diff);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - extraLength, 0)];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.frame) - extraLength, CGRectGetHeight(self.frame)) controlPoint:CGPointMake(CGRectGetWidth(self.frame) - extraLength + _diff, CGRectGetHeight(self.frame) / 2)];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
    [path closePath];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_backgroundColor set];
    CGContextFillPath(context);
}

- (void)blurViewTaped
{
    [self trigger];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.frame) - extraLength, CGRectGetHeight(self.frame)), point)) {
        return YES;
    }
    
    return NO;
}

- (UIVisualEffectView *)blurView
{
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.superview.bounds;
        _blurView.alpha = .0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurViewTaped)];
        [_blurView addGestureRecognizer:tap];
    }

    return _blurView;
}

- (UIView *)springView1
{
    if (!_springView1) {
        _springView1 = [[UIView alloc] initWithFrame:_startRect];
        _springView1.backgroundColor = [UIColor greenColor];
        _springView1.hidden = YES;
    }

    return _springView1;
}

- (UIView *)springView2
{
    if (!_springView2) {
        _springView2 = [[UIView alloc] initWithFrame:_startRect];
        _springView2.backgroundColor = [UIColor orangeColor];
        _springView2.hidden = YES;
    }
    
    return _springView2;
}


@end
