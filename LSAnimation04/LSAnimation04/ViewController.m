//
//  ViewController.m
//  LSLearnAni07
//
//  Created by xiaoT on 16/4/5.
//  Copyright © 2016年 赖三聘. All rights reserved.
//

#import "ViewController.h"
#import "LS_LoadingView.h"
@interface ViewController ()

@end

@implementation ViewController
{
    LS_LoadingView *loadingView;
    UIView *rectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    loadingView = [[LS_LoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingView.center = self.view.center;
    loadingView.gestureView = self.view;
    [self.view addSubview:loadingView];
    
    
    //    rectView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //    rectView.backgroundColor = [UIColor orangeColor];
    //    [self.view addSubview:rectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(id)sender {
    [loadingView animation];
    [self createCircleAnimation];
}

-(void)createCircleAnimation
{
    //    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rectView.bounds];
    //
    //    circleLayer.path = path.CGPath;
    //    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    //    circleLayer.fillColor = [UIColor clearColor].CGColor;
    //    circleLayer.lineWidth = 5.0f;
    //    circleLayer.lineCap = kCALineCapRound;
    //
    //    [rectView.layer addSublayer:circleLayer];
    //
    //    CABasicAnimation *circleAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    circleAni.duration = 1.5f;
    //    circleAni.fromValue = @(0);
    //    circleAni.toValue = @(1);
    //
    //    [circleLayer addAnimation:circleAni forKey:nil];
}








@end
