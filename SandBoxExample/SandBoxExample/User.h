//
//  User.h
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject <NSSecureCoding>

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) BOOL isVip;

@end

NS_ASSUME_NONNULL_END
