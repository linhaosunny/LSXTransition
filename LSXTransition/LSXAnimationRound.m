//
//  LSXAnimationRound.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXAnimationRound.h"
#import "LSXBaseAnimation_Transition.h"
#import "LSXTouchManager.h"

@interface  LSXAnimationRound ()

// > 转场动画上下文
@property(nonatomic,weak)id<UIViewControllerContextTransitioning> transitionContext;

// > 进场动画状态
@property(nonatomic,assign)BOOL isPush;

// > 工具栏状态
@property(nonatomic,assign)BOOL tabbarFlag;

@end


@implementation LSXAnimationRound

/** 圆形⭕️进场转场动画效果*/
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    self.isPush                 = YES;
    self.tabbarFlag             = NO;
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
    
    CGRect frame                = CGRectMake([LSXTouchManager shareManager].touchPoint.x, [LSXTouchManager shareManager].touchPoint.y, 1, 1);
    if (fromVC.tabBarController)
    {
        fromVC.tabBarController.tabBar.hidden = YES;
    }
    
 
    // > 内切圆
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:frame];
    float radius                = [LSXTouchManager shareManager].radius;
    UIBezierPath *endPath       = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, -radius, -radius)];

    
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

/** 圆形⭕️退场转场动画效果*/
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPush                 = NO;
    self.tabbarFlag             = NO;
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
    
    [containView addSubview:fromVC.snapshot];
    
    
    if (toVC.tabBarController && toVC == [toVC.navigationController viewControllers].firstObject)
    {
        toVC.tabBarController.tabBar.hidden = YES;
        self.tabbarFlag = YES;
    }
    
    
    CGRect frame                = CGRectMake([LSXTouchManager shareManager].touchPoint.x, [LSXTouchManager shareManager].touchPoint.y, 1, 1);
    float radius                 = [LSXTouchManager shareManager].radius;
    UIBezierPath *startPath     = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, -radius, -radius)];
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
        
        if (self.tabbarFlag)
        {
            fromVC.tabBarController.tabBar.hidden = NO;
        }
        
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
        // > 更新交互转场动画
        
        if (![self.transitionContext transitionWasCancelled])
        {
            toVC.snapshot               = nil;
            [self.transitionContext completeTransition:YES];
        }
        else
        {
            fromVC.snapshot.layer.mask = nil;
            fromVC.view.layer.mask = nil;
            fromVC.view.hidden = NO;
            [self.transitionContext completeTransition:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wtk_cancelPop" object:nil];
        }
        if (self.tabbarFlag)
        {
            toVC.tabBarController.tabBar.hidden = NO;
        }
    }
}


@end
