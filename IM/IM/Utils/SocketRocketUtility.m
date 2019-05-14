//
//  SocketRocketUtility.m
//  IM
//
//  Created by zhulinyin on 2019/5/11.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "SocketRocketUtility.h"
//#import <AFNetworkReachabilityManager.h>

// 弱引用
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

// 确保运行在主线程的宏
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
    //SocketDataType type;
    NSString *host;
}

@property (nonatomic,strong) SRWebSocket *socket;

@end

@implementation SocketRocketUtility

+ (SocketRocketUtility *)instance{
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

// 开启连接
- (void) SRWebSocketOpen{
    //如果是同一个url return
    if (self.socket) {
        return;
    }
    if(self.socket.readyState == SR_OPEN){
        return;
    }
    
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://118.89.65.154:6789"]]]];//这里填写你服务器的地址
    
    NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);
    self.socket.delegate = self;   //实现这个 SRWebSocketDelegate 协议
    [self.socket open];     //open 就是直接连接了
    
}

// 成功连接的操作
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //开启心跳
    //[self initHeartBeat];
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接成功************************** ");
        [self wsOperate:@"connect" data:[[UserManager getInstance] getLoginModel].UserID];
    }
}

// 连接失败的操作
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接失败************************** ");
        _socket = nil;
        //连接失败就重连
        [self reConnect];
    }
}

// ws操作
- (void) wsOperate: (NSString *) action data:(NSString *)data {
    NSDictionary *configDic = @{
                                @"action" : action,
                                @"data"   : data
                                };
    NSError *error;
    NSString *sdata;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configDic
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@" error: %@", error.localizedDescription);
        return;
    } else {
        sdata = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    WeakSelf(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakself.socket != nil) {
            
            // 只有 SR_OPEN 开启状态才能调 send 方法啊, 不然要崩
            if (weakself.socket.readyState == SR_OPEN) {
                NSLog(@"in:::::");
                [weakself.socket send:sdata];    // 发送数据
                
            } else if (weakself.socket.readyState == SR_CONNECTING) {
                [self reConnect];
                
            } else if (weakself.socket.readyState == SR_CLOSING || weakself.socket.readyState == SR_CLOSED) {
                // websocket 断开了, 调用 reConnect 方法重连
                [self reConnect];
            }
        } else {
            //如果在发送数据，但是socket已经关闭，可以在再次打开
            [self SRWebSocketOpen];
        }
    });
}

// disconnect操作

// 接受消息
#pragma mark - socket delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    if (webSocket == self.socket) {
        
        NSLog(@"message:%@",message);
        if(!message){
            return;
        }
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        if(e) {
            NSLog(@"error");
        }
        if([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            if([result[@"state"] isEqualToString:@"ok"]) {
                if([result[@"msg"] isEqualToString:@"connected"] ||
                   [result[@"msg"] isEqualToString:@"new"]) {
                    [self getMessage];
                }
            }
            else {
                NSLog(@"login fail");
            }
        }
        else {
            NSLog(@"Not dictionary");
        }
        
    }
}

- (void) getMessage{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://118.89.65.154:8000/message/%ld", [UserManager getInstance].seq]];

    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil) {
            if(NSClassFromString(@"NSJSONSerialization")) {
                NSError *e = nil;
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
                if(e) {
                    NSLog(@"error");
                }
                if([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *result = object;
                    if([result[@"state"] isEqualToString:@"ok"]) {
                        NSLog(@"get message success");
                        NSArray *messages = result[@"data"];
                        NSLog(@"new messages num: %lu", messages.count);
                        for (int i=0; i<messages.count; i++) {
                            /*NSInteger seq = [messages[i][@"Seq"] integerValue];
                            if(seq > [UserManager getInstance].seq) {
                                [UserManager getInstance].seq = seq;
                            }*/
                            [UserManager getInstance].seq++;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessages" object:messages];
                    }
                    else {
                        NSLog(@"get message fail");
                    }
                }
                else {
                    NSLog(@"Not dictionary");
                }
            }
        }
        else {
            NSLog(@"网络异常");
        }
    }];
    [task resume];
    
}
// 关闭连接
-(void)SRWebSocketClose{
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        
        //断开连接时销毁心跳
        //[self destoryHeartBeat];
    }
}

// 心跳
- (void) ping{
    if(self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

- (void) initHeartBeat{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        heartBeat = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(ping) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:heartBeat forMode:NSRunLoopCommonModes];
    })
}

//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            if ([heartBeat respondsToSelector:@selector(isValid)]){
                if ([heartBeat isValid]){
                    [heartBeat invalidate];
                    heartBeat = nil;
                }
            }
        }
    })
}

// 重连
- (void)reConnect
{
    
    [self SRWebSocketClose];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64*2) {
        //您的网络状况不是很好, 请检查网络后重试
        return;
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpen];
        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
    
}

- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"SocketRocketUtility dealloced");
}

//- (void)registerNetworkNotifications{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChangedNote:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
//}


@end
