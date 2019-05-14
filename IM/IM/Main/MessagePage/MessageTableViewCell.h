//
//  MessageTableViewCell.h
//  IM
//
//  Created by Ray Shaw on 2019/4/29.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ContactProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *ContactName;
@property (weak, nonatomic) IBOutlet UILabel *MessageAbstract;
@property (weak, nonatomic) IBOutlet UILabel *TimeStamp;

@end

NS_ASSUME_NONNULL_END
