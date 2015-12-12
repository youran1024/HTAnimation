//
//  CuiteView.m
//  BubbleAnimation
//
//  Created by Mr.Yang on 15/12/7.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "StretchBubble.h"

static CGFloat defaultBubbleWidth = 23.0f;

struct BubbleFrame {
    CGPoint center;
    double r;
};

struct SketchPath {
    CGPoint A;
    CGPoint B;
    CGPoint C;
    CGPoint D;
    CGPoint O;
    CGPoint P;
};

typedef struct BubbleFrame BubbleFrame;
typedef struct SketchPath SketchPath;

@interface StretchBubble ()
{
    UIView *_frontView;
    UIView *_backView;
    
    CAShapeLayer *_shapLayer;
    
    BubbleFrame _frontViewFrame;
    BubbleFrame _backViewFrame;
    
    SketchPath _sketchPath;
    
    CGFloat _centerDistance;
    
    CGFloat _cosDigree;
    CGFloat _sinDigree;
    
}

@property (nonatomic, assign)   CGFloat viscosity;
@property (nonatomic, assign)   CGFloat bubbleWidth;

@end



@implementation StretchBubble

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(100, 100, defaultBubbleWidth, defaultBubbleWidth)];
    
    if (self) {
        [self initVariable];
        
        [self initView];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initVariable];
        
        _bubbleWidth = frame.size.width;
        
        [self initView];
    }

    return self;
}

- (void)initVariable
{
    _tintColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
    _bubbleWidth = defaultBubbleWidth;
    _frontViewFrame.r = _bubbleWidth / 2.0f;
    _backViewFrame.r = _bubbleWidth / 2.0f;
    _viscosity = 30.0f;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)initView
{
    _frontView = [self bubbleView];
    _backView = [self bubbleView];
    [_frontView addSubview:self.titleLabel];
    self.titleLabel.center = _frontView.center;
    CGRect bounds = _frontView.bounds;
    self.titleLabel.frame = bounds;
    
    _frontView.backgroundColor = _tintColor;
    _backView.backgroundColor = _tintColor;
    
    [self addSubview:_backView];
    [self addSubview:_frontView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPanGestureAction:)];
    [_frontView addGestureRecognizer:pan];
    
    [self calculateBubbleStretchPath];
}

#pragma mark - PanGesture
- (void)bubbleViewPanGestureAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self];
    _frontView.center = point;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _backView.hidden = NO;
        
        [_frontView.layer removeAllAnimations];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        [self.layer insertSublayer:layer below:_frontView.layer];
        _shapLayer = layer;
        
        [self calculateBubbleStretchPath];
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (_backViewFrame.r <= 6.0f) {
            _backView.hidden = YES;
            [_shapLayer removeFromSuperlayer];
            
        }else {
            [self calculateBubbleStretchPath];
        }
        
    }else {
        // state End or cancel or faile
        _backView.hidden = YES;
        [_shapLayer removeFromSuperlayer];
        [UIView animateWithDuration:.5 delay:.0f usingSpringWithDamping:.4f initialSpringVelocity:.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _frontView.center = _backView.center;
        } completion:^(BOOL finished) {
            
        }];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self doLeftRightRockAnimation:_frontView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_frontView.layer removeAllAnimations];
}

- (void)doLeftRightRockAnimation:(UIView *)view
{
    _backView.hidden = YES;
    
    CGAffineTransform leftTransform = CGAffineTransformTranslate(_backView.transform, -6, 0);
    CGAffineTransform rightTransform = CGAffineTransformTranslate(_backView.transform, 6, 0);
    CGAffineTransform transform = _frontView.transform;
    
    _frontView.transform = rightTransform;
    [UIView animateWithDuration:.15 animations:^{
        [UIView setAnimationRepeatCount:4];
        _frontView.transform = leftTransform;
    } completion:^(BOOL finished) {
        _frontView.transform = transform;
    }];
    
    /*
    CGPoint center = view.center;
    NSArray *centers = @[@(center.x + 9), @(center.x - 9), @(center.x + 6), @(center.x - 6), @(center.x)];
    NSArray *times = @[@(.2), @(.4), @(.6), @(.8), @(1.0)];
    [UIView animateKeyframesWithDuration:.35 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveLinear|UIViewKeyframeAnimationOptionRepeat animations:^{
        
        for (NSNumber *centerX in centers) {
            NSInteger index = [centers indexOfObject:centerX];
            double beginTime = [times[index] doubleValue];
            if (index == 0) {
                beginTime = .0;
            }

            double duration = [times[index] doubleValue] - beginTime;
            [UIView addKeyframeWithRelativeStartTime:beginTime  relativeDuration:duration animations:^{
                CGPoint center = view.center;
                center.x = [centers[index] floatValue];
                view.center = center;
            }];
        }
        
    } completion:^(BOOL finished) {
        
    }];
     */
}



