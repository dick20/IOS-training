//
//  SocketRocketUtility.h
//  IM
//
//  Created by zhulinyin on 2019/5/11.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>
#import "UserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SocketRocketUtility : NSObject

/** 连接状态 */
@property (nonatomic,assign) SRReadyState socketReadyState;
// @property (nonatomic,  copy) void (^didReceiveMessage)(id message);
+ (SocketRocketUtility *)instance;

- (void)SRWebSocketOpen;  //开启连接
- (void)SRWebSocketClose; //关闭连接
- (void)wsOperate:(NSString *) action data:(NSString *)data;
- (void)registerNetworkNotifications; //监测网络状态

@end

NS_ASSUME_NONNULL_END
