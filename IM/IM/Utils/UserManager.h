//
//  UserManager.h
//  IM
//
//  Created by zhulinyin on 2019/5/11.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Main/Model/UserModel.h"
#import <UIKit/UIKit.h>
#import "SocketRocketUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

@property NSInteger seq;
+(instancetype) getInstance;
-(void) login:(NSString *)username withPassword:(NSString *)password;
-(void) register:(NSString *)username withPassword:(NSString *)password;
-(UserModel*) getLoginModel;
-(void) logout;
@end

NS_ASSUME_NONNULL_END
