//
//  StToast.h
//  Fishes
//
//  Created by test on 2018/3/21.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StToastAnimation.h"

typedef NS_ENUM(NSInteger, StToastShowType)
{
    StToastShowTypeTop,
    StToastShowTypeCenter,
    StToastShowTypeBottom
};

@interface StToast : UILabel

@property (nonatomic, assign) CFTimeInterval forwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval backwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval waitAnimationDuration;

@property (nonatomic, assign) UIEdgeInsets   textInsets;
@property (nonatomic, assign) CGFloat        maxWidth;

@property (nonatomic, readonly, assign) StToastShowType showType;
@property (nonatomic, readonly, assign) StToastAnimationType animationType;

+ (instancetype)toastWithText:(NSString *)text;
+ (instancetype)toastWithText:(NSString *)text animationType:(StToastAnimationType)animationType;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text animationType:(StToastAnimationType)animationType;


- (void)show;   // show in window
- (void)showWithType:(StToastShowType)type; // show in window with type
- (void)showInView:(UIView *)view;    //Default is StToastShowTypeBottom
- (void)showInView:(UIView *)view showType:(StToastShowType)type;

@end
