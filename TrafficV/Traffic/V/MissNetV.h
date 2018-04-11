//
//  MissNetV.h
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MissNetVDel
//这里只需要声明方法
- (void)toGo;   //点击View重新请求数据
@end
@interface MissNetV : UIView

@property (nonatomic, weak) id<MissNetVDel> delegate; //定义一个属性，可以用来进行get set操作

@property (nonatomic ,strong)UIView *missNetV;
//显示图片
@property (nonatomic ,strong)UIImageView *tuIV;

- (instancetype)initWithFrame:(CGRect)frame tuStyle:(NSString *)tuUrl;

@end
