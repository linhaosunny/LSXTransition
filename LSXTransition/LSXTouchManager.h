//
//  LSXTouchManager.h
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSXTouchManager : NSObject

// > 触摸点
@property(nonatomic,assign)CGPoint touchPoint;

// > 触摸半径
@property(nonatomic,assign)float radius;

+ (instancetype)shareManager;
@end
