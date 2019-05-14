//
//  RegisterViewController.m
//  IM
//
//  Created by zhulinyin on 2019/4/23.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "RegisterViewController.h"
#import "../Utils/UserManager.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText; // 用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordText; // 密码输入框
@property (weak, nonatomic) IBOutlet UIButton *registerBtn; // 注册按钮

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 注册功能
 */
- (IBAction)registerEvent:(id)sender {
    [[UserManager getInstance] register:self.usernameText.text withPassword:self.passwordText.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
