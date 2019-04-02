//
//  IOViewController.m
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "IOViewController.h"
#import "User.h"

@interface IOViewController ()

@end

@implementation IOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)write:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"text.txt"];

    NSString *contents = @"Hello world!";
    [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)read:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"text.txt"];

    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"content %@", content);
}

- (IBAction)writeArray:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"array.plist"];

    NSArray *array = @[@"A", @"B", @"C"];
    [array writeToFile:filePath atomically:YES];
}

- (IBAction)readArray:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"array.plist"];

    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"array %@", array);
}

- (IBAction)writeData:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"data"];

    Byte byteData[] = {2,3,5,7,11,13,17,19};

    NSData *data = [NSData dataWithBytes:byteData length:8];

    [data writeToFile:filePath atomically:YES];
}

- (IBAction)readData:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"data"];

    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"data %@", data);
}

- (IBAction)writeCustomType:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"user"];

    User *user = [[User alloc] init];
    user.userId = 123;
    user.nickname = @"Tom";
    user.isVip = YES;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:nil];
    [data writeToFile:filePath atomically:YES];
}

- (IBAction)readCustomType:(id)sender {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *filePath = [document stringByAppendingPathComponent:@"user"];

    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSError *error;
    User *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[User class] fromData:data error:&error];
    NSLog(@"user %ld %@ %d", user.userId, user.nickname, user.isVip);
}

@end
