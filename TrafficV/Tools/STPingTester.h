//
//  STPingTester.h
//  BigVPN
//
//  Created by wanghe on 2017/5/11.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@protocol STPingDelegate <NSObject>
@optional
- (void) didPingSucccessWithTime:(float)time withError:(NSError*) error;
@end


@interface STPingTester : NSObject<SimplePingDelegate>
@property (nonatomic, weak, readwrite) id<STPingDelegate> delegate;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithHostName:(NSString*)hostName NS_DESIGNATED_INITIALIZER;

- (void) startPing;
- (void) stopPing;
@end

typedef NS_ENUM(NSUInteger, STPingStatus){
    STPingStatusSending = 0 << 0,
    STPingStatusTimeout = 1 << 1,
    STPingStatusSended = 2 << 2,
};

@interface STPingItem : NSObject
//@property(nonatomic, assign) STPingStatus status;
@property(nonatomic, assign) uint16_t sequence;

@end



