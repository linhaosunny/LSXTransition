//
//  UIApplication+LSXEvent.m
//  LSXTransition
//
//  Created by 李莎鑫 on 2017/3/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "UIApplication+LSXEvent.h"
#import <objc/message.h>
#import "LSXTouchManager.h"

@implementation UIApplication (LSXEvent)

+ (void)load{
    Method originMethod = class_getInstanceMethod(NSClassFromString(@"UIApplication"), @selector(sendEvent:));
    Method newMethod    = class_getInstanceMethod(NSClassFromString(@"UIApplication"), @selector(lsx_sendEvent:));
    
    method_exchangeImplementations(originMethod, newMethod);
}

- (void)lsx_sendEvent:(UIEvent *) event{
    
    UITouch *touch = [[event touchesForWindow:[[UIApplication sharedApplication].delegate window]] anyObject];
    
    CGPoint touchPoint = [touch locationInView:[[UIApplication sharedApplication].delegate window]];
    
    [LSXTouchManager shareManager].touchPoint = touchPoint;
    
    [self lsx_sendEvent:event];
}
@end
