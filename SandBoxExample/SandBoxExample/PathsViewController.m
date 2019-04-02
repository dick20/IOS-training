//
//  PathsViewController.m
//  SandBoxExample
//
//  Created by Nami on 2019/3/11.
//  Copyright © 2019 bytedance. All rights reserved.
//

#import "PathsViewController.h"

@interface PathsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PathsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 获取document目录
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];

    // 获取Cache目录
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];

    // 获取Library目录
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryPaths objectAtIndex:0];

    // 获取Tmp目录
    NSString *tmpPath = NSTemporaryDirectory();

    _label.text = [NSString stringWithFormat:@"Document: %@\nCache: %@\nLibrary: %@\nTmp: %@", documentPath, cachePath, libraryPath, tmpPath];
}



@end
