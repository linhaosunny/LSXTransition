//
//  UIViewController+LSXTransitionExtersion.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "UIViewController+LSXTransitionExtersion.h"
#import <objc/message.h>

@implementation UIViewController (LSXTransitionExtersion)

- (void)setInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition{
    
    objc_setAssociatedObject(self, "UIPercentDrivenInteractiveTransition", interactivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition{
    return objc_getAssociatedObject(self, "UIPercentDrivenInteractiveTransition");
}

- (void)setSnapshot:(UIView *)snapshot
{
    objc_setAssociatedObject(self, @"LSXAnimationTransitioningSnapshot", snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)snapshot
{
    UIView *view = objc_getAssociatedObject(self, @"LSXAnimationTransitioningSnapshot");
    
    if (!view)
    {
        view = [self.tabBarController.view snapshotViewAfterScreenUpdates:NO];
        
        [self setSnapshot:view];
    }
    return view;
}

- (void)setTopSnapshot:(UIView *)topSnapshot
{
    objc_setAssociatedObject(self, @"LSXAnimationTransitioningTopSnapshot", topSnapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)topSnapshot
{
    UIView *view = objc_getAssociatedObject(self, @"LSXAnimationTransitioningTopSnapshot");
    
    if(!view)
    {
        view = [self.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        
        [self setTopSnapshot:view];
    }
    return view;
}

- (void)setViewSnapshot:(UIView *)viewSnapshot
{
    objc_setAssociatedObject(self, @"LSXAnimationTransitioningViewSnapshot", viewSnapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)viewSnapshot
{
    UIView *view = objc_getAssociatedObject(self, @"LSXAnimationTransitioningViewSnapshot");
    
    if (!view)
    {
        view = [self.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 64, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]) - 64) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        [self setViewSnapshot:view];
    }
    return view;
}
@end
