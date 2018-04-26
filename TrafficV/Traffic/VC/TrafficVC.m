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
#import "FormatDs.h"
@interface TrafficVC ()<GCDAsyncSocketDelegate,AppDel>{
    // 这个socket用来做发送使用 当然也可以接收  //<SLWebSocketDelegate>
    GCDAsyncSocket *sendTcpSocket;
}
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
    [self setUpUI];
    //发送网络请求:
    //[self performSelector:@selector(decideNet) withObject:nil/*可传任意类型参数*/ afterDelay:3];
    [self setTcpSocket];
    [AppDelegate shareIns].delegate = self;
    //程序进入后台闭包:
    [AppDelegate shareIns].dictB = ^(NSDictionary *dict, BOOL b){
        STLog(@"%@",[dict objectForKey:@"postN"]);
        [self.task cancel];
    };
//    AppDelegate *appDel=[[AppDelegate alloc]init ];
//    appDel.dictB = ^(NSDictionary *dict, BOOL b){
//        STLog(@"%@",[dict objectForKey:@"postN"]);
//    };
    [self decideNet];

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

-(void)pingNet{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //注意：responseObject:请求成功返回的响应结果（AFN内部已经把响应体转换为OC对象，通常是字典或数组）
    /**分别设置请求以及相应的序列化器*/
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/html", @"text/javascript",@"image/jpeg", nil];
    //self.LogisticCode = "538681744406"  "887102266424600383"  self.ShipperCode = "ZTO"  "YTO"
    //http://192.168.1.1:8080/?action=snapshot
    [manager GET:@"http://192.168.1.1:8080/?action=snapshot" parameters:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull res) {
        STLog(@"进了=======成功");
        [self.missNetV removeFromSuperview];
        [self startR];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        STLog(@"进了=======失败");
        //[HudTips showToast: @"未连接到局域网wifi" showType:Pos animationType:StToastAnimationTypeScale];
        [self setMissNetV];
    }];
}

