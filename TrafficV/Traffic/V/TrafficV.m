//
//  TrafficV.m
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "TrafficV.h"

@implementation TrafficV
- (void)drawRect:(CGRect)rect {
    [self setUpUI];
}
- (void)setUpUI{
    _monitorIV = [[UIImageView alloc] init ];
    //_monitorIV.backgroundColor = [UIColor cyanColor];
    [self addSubview:_monitorIV];

    _dealV = [[UIView alloc] init ];
    [self addSubview:_dealV];

    _upV = [[UIButton alloc] init ];
    [_upV setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    [_upV addTarget:self action:@selector(upVTouchBegin:)forControlEvents:UIControlEventTouchDown];
    [_upV addTarget:self action:@selector(upVTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
    [_upV addTarget:self action:@selector(upVTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
    [_dealV addSubview:_upV];

    _downV = [[UIButton alloc] init ];
    [_downV setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [_downV addTarget:self action:@selector(downVTouchBegin:)forControlEvents:UIControlEventTouchDown];
    [_downV addTarget:self action:@selector(downVTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
    [_downV addTarget:self action:@selector(downVTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
    [_dealV addSubview:_downV];

    _leftV = [[UIButton alloc] init ];
    [_leftV setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [_leftV addTarget:self action:@selector(leftVTouchBegin:)forControlEvents:UIControlEventTouchDown];
    [_leftV addTarget:self action:@selector(leftVTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
    [_leftV addTarget:self action:@selector(leftVTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
    [_dealV addSubview:_leftV];

    _rightV = [[UIButton alloc] init ];
    [_rightV setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [_rightV addTarget:self action:@selector(rightVTouchBegin:)forControlEvents:UIControlEventTouchDown];
    [_rightV addTarget:self action:@selector(rightVTouchEnd:)forControlEvents:UIControlEventTouchUpInside];
    [_rightV addTarget:self action:@selector(rightVTouchEnd:)forControlEvents:UIControlEventTouchUpOutside];
    [_dealV addSubview:_rightV];

    //添加约束
    [self setMas];
}
- (void) setMas{
    [_monitorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(ScreenH);
    }];

    [_dealV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];

    [_upV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dealV.mas_top).offset(0);
        make.left.equalTo(self.dealV.mas_left).offset(50);
        make.width.height.mas_equalTo(50);
    }];

    [_downV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dealV.mas_bottom).offset(0);
        make.left.equalTo(self.dealV.mas_left).offset(50);
        make.width.height.mas_equalTo(50);
    }];

    [_leftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dealV.mas_top).offset(50);
        make.left.equalTo(self.dealV.mas_left).offset(0);
        make.width.height.mas_equalTo(50);
    }];

    [_rightV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dealV.mas_top).offset(50);
        make.right.equalTo(self.dealV.mas_right).offset(0);
        make.width.height.mas_equalTo(50);
    }];
}
//点击按钮触发事件
-(void) upVTouchBegin:(id)sender{
    _upTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target: self selector: @selector(toUpTimer:) userInfo: nil repeats: YES];
    [_upTimer fire];
}
-(void) upVTouchEnd:(id)sender{
    [_upTimer invalidate];
}
-(void) toUpTimer:(id)sender{
    [_delegate toUp];
}

-(void) downVTouchBegin:(id)sender{
    _downTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target: self selector: @selector(toDownTimer:) userInfo: nil repeats: YES];
    [_downTimer fire];
}
-(void) downVTouchEnd:(id)sender{
    [_downTimer invalidate];
}
-(void) toDownTimer:(id)sender{
    [_delegate toDown];
}

-(void) leftVTouchBegin:(id)sender{
    _leftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target: self selector: @selector(toLeftTimer:) userInfo: nil repeats: YES];
    [_leftTimer fire];
}
-(void) leftVTouchEnd:(id)sender{
    [_leftTimer invalidate];
}
-(void) toLeftTimer:(id)sender{
    [_delegate toLeft];
}

-(void) rightVTouchBegin:(id)sender{
    _rightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target: self selector: @selector(toRightTimer:) userInfo: nil repeats: YES];
    [_rightTimer fire];
}
-(void) rightVTouchEnd:(id)sender{
    [_rightTimer invalidate];
}
-(void) toRightTimer:(id)sender{
    [_delegate toRight];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
