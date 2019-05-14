//
//  ContactTableViewCell.h
//  Main Page
//
//  Created by Ray Shaw on 2019/4/25.
//  Copyright © 2019年 Ray Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ContactProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *ContactName;

@end

NS_ASSUME_NONNULL_END
