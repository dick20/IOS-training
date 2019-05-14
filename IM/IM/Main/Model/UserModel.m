//
//  UserModel.m
//  IM
//
//  Created by Ray Shaw on 2019/4/27.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithProperties:(NSString *)UserID
                          NickName:(NSString *)NickName
                        RemarkName:(NSString *)RemarkName
                            Gender:(NSString *)Gender
                        Birthplace:(NSString *)Birthplace
ProfilePicture:(NSString *)ProfilePicture;
{
    self = [super init];
    if (self)
    {
        self.UserID = UserID;
        self.NickName = NickName;
        self.RemarkName = RemarkName;
        self.Gender = Gender;
        self.Birthplace = Birthplace;
        self.ProfilePicture = ProfilePicture;
    }
    return self;
}

@end
