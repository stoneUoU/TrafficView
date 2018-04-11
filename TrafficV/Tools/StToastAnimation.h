//
//  StToastAnimation.h
//  Fishes
//
//  Created by test on 2018/3/21.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol StToastAnimationDelegate;

typedef NS_ENUM(NSInteger, StToastAnimationType)
{
    StToastAnimationTypeAlpha, // default
    StToastAnimationTypeScale,
    StToastAnimationTypePositionLeftToRight
};

@interface StToastAnimation : NSObject

@property (nonatomic, assign) CFTimeInterval forwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval backwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval waitAnimationDuration;

@property (nonatomic, weak) id<StToastAnimationDelegate> delegate;

+ (instancetype)toastAnimation;

- (CAAnimation *)animationWithType:(StToastAnimationType)animationType;

@end


@protocol StToastAnimationDelegate <NSObject>

@optional

- (void)toastAnimationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end
