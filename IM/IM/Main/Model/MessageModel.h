//
//  MessageModel.h
//  IM
//
//  Created by Ray Shaw on 2019/4/27.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property NSInteger Seq;
@property (strong, nonatomic) NSString* SenderID;
@property (strong, nonatomic) NSString* ReceiverID;
@property (strong, nonatomic) NSDate* TimeStamp;
@property (strong, nonatomic) NSString* Type;
@property (strong, nonatomic) NSString* Content;

- (instancetype)initWithProperties:(NSInteger)Seq
                          SenderID:(NSString *)SenderID
                        ReceiverID:(NSString *)ReceiverID
                         TimeStamp:(NSDate *)TimeStamp
                              Type:(NSString *)Type
                           Content:(NSString *)Content;

@end

NS_ASSUME_NONNULL_END
