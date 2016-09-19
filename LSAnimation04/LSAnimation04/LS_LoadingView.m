//
//  LS_LoadingView.m
//  LSLearnAni07
//
//  Created by xiaoT on 16/4/5.
//  Copyright © 2016年 赖三聘. All rights reserved.
//

#import "LS_LoadingView.h"

@interface LS_LoadingView()

@property (nonatomic, assign) CGFloat progressBarHeight;

@property (nonatomic, assign) CGFloat progressBarWidth;

@end

@implementation LS_LoadingView
{
    CGRect originFrame;
    BOOL animating;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originFrame = frame;
        self.progressBarWidth = originFrame.size.width + 50;
        self.progressBarHeight = 20;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
        self.layer.cornerRadius = originFrame.size.width / 2;
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 3.0f;
    }
    return self;
}

-(void)setGestureView:(UIView *)gestureView
{
    _gestureView = gestureView;
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(tapGesture:)];
    
    [gestureView addGestureRecognizer:pan];
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self animation];
}

-(void)animation
{
    if (animating == YES) {
        return;
    }
//                若该视图上的layer有subLayer，则对layer进行更改时，需要将subLayer给remove掉，再进行编辑
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
//    NSLog(@"number of subLayers %ld",[self.layer.sublayers count]);
//    NSLog(@"initial rect is %@",NSStringFromCGRect(self.bounds));

    animating = YES;
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];

    self.layer.cornerRadius = self.progressBarHeight/2;

    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAnimation.duration = 0.2f;
    radiusAnimation.fromValue = @(originFrame.size.width / 2);
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    radiusAnimation.delegate = self;
    [self.layer addAnimation:radiusAnimation forKey:@"radiusAniamtion"];
}

-(void)animationDidStart:(CAAnimation *)anim
{
    if ([anim isEqual:[self.layer animationForKey:@"radiusAniamtion"]]) {
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.bounds = CGRectMake(0, 0, _progressBarWidth, _progressBarHeight);
//            NSLog(@"progress rect is %@",NSStringFromCGRect(self.bounds));
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressBarAnimation];
        }];
    }
    
    if ([anim isEqual:[self.layer animationForKey:@"backCornerAni"]]) {
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.bounds = CGRectMake(0, 0, originFrame.size.width, originFrame.size.height);
            self.backgroundColor = [UIColor orangeColor];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
        }];
    }
}

-(void)checkAnimation
{
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGRect rectInside = CGRectInset(self.bounds, originFrame.size.width * (1 - 1 / sqrt(2.0)) / 2, originFrame.size.width * (1 - 1 / sqrt(2.0)) / 2);
    
    [path moveToPoint:CGPointMake(rectInside.origin.x + rectInside.size.width / 9, rectInside.origin.y + rectInside.size.height * 1 / 2)];
    [path addLineToPoint:CGPointMake(rectInside.origin.x + rectInside.size.width / 3, rectInside.origin.y + rectInside.size.height * 9 / 10)];
    [path addLineToPoint:CGPointMake(rectInside.origin.x + rectInside.size.width * 4 / 5, rectInside.origin.y + rectInside.size.height * 1 / 5)];
    
    checkLayer.path = path.CGPath;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.lineWidth = 10.0f;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAni.duration = 0.7f;
    checkAni.fromValue = @(0);
    checkAni.toValue = @(1);
    checkAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    checkAni.delegate = self;
    [checkAni setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAni forKey:nil];
}

-(void)progressBarAnimation
{
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(self.progressBarHeight / 2, self.bounds.size.height / 2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - self.progressBarHeight / 2, self.bounds.size.height / 2)];
    
    progressLayer.path = path.CGPath;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = _progressBarHeight - 6;
    progressLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *progressAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAni.duration = 2.0f;
    progressAni.fromValue = @(0);
    progressAni.toValue = @(1);
    progressAni.delegate = self;
    [progressAni setValue:@"progressBarAnimation" forKey:@"animationName"];
    
    [progressLayer addAnimation:progressAni forKey:nil];
}
    

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"progressBarAnimation"]) {
        [UIView animateWithDuration:0.3 animations:^{
            for (CALayer *layers in self.layer.sublayers) {
                layers.opaque = 0.0;
            }
        } completion:^(BOOL finished) {
            if (finished) {
//                若该视图上的layer有subLayer，则对layer进行更改时，需要将subLayer给remove掉，再进行编辑
                for (CALayer *layers in self.layer.sublayers) {
                    [layers removeFromSuperlayer];
                }
                self.layer.cornerRadius = originFrame.size.width / 2;
                
                CABasicAnimation *radiusAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusAni.duration = 0.5;
                radiusAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                radiusAni.fromValue = @(_progressBarHeight / 2);
                radiusAni.delegate = self;
                
                [self.layer addAnimation:radiusAni forKey:@"backCornerAni"];
            }
        }];
    }
    
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"checkAnimation"]) {
        animating = NO;
        [self.layer removeAllAnimations];
//        NSLog(@"end of number of subLayers %ld",[self.layer.sublayers count]);
    }
}

@end
