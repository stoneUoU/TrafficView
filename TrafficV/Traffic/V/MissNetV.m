//
//  MissNetV.m
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "MissNetV.h"

@implementation MissNetV
- (instancetype)initWithFrame:(CGRect)frame tuStyle:(NSString *)tuStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI:tuStyle];
    }
    return self;
}
- (void)setUpUI:(NSString *)tuStyle{
    _missNetV = [[UIView alloc] init ];
    [_missNetV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *missGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toGo:)];
    [_missNetV addGestureRecognizer:missGes];
    [self addSubview:_missNetV];

    _tuIV = [[UIImageView alloc] init ];
    _tuIV.image = [UIImage imageNamed:tuStyle];
    [_missNetV addSubview:_tuIV];

    //添加约束
    [self setMas];
}
- (void) setMas{
    [_missNetV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(ScreenH);
    }];

    [_tuIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.missNetV);
    }];
}
//触摸View并触发事件
- (void)toGo:(id)sender{
    [self.delegate toGo];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
