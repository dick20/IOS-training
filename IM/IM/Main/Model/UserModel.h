//
//  UserModel.h
//  IM
//
//  Created by Ray Shaw on 2019/4/27.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (strong, nonatomic) NSString* UserID;
@property (strong, nonatomic) NSString* NickName;
@property (strong, nonatomic) NSString* RemarkName;
@property (strong, nonatomic) NSString* Gender;
@property (strong, nonatomic) NSString* Birthplace;
@property (strong, nonatomic) NSString* ProfilePicture;

- (instancetype)initWithProperties:(NSString *)UserID
                          NickName:(NSString *)NickName
                        RemarkName:(NSString *)RemarkName
                            Gender:(NSString *)Gender
                        Birthplace:(NSString *)Birthplace
                        ProfilePicture:(NSString *)ProfilePicture;


@end

NS_ASSUME_NONNULL_END
