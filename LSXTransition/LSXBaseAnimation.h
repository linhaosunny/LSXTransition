//
//  LSXBaseAnimation.h
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LSXAnimateType)
{
    LSXAnimateTypeDefault = 0,
    LSXAnimateTypeDiffNavi,
    LSXAnimateTypeKuGou,
    LSXAnimateTypeRound,
    LSXAnimateTypeOval,
    
};

const static NSTimeInterval DefauleAnimationDuration = 0.6;

@interface LSXBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign,readonly)UINavigationControllerOperation transitionType;
@property(nonatomic,strong,readwrite)UIPercentDrivenInteractiveTransition *interactivePopTransition;

/**
 *  主要构造方法
 *  @param  transitionType      动画类型 push or pop
 *  @param  duration            间隔时间
 *  @param  animaType           动画方式
 */
- (instancetype)initWithType:(UINavigationControllerOperation)transitionType
                    Duration:(NSTimeInterval)duration
                 animateType:(LSXAnimateType)animaType;

/**
 *  创建实例对象
 *  @param  transitionType      动画类型 push or pop
 *  @param  animaType           动画方式
 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType
                       animateType:(LSXAnimateType)animaType;

/**
 *  创建实例对象
 *  @param  transitionType      动画类型 push or pop
 *  @param  duration            间隔时间
 *  @param  animaType           动画方式
 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType
                          duration:(NSTimeInterval)duration
                       animateType:(LSXAnimateType)animaType;
/**
 *  创建实例对象
 *  @param  transitionType      动画类型 push or pop
 *  @param  duration            间隔时间
 *  @param  interactivePopTransition            可交互属性
 *  @param  animaType           动画方式
 */
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType
                          duration:(NSTimeInterval)duration
          interactivePopTransition:(UIPercentDrivenInteractiveTransition *)interactivePopTransition
                       animateType:(LSXAnimateType)animaType;


@end
