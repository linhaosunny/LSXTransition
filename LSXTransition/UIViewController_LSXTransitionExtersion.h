//
//  UIViewController__LSXTransitionExtersion.h
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//



@interface UIViewController ()
// > 出场交互动画
@property(nonatomic,strong,readwrite)UIPercentDrivenInteractiveTransition *interactivePopTransition;
// > 屏幕快照
@property (nonatomic, strong) UIView *snapshot;

// > 屏幕顶部快照
@property(nonatomic,strong) UIView *topSnapshot;

// > 屏幕视图快照
@property(nonatomic,strong) UIView *viewSnapshot;

- (void)handCancelPop;
@end
