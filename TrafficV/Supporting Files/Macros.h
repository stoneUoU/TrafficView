//
//  Macros.h
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#ifndef Macros_h
#define Macros_h


//自定义Log输入日志+显示行号
#ifdef DEBUG
#define STLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define STLog(...)
#endif


//设计师设计以iphone6为原型：
#define iphoneSixW 375

//以6/6s为准宽度缩小系数
#define StScaleW   [UIScreen mainScreen].bounds.size.width/375.0

//高度缩小系数
#define StScaleH  [UIScreen mainScreen].bounds.size.height/667.0

// UIScreen.
#define  ScreenInfo   [UIScreen mainScreen].bounds.size
// UIScreen width.
#define  ScreenW   [UIScreen mainScreen].bounds.size.width
// UIScreen height.
#define  ScreenH  [UIScreen mainScreen].bounds.size.height
#define  spaceM 15
// iPhone X
#define  isX (ScreenW == 375.f && ScreenH == 812.f ? YES : NO)
// Status bar height.
#define  StatusBarH     (isX ? 44.f : 20.f)
// Navigation bar height.
#define  NavigationBarH  44.f
// Tabbar height.
#define  TabBarH   (isX ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  TabbarSafeBottomM        (isX ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  StatusBarAndNavigationBarH  (isX ? 88.f : 64.f)
#define ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
//没网时的提示
#define missNetTips @"网络开小差啦，请检查网络"
//登录失效的提示
#define missSsidTips @"登录失效，请重新登录"
//设置弹窗位置
#define Pos StToastShowTypeBottom
//定义颜色（随机）
#define STColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define STRandomC STColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#endif /* Macros_h */
