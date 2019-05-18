# IOS-training
中山大学IOS实训项目


//
//  infoModifiedViewController.h
//  IM
//
//  Created by student7 on 2019/5/18.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#ifndef infoModifiedViewController_h
#define infoModifiedViewController_h

#import <UIKit/UIKit.h>

@interface InfoModifiedViewController : UIViewController


@end

#endif /* infoModifiedViewController_h */




//
//  infoModifiedViewController.m
//  IM
//
//  Created by student7 on 2019/5/18.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "InfoModifiedViewController.h"

@interface InfoModifiedViewController.h ()
@property (weak, nonatomic) UITextField *editText; // 修改的输入文本框
@property (weak, nonatomic) NSString *titleText; // 页面的标题item

@end

@implementation InfoModifiedViewController

- (instancetype) initWithString : str{
    self.titleText = str;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editText = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
}
/*
 登录功能
 */
- (IBAction)loginEvent:(id)sender {
    
}

@end
