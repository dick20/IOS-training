//
//  FilesViewController.m
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "FilesViewController.h"

@interface FilesViewController ()

@end

@implementation FilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 判断文件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [document stringByAppendingPathComponent:@"test.txt"];

    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"test.txt exists");
    }

    BOOL isDirectory;
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {

    }

    // 创建目录
    NSString *testDir = [document stringByAppendingPathComponent:@"test"];

    NSError *error;

    [fileManager createDirectoryAtPath:testDir withIntermediateDirectories:YES attributes:nil error:&error];

    // 创建文件
    NSString *testTxt = [testDir stringByAppendingPathComponent:@"test.txt"];
    NSData *data = [@"Hello world!" dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:testTxt contents:data attributes:nil];

    // 删除文件
    [fileManager removeItemAtPath:testTxt error:nil];
}

@end
