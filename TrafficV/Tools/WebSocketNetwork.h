//
//  WebSocketNetwork.h
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

typedef NS_ENUM(NSInteger,WebSocketStatus)
{
    WebSocketStatusConnecting = 0,
    WebSocketStatusConnected,
    WebSocketStatusConnectFail,
    WebSocketStatusLoseConnect
};


@protocol SLWebSocketDelegate <NSObject>

@optional

- (void)onLogin:(WebSocketStatus)state;

- (void)webSocketDidReceivedMessage:(id)message;


@end


@interface WebSocketNetwork : NSObject <SRWebSocketDelegate>




+ (instancetype)shareInstance;

- (instancetype)shareInstance;

- (void)startConnect;


@property (nonatomic, assign) WebSocketStatus status;

@property (nonatomic, assign) id <SLWebSocketDelegate>delegate;

- (void)sendMessage:(NSDictionary *)message;



@end
