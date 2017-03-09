//
//  LSXAnimatinOval.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXAnimationOval.h"
#import "LSXBaseAnimation_Transition.h"

@interface LSXAnimationOval ()

// > 进场状态
@property(nonatomic,assign)BOOL isPush;

// > 转场动画上下文
@property(nonatomic,weak)id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation LSXAnimationOval

/** 椭圆进场转场动画效果*/
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    self.isPush                 = YES;
    self.transitionContext      = transitionContext;
    
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    
    CGRect bounds               = [[UIScreen mainScreen]bounds];
    
    UIView *containView         = [transitionContext containerView];
    
    fromVC.view.hidden          = YES;
    
    [containView addSubview:fromVC.snapshot];
    [containView addSubview:toVC.view];
    [[toVC.navigationController.view superview] insertSubview:fromVC.snapshot belowSubview:toVC.navigationController.view];
    
    CGRect frame                = CGRectMake(kWidth / 2.0 - 0.5, kHeight / 2.0 - 0.5, 1, 1);
    
    // > 内切圆
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:frame];
    float radius                = sqrtf(kHeight * kHeight / 4.0 + kWidth * kWidth / 4.0);
 
    UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-kWidth / 4.0, -kHeight / 4.0, kWidth * 1.5, kHeight * 1.5)];
    
    CAShapeLayer *maskLayer     = [CAShapeLayer layer];
    maskLayer.path              = endPath.CGPath;
    toVC.navigationController.view.layer.mask        = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue         = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue           = (__bridge id _Nullable)(endPath.CGPath);
    animation.duration          = duration ;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.delegate          = self;
    
    [maskLayer addAnimation:animation forKey:@"start"];
    
}

/** 椭圆出场转场动画效果*/
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPush                 = NO;
    self.transitionContext      = transitionContext;
    
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    if(fromVC.interactivePopTransition)
    {
        duration = duration * 0.66;
    }
    UIView *containView         = [transitionContext containerView];
    
    fromVC.view.hidden          = YES;
    fromVC.navigationController.navigationBar.hidden = YES;
    [containView addSubview:toVC.view];
    [containView addSubview:toVC.snapshot];
    [containView sendSubviewToBack:toVC.snapshot];
    [containView addSubview:fromVC.snapshot];
    
    CGRect frame                = CGRectMake(kWidth / 2.0 - 0.5, kHeight / 2.0 - 0.5, 1, 1);
    float radius                 = sqrtf(kHeight * kHeight / 4.0 + kWidth * kWidth / 4.0);
  
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-kWidth / 4.0, -kHeight / 4.0, kWidth * 1.5, kHeight * 1.5)];
    UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    CAShapeLayer *maskLayer     = [CAShapeLayer layer];
    maskLayer.path              = endPath.CGPath;
    fromVC.snapshot.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue         = (__bridge id _Nullable)(startPath.CGPath);
    animation.toValue           = (__bridge id _Nullable)(endPath.CGPath);
    animation.duration          = duration;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.delegate          = self;
    
    [maskLayer addAnimation:animation forKey:@"end"];
    
}

/** 转场动画停止效果*/
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if (self.isPush)
    {
        [self.transitionContext completeTransition:YES];
        UIViewController *fromVC    = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC.view.hidden = NO;
        [fromVC.snapshot removeFromSuperview];
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        
    }
    else
    {
        UIViewController *fromVC    = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC      = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.hidden            = NO;
        toVC.navigationController.navigationBar.hidden = NO;
        [fromVC.snapshot removeFromSuperview];
        [toVC.snapshot removeFromSuperview];
        fromVC.snapshot             = nil;
        
        // > 交互转场动画更新
        if (![self.transitionContext transitionWasCancelled])
        {
            toVC.snapshot               = nil;
            [self.transitionContext completeTransition:YES];
        }
        else
        {
            [self.transitionContext completeTransition:NO];
        }
    }
}
@end