- (void)calculateBubbleStretchPath
{
    _frontViewFrame.center = _frontView.center;
    _backViewFrame.center = _backView.center;
    
    CGPoint _frontViewCenter = _frontViewFrame.center;
    CGPoint _backViewCenter = _backViewFrame.center;
    
    _centerDistance = sqrt(pow((_frontViewCenter.x - _backViewCenter.x), 2) +pow((_frontViewCenter.y - _backViewCenter.y), 2));
    
    if (_centerDistance == 0) {
        
        return;
    }else {
        
        _cosDigree = (_frontViewCenter.y - _backViewCenter.y) / _centerDistance;
        _sinDigree = (_frontViewCenter.x - _backViewCenter.x) / _centerDistance;
    }
    
    _backViewFrame.r = _frontViewFrame.r - _centerDistance / self.viscosity;
    
    CGFloat backViewX, backViewY, frontViewX, frontViewY, backViewR, frontViewR;
    
    backViewX = _backViewCenter.x;
    backViewY = _backViewCenter.y;
    backViewR = _backViewFrame.r;
    
    frontViewX = _frontViewCenter.x;
    frontViewY = _frontViewCenter.y;
    frontViewR = _frontViewFrame.r;
    
    _sketchPath.A = CGPointMake(backViewX -  backViewR * _cosDigree,
                                backViewY +  backViewR *  _sinDigree);
    _sketchPath.B = CGPointMake(backViewX + backViewR * _cosDigree,
                                backViewY - backViewR * _sinDigree);
    _sketchPath.D = CGPointMake(frontViewX - frontViewR * _cosDigree,
                                frontViewY + frontViewR * _sinDigree);
    _sketchPath.C = CGPointMake(frontViewX + frontViewR * _cosDigree,
                                frontViewY - frontViewR * _sinDigree);
    
    _sketchPath.O = CGPointMake(_sketchPath.A.x + (_centerDistance / 2.0f) * _sinDigree,
                                _sketchPath.A.y + (_centerDistance / 2.0f) * _cosDigree);
    
    _sketchPath.P = CGPointMake(_sketchPath.B.x + (_centerDistance / 2.0f) * _sinDigree,
                                _sketchPath.B.y + (_centerDistance / 2.0f) * _cosDigree);
    
    [self resizeBackView];
    
    [self drawStretchBubble];
}

- (void)resizeBackView
{
    _backView.bounds = CGRectMake(0, 0, _backViewFrame.r * 2, _backViewFrame.r * 2);
    _backView.center = _backViewFrame.center;
    _backView.layer.cornerRadius = _backViewFrame.r;
}

- (void)drawStretchBubble
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_sketchPath.A];
    [path addQuadCurveToPoint:_sketchPath.D controlPoint:_sketchPath.O];
    [path addLineToPoint:_sketchPath.C];
    [path addQuadCurveToPoint:_sketchPath.B controlPoint:_sketchPath.P];
    [path closePath];
    
    _shapLayer.path = path.CGPath;
    _shapLayer.fillColor = _tintColor.CGColor;
}

- (UIView *)bubbleView
{
    CGRect frame = CGRectMake(0, 0, _bubbleWidth, _bubbleWidth);
    UIView *bubbleView = [[UIView alloc] initWithFrame:frame];
    bubbleView.layer.cornerRadius = _bubbleWidth / 2.0f;
    
    return bubbleView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:_bubbleWidth / 2.0f + 3];
    }

    return _titleLabel;
}

#pragma mark - 


@end
