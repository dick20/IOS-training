//
//  ChatTableViewCell.m
//  IM
//
//  Created by zhulinyin on 2019/5/8.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "ChatTableViewCell.h"

#define ICON_WH 40

@interface ChatTableViewCell()

@property (nonatomic, strong) UIImageView  *bubbleIV;   //气泡
@property (nonatomic, strong) UIImageView *iconIV;      //头像
@property (nonatomic, strong) UILabel *contentLabel;    //文字

@end
@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView = backView;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    //头像
    self.iconIV = [[UIImageView alloc] init];
    self.iconIV.frame = CGRectMake(0, 0, ICON_WH, ICON_WH);
    self.iconIV.contentMode = UIViewContentModeScaleAspectFit;
    self.iconIV.image = [UIImage imageNamed:@"default_icon"];
    [self.contentView addSubview:self.iconIV];
    
    //背景气泡
    self.bubbleIV = [[UIImageView alloc] init];
    self.bubbleIV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bubbleIV];
    
    //消息内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor grayColor];
    [self.bubbleIV addSubview:self.contentLabel];
}

- (void)setModel:(MessageModel *)model {
    //计算文字长度
    self.contentLabel.text = model.Content;
    CGSize labelSize = [model.Content boundingRectWithSize: CGSizeMake(SCREEN_WIDTH-160, MAXFLOAT)
                                                   options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                attributes: @{NSFontAttributeName:self.contentLabel.font}
                                                   context: nil].size;
    UserModel *loginUser = [[UserManager getInstance] getLoginModel];
    self.contentLabel.frame = CGRectMake([model.SenderID isEqualToString:loginUser.UserID] ? 10 : 20 , 5, labelSize.width, labelSize.height + 10);
    
    //计算气泡位置
    CGFloat bubbleX = [model.SenderID isEqualToString:loginUser.UserID] ? (SCREEN_WIDTH - ICON_WH - 25 - labelSize.width - 30) : (ICON_WH + 25);
    self.bubbleIV.frame = CGRectMake(bubbleX, 20, self.contentLabel.frame.size.width + 30, self.contentLabel.frame.size.height+10);
    
    //头像位置
    CGFloat iconX = [model.SenderID isEqualToString:loginUser.UserID] ? (SCREEN_WIDTH - ICON_WH - 15) : 15;
    self.iconIV.frame = CGRectMake(iconX, 15, ICON_WH, ICON_WH);
    self.iconIV.image = [UIImage imageNamed: [model.SenderID isEqualToString:loginUser.UserID] ? @"peppa" : @"teemo"];
    
    //拉伸气泡
    UIImage *backImage = [UIImage imageNamed: [model.SenderID isEqualToString:loginUser.UserID] ?  @"bubble_right" : @"bubble_left"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleIV.image = backImage;
}

@end
