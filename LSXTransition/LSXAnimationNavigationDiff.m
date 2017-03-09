//
//  LSXAnimationNavigationDiff.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXAnimationNavigationDiff.h"
#import "LSXBaseAnimation_Transition.h"

@implementation LSXAnimationNavigationDiff

/** 进场动画效果*/
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromVc   = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc     = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration     = [self transitionDuration:transitionContext];
    
    CGRect bounds               = [[UIScreen mainScreen] bounds];
    
    fromVc.view.hidden          = YES;
    
    [[transitionContext containerView] addSubview:toVc.view];
    [[toVc.navigationController.view superview] insertSubview:fromVc.snapshot belowSubview:toVc.navigationController.view];
    toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.snapshot.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(bounds) * 0.3, 0);
                         toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         fromVc.view.hidden = NO;
                         [fromVc.snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    
}
/** 退场动画效果*/
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * fromVc  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController * toVc         = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration         = [self transitionDuration:transitionContext];
    
    CGRect bounds                   = [[UIScreen mainScreen] bounds];
    
    [fromVc.view addSubview:fromVc.snapshot];
    fromVc.navigationController.navigationBar.hidden = YES;
    fromVc.view.transform = CGAffineTransformIdentity;
    
    toVc.view.hidden                = YES;
    toVc.snapshot.transform         = CGAffineTransformMakeTranslation(-CGRectGetWidth(bounds) * 0.3, 0);
    
    [[transitionContext containerView] addSubview:toVc.view];
    [[transitionContext containerView] addSubview:toVc.snapshot];
    [[transitionContext containerView] sendSubviewToBack:toVc.snapshot];
    
    if (fromVc.interactivePopTransition)
    {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVc.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0.0);
                             toVc.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             
                             toVc.navigationController.navigationBar.hidden = NO;
                             toVc.view.hidden = NO;
                             
                             [fromVc.snapshot removeFromSuperview];
                             [toVc.snapshot removeFromSuperview];
                             fromVc.snapshot = nil;
                             
                             if (![transitionContext transitionWasCancelled]) {
                                 toVc.snapshot = nil;
                             }
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
        
    }
    else
    {
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVc.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0.0);
                             toVc.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             
                             toVc.navigationController.navigationBar.hidden = NO;
                             toVc.view.hidden = NO;
                             
                             [fromVc.snapshot removeFromSuperview];
                             [toVc.snapshot removeFromSuperview];
                             fromVc.snapshot = nil;
                             
                             if (![transitionContext transitionWasCancelled]) {
                                 toVc.snapshot = nil;
                             }
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    
}
@end