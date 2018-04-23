//
//  TrafficV.h
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "STJoyStickV.h"
@protocol TrafficVDel
//这里只需要声明方法
- (void)toUp;
- (void)toDown;
- (void)toLeft;
- (void)toRight;
- (void)toControl:(NSInteger)direction;    //0:上  1:右上  2:右  3:右下  4:下  5:左下  6:左  7:左上  8:中心  顺时针方向 
@end
@interface TrafficV : UIView

@property (nonatomic, weak) id<TrafficVDel> delegate; //定义一个属性，可以用来进行get set操作

@property (nonatomic ,strong)UIImageView *monitorIV;

@property (nonatomic ,strong)UIView *dealV;

@property (nonatomic ,strong)UIButton *upV;

@property (nonatomic ,strong)UIButton *downV;

@property (nonatomic ,strong)UIButton *leftV;

@property (nonatomic ,strong)UIButton *rightV;

@property (nonatomic ,strong)STJoyStickV* stJoyStickV;

@property (nonatomic, strong)NSTimer *upTimer;

@property (nonatomic, strong)NSTimer *downTimer;

@property (nonatomic, strong)NSTimer *leftTimer;

@property (nonatomic, strong)NSTimer *rightTimer;

@end
