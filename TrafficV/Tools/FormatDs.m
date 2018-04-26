//
//  FormatDs.m
//  TrafficV
//
//  Created by test on 2018/4/26.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "FormatDs.h"

@implementation FormatDs
//格式话小数 四舍五入类型
+(NSString *)retainPoint:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    [numberFormatter setPositiveFormat:format];

    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
@end
