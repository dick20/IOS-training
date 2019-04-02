//
//  LoadingTableViewCell.h
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// 加载状态
//
typedef enum : NSUInteger {
    LoadingStatusDefault, // 默认状态
    LoadingStatusLoding,  // 正在加载
    LoadingStatusNoMore,  // 已加载全部
} LoadingStatus;

//
// 加载cell
//
@interface LoadingTableViewCell : UITableViewCell

@property(nonatomic, assign) LoadingStatus status;

@end

