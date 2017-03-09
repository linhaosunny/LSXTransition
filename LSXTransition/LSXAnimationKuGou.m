//
//  LSXAnimationKuGou.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXAnimationKuGou.h"
#import "LSXBaseAnimation_Transition.h"

@implementation LSXAnimationKuGou

/** 进场动画效果*/
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    
    CGRect bound                = [[UIScreen mainScreen] bounds];
    
    fromVC.view.hidden          = YES;
    
    [[transitionContext containerView] addSubview:fromVC.snapshot];
    [[transitionContext containerView] addSubview:toVC.view];
    
    [[toVC.navigationController.view superview] insertSubview:fromVC.snapshot belowSubview:toVC.navigationController.view];
    
    toVC.navigationController.view.layer.anchorPoint = CGPointMake(0.5, 2.0);
    toVC.navigationController.view.frame = bound;
    
    toVC.navigationController.view.transform =CGAffineTransformMakeRotation(0.5 * M_PI);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toVC.navigationController.view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         toVC.navigationController.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                         toVC.navigationController.view.frame = bound;
                         
                         fromVC.view.hidden = NO;
                         [fromVC.snapshot removeFromSuperview];
                         [toVC.snapshot removeFromSuperview];
                         
                         [transitionContext completeTransition:YES];
                         
                     }];
    
}

/** 退场动画效果*/
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController * fromVC  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC         = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration         = [self transitionDuration:transitionContext];
    CGRect bound                    = [[UIScreen mainScreen] bounds];
    
    
    
    
    [fromVC.view addSubview:fromVC.snapshot];
    fromVC.navigationController.navigationBar.hidden = YES;
    
    // > 添加阴影
    fromVC.snapshot.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8].CGColor;
    fromVC.snapshot.layer.shadowOffset = CGSizeMake(-3, 0);
    fromVC.snapshot.layer.shadowOpacity = 0.5;
    
    fromVC.view.layer.anchorPoint = CGPointMake(0.5, 2.5);
    fromVC.view.frame = bound;
    
    
    toVC.view.hidden                = YES;

    
    [[transitionContext containerView] addSubview:toVC.view];
    [[transitionContext containerView] addSubview:toVC.snapshot];
    [[transitionContext containerView] sendSubviewToBack:toVC.snapshot];

    
    if (fromVC.interactivePopTransition)
    {
        // > 右滑返回
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             fromVC.view.transform = CGAffineTransformMakeRotation(0.122 * M_PI);
                             toVC.snapshot.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             toVC.navigationController.navigationBar.hidden = NO;
                             toVC.view.hidden = NO;
                             
                             [fromVC.snapshot removeFromSuperview];
                             [toVC.snapshot removeFromSuperview];
                             
                             if (![transitionContext transitionWasCancelled])
                             {
                                 toVC.snapshot = nil;
                             }
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    else
    {
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.transform = CGAffineTransformMakeRotation(0.122 * M_PI);
                             toVC.snapshot.alpha = 1;
                             
                         }
                         completion:^(BOOL finished) {
                             toVC.navigationController.navigationBar.hidden = NO;
                             toVC.view.hidden = NO;
                             
                 
                             [fromVC.snapshot removeFromSuperview];
                             [toVC.snapshot removeFromSuperview];
                             
                   
                             if (![transitionContext transitionWasCancelled])
                             {
                                 toVC.snapshot = nil;
                             }
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
    }
    
    
}
@end
