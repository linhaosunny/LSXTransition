//
//  UIViewController+LSXTransitionExtersion.h
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^resetNavigationOptionBlock)(void);

@interface UIViewController (LSXTransitionExtersion)

// > 出场交互动画
@property(nonatomic,strong,readonly)UIPercentDrivenInteractiveTransition *interactivePopTransition;

// > 恢复导航栏控制器操作
@property (nonatomic ,copy) resetNavigationOptionBlock block;
@end
