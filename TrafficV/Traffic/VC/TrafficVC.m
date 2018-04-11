//
//  ViewController.m
//  TrafficV
//
//  Created by test on 2018/4/9.
//  Copyright © 2018年 com.youlu. All rights reserved.
//

#import "TrafficVC.h"
#import "HudTips.h"
#import "GCDAsyncSocket.h"
@interface TrafficVC ()<GCDAsyncSocketDelegate,AppDel>{
    // 这个socket用来做发送使用 当然也可以接收
    GCDAsyncSocket *sendTcpSocket;
}//<SLWebSocketDelegate>

@end
@implementation TrafficVC
- (id)init
{
    //初始化TrafficV
    _trafficV = [[TrafficV alloc] init]; //对_trafficV进行初始化
    _trafficV.delegate = self; //将TrafficVC自己的实例作为委托对象

    //初始化MissNetV
    _missNetV = [[MissNetV alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) tuStyle:@"noNet.png"]; //对_missNetV进行初始化
    _missNetV.backgroundColor = [UIColor whiteColor];
    _missNetV.delegate = self; //将TrafficVC自己的实例作为委托对象

    //初始化接受数据的NSData变量
    _data = [[NSMutableData alloc] init];
    return [super init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNotice];
    [self setUpUI];
    //发送网络请求:
    //[self performSelector:@selector(decideNet) withObject:nil/*可传任意类型参数*/ afterDelay:3];
    [self setTcpSocket];
    [AppDelegate shareIns].delegate = self;
}
-(void) setNotice{
    //监听是否有网
    _netUseVals = [UICKeyChainStore keyChainStore][@"ifnetUse"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNet:)
                                                 name:@"netChange"
                                               object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRequest:) name:@"enterForeTai" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRes:) name:@"orPingNet" object:nil];
//    [AppDelegate getDictB] = ^(NSDictionary *dict, BOOL b){
//        STLog(@"%@",[dict objectForKey:@"name"]);
//    };
}
-(void) setUpUI{
    [self.view addSubview:_trafficV];
    //添加约束
    [self setMas];
}
-(void) setMissNetV{
    [self.view addSubview:_missNetV];
    [_missNetV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(ScreenH);
    }];
}
- (void) setMas{
    [_trafficV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(ScreenH);
    }];
}
#pragma mark - 连接websocket
//-(void) setSocket{
//    _socketNet = [WebSocketNetwork shareInstance];
//    _socketNet.delegate = self;
//    [_socketNet startConnect];
//}

-(void)decideNet{
    if ([_netUseVals isEqualToString: @"Useable"]){
        STLog(@"===============%@",[UICKeyChainStore keyChainStore][@"orPingNet"]);
        if ([ [UICKeyChainStore keyChainStore][@"orPingNet"] isEqualToString: @"YES"]){
            [_missNetV removeFromSuperview];
            [self startR];
        }else{
            [self setMissNetV];
        }
    }else{
        [self setMissNetV];
    }
}

//MARK: NSURLSession代码段
-(void) startR{
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.1:8080/?action=stream"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.networkServiceType = NSURLNetworkServiceTypeDefault;
    //设置请求超时时间
    config.timeoutIntervalForRequest = 15;
    config.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //创建网络任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    //5 发起网络任务
    [task resume];
}
//已经接受到响应头
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSData *data = [NSData dataWithData:self.data];
    self.img = [[UIImage alloc]initWithData:data];
    _trafficV.monitorIV.image = self.img;
    [self.data setLength:0];
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.data appendData:data];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TrafficVDel
- (void)toUp {
    NSString *str = @"to Up";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [sendTcpSocket writeData:data withTimeout:60 tag:100];
}
- (void)toDown {
    NSString *str = @"to Down";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [sendTcpSocket writeData:data withTimeout:60 tag:100];
}

- (void)toLeft {
    NSString *str = @"to left";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [sendTcpSocket writeData:data withTimeout:60 tag:100];
}

- (void)toRight {
    NSString *str = @"to right";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 发送消息 这里不需要知道对象的ip地址和端口
    [sendTcpSocket writeData:data withTimeout:60 tag:100];
}

#pragma mark - MissNetVDel
- (void)toGo {
    //[self decideNet];
}
#pragma mark - AppDel
- (void)toWakeUp:(NSDictionary *)dict {
    STLog(@"noti = %@",[dict objectForKey:@"num"]);
    [self decideNet];
}
//方法:网络通知:
-(void)setNet:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    STLog(@"dict = %@",dict);
    _netUseVals =  dict[@"ifnetUse"];
}
//方法:监听到通知之后调用的方法(进入前台)
//- (void)setRequest:(NSNotification *)noti {
//    STLog(@"noti = %@",[noti.object objectForKey:@"enterForeTai"]);
//    [self decideNet];
//}
//方法:监听到通知之后调用的方法（ping通）zywifibot网络
- (void)setRes:(NSNotification *)noti {
    [self decideNet];
}
//TCPSocket
- (void) setTcpSocket {
    dispatch_queue_t dQueue = dispatch_queue_create("client tdp socket", NULL);
    // 1. 创建一个 udp socket用来和服务端进行通讯
    sendTcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    // 2. 连接服务器端. 只有连接成功后才能相互通讯 如果60s连接不上就出错
    NSString *host = @"10.10.53.4";
    uint16_t port = 60000;
    [sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
    // 连接必须服务器在线
}
#pragma mark - 代理方法表示连接成功/失败 回调函数(GCDAsyncSocketDelegate)
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    STLog(@"连接成功");
    // 等待数据来啊
    [sock readDataWithTimeout:-1 tag:200];
}
// 如果对象关闭了 这里也会调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    STLog(@"连接失败 %@", err);
    // 断线重连
    NSString *host = @"10.10.53.4";
    uint16_t port = 60000;
    [sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
}
#pragma mark - 消息发送成功 代理函数
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    STLog(@"消息发送成功");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //NSString *ip = [sock connectedHost];
    //uint16_t port = [sock connectedPort];

    STLog(@"%@",data);

    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    //STLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
    [HudTips showToast: s showType:Pos animationType:StToastAnimationTypeScale];
    // 每次读取完数据，都要调用下面的方式
    [sock readDataWithTimeout:-1 tag:0];
}

///--------------------------------------
#pragma mark - SLWebSocketDelegate
///--------------------------------------

//-(void)webSocketDidReceivedMessage:(id)message{
//
//    [HudTips showToast: message showType:Pos animationType:StToastAnimationTypeScale];
//}
//
//- (void)onLogin:(WebSocketStatus)state
//{
//    if (state == WebSocketStatusConnected) {
//        STLog(@"已登录丫");
//    }else{
//        STLog(@"未登录丫");
//    }
//}
- (void)dealloc {
    // 关闭套接字
    [sendTcpSocket disconnect];
    sendTcpSocket = nil;
    // 移除监听者
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterForeTai" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orPingNet" object:nil];
}
@end
