//
//  UIButton+ST_FixMultiClick.h
//  TrafficV
//
//  Created by test on 2018/4/26.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ST_FixMultiClick)

@property (nonatomic, assign) NSTimeInterval st_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval st_acceptEventTime;

- (void)adjustToSize:(CGSize)size;   //调整按钮点击范围

@end
