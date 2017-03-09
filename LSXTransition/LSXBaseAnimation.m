//
//  LSXBaseAnimation.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXBaseAnimation.h"
#import "LSXBaseAnimation_Transition.h"
#import "LSXAnimationRound.h"
#import "LSXAnimationOval.h"
#import "LSXAnimationKuGou.h"
#import "LSXAnimationDefault.h"
#import "LSXAnimationNavigationDiff.h"

@interface LSXBaseAnimation ()

// > 动画时长
@property(nonatomic,assign) NSTimeInterval duration;
// > 转场动画效果类型
@property(nonatomic,assign,readwrite)UINavigationControllerOperation transitionType;

@end

@implementation LSXBaseAnimation

/** 构造方法创建基础动画*/
- (instancetype)initWithType:(UINavigationControllerOperation)transitionType Duration:(NSTimeInterval)duration animateType:(LSXAnimateType)animaType
{
    // > 转场动画初始化
    switch (animaType)
    {
        case LSXAnimateTypeDefault:
        {
            self = [[LSXAnimationDefault alloc]init];
        }
            break;
        case LSXAnimateTypeDiffNavi:
        {
            self = [[LSXAnimationNavigationDiff alloc]init];
        }
            break;
        case LSXAnimateTypeKuGou:
        {
            self = [[LSXAnimationKuGou alloc]init];
        }
            break;
        case LSXAnimateTypeRound:
        {
            self = [[LSXAnimationRound alloc]init];
        }
            break;
        case LSXAnimateTypeOval:
        {
            self = [[LSXAnimationOval alloc] init];
        }
            break;
            
        default:
            break;
    }
    
    // > 设置转场动画
    if (self)
    {
        self.duration       = duration;
        self.transitionType = transitionType;
    }
    return self;
}

/** 类方法创建默认时长的转场动画 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType animateType:(LSXAnimateType)animaType
{
    return [self transitionWithType:transitionType duration:DefauleAnimationDuration animateType:animaType];
}

/** 类方法创建无用户交互的转场动画 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration animateType:(LSXAnimateType)animaType
{
    return [self transitionWithType:transitionType duration:duration interactivePopTransition:nil animateType:animaType];
}

/** 类方法创建标准的带用户交互的转场动画 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration interactivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition animateType:(LSXAnimateType)animaType
{
    LSXBaseAnimation *animation = [[self alloc]initWithType:transitionType Duration:duration animateType:animaType];
    animation.interactivePopTransition = interactivePopTransition;
    return animation;
}

#pragma mark - <UIViewControllerAnimationTransition>
/** 转场动画时长 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

/** 设置进程与退场动画效果*/
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.transitionType == UINavigationControllerOperationPush)
    {
        [self push:transitionContext];
    }
    else if (self.transitionType == UINavigationControllerOperationPop)
    {
        [self pop:transitionContext];
    }
}

/** 设置进程退场结束动画效果*/
- (void)animationEnded:(BOOL)transitionCompleted
{
    if (!transitionCompleted)
    {
        return;
    }
    if (self.transitionType == UINavigationControllerOperationPush)
    {
        [self pushEnded];
    }
    else if (self.transitionType == UINavigationControllerOperationPop)
    {
        [self popEnded];
    }
}
@end
