//
//  User.m
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.userId = [coder decodeIntegerForKey:@"id"];
        self.nickname = [coder decodeObjectForKey:@"name"];
        self.isVip = [coder decodeBoolForKey:@"isVip"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.userId forKey:@"id"];
    [coder encodeObject:self.nickname forKey:@"name"];
    [coder encodeBool:self.isVip forKey:@"isVip"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
