//
//  InfoViewController.h
//  IM
//
//  Created by zhulinyin on 2019/4/27.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *Birthplace;
@property (weak, nonatomic) IBOutlet UILabel *NickName;
@property (weak, nonatomic) IBOutlet UILabel *ID;
@property (weak, nonatomic) IBOutlet UILabel *Gender;
@property (strong, nonatomic) UserModel* User;
@property (weak, nonatomic) IBOutlet UIImageView *ProfilePicture;

@end

NS_ASSUME_NONNULL_END
