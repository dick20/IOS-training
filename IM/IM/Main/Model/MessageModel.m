//
//  MessageModel.m
//  IM
//
//  Created by Ray Shaw on 2019/4/27.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithProperties:(NSInteger)Seq
                          SenderID:(NSString *)SenderID
                        ReceiverID:(NSString *)ReceiverID
                         TimeStamp:(NSDate *)TimeStamp
                              Type:(NSString *)Type
                           Content:(NSString *)Content
{
    self = [super init];
    if (self)
    {
        self.SenderID = SenderID;
        self.ReceiverID = ReceiverID;
        self.TimeStamp = TimeStamp;
        self.Seq = Seq;
        self.Type = Type;
        self.Content = Content;
    }
    return self;
}

@end
