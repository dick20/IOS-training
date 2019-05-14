//
//  SessionHelper.h
//  IM
//
//  Created by Ray Shaw on 2019/5/10.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionHelper : NSObject

+ (void)sendRequest:(NSString*)path method:(NSString*)method parameters:(NSString*)parameters handler:(void(^)(id))handler;

@end

NS_ASSUME_NONNULL_END
