//
//  UIViewController+LSXTransitionExtersion.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "UIViewController+LSXTransitionExtersion.h"
#import "UIViewController_LSXTransitionExtersion.h"
#import <objc/message.h>

@interface UIViewController () <UIGestureRecognizerDelegate>

@end

@implementation UIViewController (LSXTransitionExtersion)


+ (void)load{
    Method originMethod = class_getInstanceMethod(NSClassFromString(@"UIViewController"), @selector(viewWillAppear:));
    Method newMethod    = class_getInstanceMethod(NSClassFromString(@"UIViewController"), @selector(lsx_viewWillAppear:));
    
    method_exchangeImplementations(originMethod, newMethod);

}


- (void)lsx_viewWillAppear:(BOOL) animated{
    
    [self lsx_viewWillAppear: animated];
    
    if (self.navigationController)
    {
        // > 恢复导航栏控制器
        [self resetNavigation];
        
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePopRecognizer:)];
        
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }
    

}

- (void)lsx_dealloc{
    [self lsx_dealloc];
    
    // > 释放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handCancelPop{
    [self resetNavigation];
}


- (void)resetNavigation
{
    if(self.block){
       self.block();
    }
}

/** 导航栏控制器手势处理 */
- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    
    static BOOL flag = NO;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        flag = YES;
    }
    if (flag && progress > 0)
    {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
        flag = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        if (progress > 0.25)
        {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UIViewController 添加属性
- (void)setBlock:(resetNavigationOptionBlock) block{
    objc_setAssociatedObject(self, "RestNavigationOptionBlock",block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (resetNavigationOptionBlock)block{
    return objc_getAssociatedObject(self, "RestNavigationOptionBlock");
}

- (void)setInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition{
    
    objc_setAssociatedObject(self, "LSXPercentDrivenInteractiveTransition", interactivePopTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition{
    return objc_getAssociatedObject(self, "LSXPercentDrivenInteractiveTransition");
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
