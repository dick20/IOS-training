//
//  ChatView.h
//  IM
//
//  Created by zhulinyin on 2019/5/8.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ChatViewDelegate <NSObject>
- (void)sendMessage:(NSString *)type text:(NSString *)text;
@end

@interface ChatView : UIView

@property (nonatomic, strong) NSMutableArray *chatMsg;
@property (nonatomic, weak) id<ChatViewDelegate> delegate;
- (void)addMessage:(MessageModel *)message;
@end

NS_ASSUME_NONNULL_END
