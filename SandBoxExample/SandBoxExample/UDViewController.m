//
//  UDViewController.m
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "UDViewController.h"
#import "User.h"

@interface UDViewController ()

@end

@implementation UDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // save
    [[NSUserDefaults standardUserDefaults] setInteger:1024 forKey:@"x"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Tom" forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:@{
                                                       @"text": @"Cancel",
                                                       @"color": @"#ff0000",
                                                       } forKey:@"button"];
    User *user = [[User alloc] init];
    user.userId = 123;
    user.nickname = @"Tom";
    user.isVip = YES;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];

    // read
    NSInteger x = [[NSUserDefaults standardUserDefaults] integerForKey:@"x"];
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"button"];
    data = [[NSUserDefaults standardUserDefaults] dataForKey:@"user"];
    user = [NSKeyedUnarchiver unarchivedObjectOfClass:[User class] fromData:data error:nil];
}

@end
