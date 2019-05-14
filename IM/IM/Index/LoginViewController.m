//
//  ViewController.m
//  IM
//
//  Created by zhulinyin on 2019/4/22.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "LoginViewController.h"
#import "../Utils/UserManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText; // 用户名输入文本框
@property (weak, nonatomic) IBOutlet UITextField *passwordText; // 密码输入文本框
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;    // 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *registerBtn; // 注册按钮

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/*
 登录功能
 */
- (IBAction)loginEvent:(id)sender {
    [[UserManager getInstance] login:self.usernameText.text withPassword:self.passwordText.text];
}

@end