-(void)decideNet{
    [self pingNet];
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
    self.task = [session dataTaskWithURL:url];
    //5 发起网络任务
    [self.task resume];
    //[task cancel];
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
//- (void)sendDs:(NSData *)sixHex{
//    [sendTcpSocket writeData:sixHex withTimeout:60 tag:100];
//    //[sendTcpSocket writeData:[str dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)] withTimeout:60 tag:100];
//}
// LS 左轮速度  LD 左轮方向  RS 右轮速度  RD 右轮方向
- (void)sendDs:(char)LS andLD:(char)LD andRS:(char)RS andRD:(char)RD{
    //ff fe 05 01 05 00
    unsigned char cmd_switch[6];
    cmd_switch[0]=(char)0xFF;//帧头
    cmd_switch[1]=(char)0xFE;//帧头
    cmd_switch[2]=LS;//左轮速度: 05
    cmd_switch[3]=LD;//方向: 正
    cmd_switch[4]=RS;//右轮速度: 05
    cmd_switch[5]=RD;//方向: 反
    [sendTcpSocket writeData:[NSData dataWithBytes: cmd_switch  length:6] withTimeout:60 tag:100];
    //计算里程:
    [self caluMiles:LS andRS:RS];
}
//LDis 左轮走过的里程   RDis 右轮走过的里程   // LS 左轮速度  RS 右轮速度
-(void)caluMiles:(char)LS andRS:(char)RS{
    float scale = 6.326 / 5;
    _lmiles += [[NSString stringWithFormat:@"%d",LS] intValue]*scale*0.1;
    _rmiles += [[NSString stringWithFormat:@"%d",RS] intValue]*scale*0.1;

    self.trafficV.LVals.text = [[FormatDs retainPoint:@"0.000" floatV:_lmiles] stringByAppendingString:@"cm"];
    self.trafficV.RVals.text = [[FormatDs retainPoint:@"0.000" floatV:_rmiles] stringByAppendingString:@"cm"];
}

#pragma mark - TrafficVDel
//- (void)toUp {
//    [self sendDs:0x5 andLD:0x0 andRS:0x5 andRD:0x0];
//}
//- (void)toDown {
//    [self sendDs:0x5 andLD:0x0 andRS:0x5 andRD:0x0];
//}
//- (void)toLeft {
//    [self sendDs:0x5 andLD:0x0 andRS:0x5 andRD:0x0];
//}
//- (void)toRight {
//    [self sendDs:0x5 andLD:0x0 andRS:0x5 andRD:0x0];
//}
-(void)toReset{
    _lmiles = 0;
    _rmiles = 0;
    self.trafficV.LVals.text = @"0.000cm";
    self.trafficV.RVals.text = @"0.000cm";
}
-(void)toControl:(NSInteger)direction{
    switch (direction) {
        case 0:{ //向上
            [self sendDs:0x05 andLD:0x01 andRS:0x05 andRD:0x01];
            break;
        }
        case 1:{//向右上
            [self sendDs:0x0F andLD:0x01 andRS:0x05 andRD:0x01];
            break;
        }
        case 2:{//向右
            [self sendDs:0x0F andLD:0x01 andRS:0x00 andRD:0x01];
            break;
        }
        case 3:{//向右下
            [self sendDs:0x0F andLD:0x00 andRS:0x05 andRD:0x00];
            break;
        }
        case 4:{//向下
            [self sendDs:0x0F andLD:0x00 andRS:0x0F andRD:0x00];
            break;
        }
        case 5:{//向左下
            [self sendDs:0x05 andLD:0x00 andRS:0x0F andRD:0x00];
            break;
        }
        case 6:{//向左
            [self sendDs:0x00 andLD:0x01 andRS:0x0F andRD:0x01];
            break;
        }
        case 7:{//向左上
            [self sendDs:0x05 andLD:0x01 andRS:0x0F andRD:0x01];
            break;
        }
        default:{//回到中心
            [self sendDs:0x00 andLD:0x00 andRS:0x00 andRD:0x00];
            break;
        }
    }
}

#pragma mark - MissNetVDel
- (void)toGo {
    [self.task cancel];
    [self decideNet];
}
#pragma mark - AppDel
- (void)toWakeUp:(NSDictionary *)dict {
    STLog(@"%@",[dict objectForKey:@"postN"]);
    [self decideNet];
}
//TCPSocket
- (void) setTcpSocket {
    dispatch_queue_t dQueue = dispatch_queue_create("client tdp socket", NULL);
    // 1. 创建一个 udp socket用来和服务端进行通讯
    sendTcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dQueue socketQueue:nil];
    // 2. 连接服务器端. 只有连接成功后才能相互通讯 如果60s连接不上就出错
    NSString *host = @"192.168.1.1";//192.168.1.1
    uint16_t port = 2001;
    [sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
    // 连接必须服务器在线
}
#pragma mark - 代理方法表示连接成功/失败 回调函数(GCDAsyncSocketDelegate)
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [HudTips showToast: @"TCP连接成功" showType:Pos animationType:StToastAnimationTypeScale];
    // 等待数据来啊
    [sock readDataWithTimeout:-1 tag:200];
}
// 如果对象关闭了 这里也会调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    //STLog(@"连接失败 %@", err);
    // 断线重连
    NSString *host = @"192.168.1.1";
    uint16_t port = 2001;
    [sendTcpSocket connectToHost:host onPort:port withTimeout:60 error:nil];
}
#pragma mark - 消息发送成功 代理函数
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    //STLog(@"消息发送成功");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //NSString *ip = [sock connectedHost];
    //uint16_t port = [sock connectedPort];
    //NSString *s = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)];
    //CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)   ============  防止乱码
    //STLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
    [HudTips showToast: [@"TCP：" stringByAppendingString:[self hexStrFromData:data]] showType:Pos animationType:StToastAnimationTypeScale];
    // 每次读取完数据，都要调用下面的方式
    [sock readDataWithTimeout:-1 tag:0];
}

//data转换为十六进制的string
- (NSString *)hexStrFromData:(NSData *)res{

    Byte *bytes = (Byte *)[res bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[res length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSLog(@"hex = %@",hexStr);
    return hexStr;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netChange" object:nil];
}
@end
