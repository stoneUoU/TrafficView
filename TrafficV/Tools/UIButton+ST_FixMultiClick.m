//
//  UIButton+ST_FixMultiClick.m
//  TrafficV
//
//  Created by test on 2018/4/26.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "UIButton+ST_FixMultiClick.h"
#import <objc/runtime.h>

@implementation UIButton (ST_FixMultiClick)

// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)st_acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setSt_acceptEventInterval:(NSTimeInterval)st_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(st_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)st_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setSt_acceptEventTime:(NSTimeInterval)st_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(st_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
//+ (void)load {
//    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after    = class_getInstanceMethod(self, @selector(st_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
//}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(st_sendAction:to:forEvent:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)st_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.st_acceptEventTime < self.st_acceptEventInterval) {
        return;
    }

    if (self.st_acceptEventInterval > 0) {
        self.st_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }

    [self st_sendAction:action to:target forEvent:event];
}

- (void)adjustToSize:(CGSize)size
{
    CGRect previousFrame = self.frame;
    CGRect newFrame = self.frame;
    newFrame.size = size;
    CGFloat adjustX = (size.width - previousFrame.size.width)/2;
    CGFloat adjustY = (size.height - previousFrame.size.height)/2;
    newFrame.origin.x = previousFrame.origin.x - adjustX;
    newFrame.origin.y = previousFrame.origin.y - adjustY;
    self.frame = newFrame;

    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(adjustY, adjustX, adjustY, adjustX);
    self.contentEdgeInsets = edgeInsets;
}

@end
