//
//  HudTips.m
//  Fishes
//
//  Created by test on 2018/3/21.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "HudTips.h"

@implementation HudTips
+ (void)showHUD:(UIViewController *)ctrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: ctrl.view animated:true];
        hud.mode = MBProgressHUDModeIndeterminate;
    });
}

+ (void)hideHUD:(UIViewController *)ctrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [MBProgressHUD hideHUDForView: ctrl.view animated:YES];
    });
}

+ (void)showToast:(NSString *)text showType:(StToastShowType)type animationType:(StToastAnimationType)animationType{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        StToast *toast = [StToast toastWithText:text animationType:animationType];
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [toast showInView:window showType:type];
    });
}
@end
