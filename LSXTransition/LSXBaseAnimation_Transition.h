//
//  LSXBaseAnimation_Transition.h
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXBaseAnimation.h"
#import "UIViewController_LSXTransitionExtersion.h"

#define kHeight [[UIScreen mainScreen] bounds].size.height
#define kWidth [[UIScreen mainScreen] bounds].size.width

@interface LSXBaseAnimation ()
#pragma mark - push pop方法，具体由子类实现
// > 进场动画
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext;
// > 出场动画
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext;

// > 进场结束
- (void)pushEnded;
// > 出场结束
- (void)popEnded;
@end
