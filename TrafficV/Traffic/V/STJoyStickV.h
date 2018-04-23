//
//  STJoyStickV.h
//  TrafficV
//
//  Created by test on 2018/4/21.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AngleBlock)(float sinX, float sinY);

typedef void (^CenterB)(void);//回到中心的时候闭包（能用两个闭包解决的事绝不用闭包+代理）哈哈哈哈哈

@interface STJoyStickV : UIView

#pragma mark -- 属性
@property(nonatomic,strong)AngleBlock angleBlock;       // 控制器回传角度

@property(nonatomic,strong)CenterB centerB;       // 控制器回传角度

#pragma mark -- 方法
- (instancetype)initWithFrame:(CGRect)frame;

@end

