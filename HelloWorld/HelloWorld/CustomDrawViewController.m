//
//  CustomDrawViewController.m
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "CustomDrawViewController.h"
#import "CustomView.h"

@interface CustomDrawViewController ()

@end

@implementation CustomDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自绘制";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomView *view = [[CustomView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}


@end
