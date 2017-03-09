//
//  LSXTouchManager.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LSXTouchManager.h"
#import "LSXBaseAnimation_Transition.h"

@implementation LSXTouchManager

/** 创建单例*/
+ (instancetype)shareManager
{
    static LSXTouchManager *manaager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manaager = [[LSXTouchManager alloc]init];
        manaager.touchPoint = CGPointMake(0, 0);
    });
    
    return manaager;
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
}

- (float)radius
{
    float maxRadiu      = 0;
    CGPoint point1      = CGPointMake(0, 0);
    CGPoint point2      = CGPointMake(kWidth, 0);
    CGPoint point3      = CGPointMake(0, kHeight);
    CGPoint point4      = CGPointMake(kWidth, kHeight);
    NSArray *array      = @[[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3],[NSValue valueWithCGPoint:point4]];
    
    for (NSValue *value in array)
    {
        CGPoint point   = value.CGPointValue;
        float x         = point.x - self.touchPoint.x;
        float y         = point.y - self.touchPoint.y;
        maxRadiu        = maxRadiu > sqrtf(x * x + y * y) ? maxRadiu : sqrtf(x * x + y * y);
    }
    
    return maxRadiu;
}
@end
