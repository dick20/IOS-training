//
//  FileExploreViewController.m
//  FileExplore
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "FileExploreViewController.h"
#import "FileInfoViewController.h"

@interface FileExploreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<NSString*> *directoryList;
@property(nonatomic, strong) NSMutableArray<NSString*> *fileList;
@property(nonatomic, strong) NSString *directory;

@end

@implementation FileExploreViewController

- (instancetype)initWithDirectory:(NSString*)directory {
    if (self = [super init]) {
        self.directory = directory;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.directory == nil) {
        self.directory = @"/Users/zhangtianfu";
    }
    
    self.navigationItem.title = self.directory;
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)loadData {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.directory error:nil];
    
    self.directoryList = [NSMutableArray array];
    self.fileList = [NSMutableArray array];
    
    for (NSString *name in contents) {
        if ([name hasPrefix:@"."]) {
            continue;// 过滤隐藏文件
        }
        
        NSString *path = [self.directory stringByAppendingPathComponent:name];
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
            if (isDirectory) {
                [self.directoryList addObject:name];
            } else {
                [self.fileList addObject:name];
            }
        }
    }
}

#pragma mark ------------ UITableViewDataSource ------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isDirectory = (section == 0);
    if (isDirectory) {
        return self.directoryList.count;
    } else {
        return self.fileList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%zd", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BOOL isDirectory = (indexPath.section == 0);
    if (isDirectory) {
        cell.imageView.image = [UIImage imageNamed:@"icon_directory.jpg"];
        cell.textLabel.text = self.directoryList[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = self.fileList[indexPath.row];
    }
    
    return cell;
}

#pragma mark ------------ UITableViewDelegate ------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL isDirectory = (indexPath.section == 0);
    if (isDirectory) {
        NSString *path = [self.directory stringByAppendingPathComponent:self.directoryList[indexPath.row]];
        FileExploreViewController *controller = [[FileExploreViewController alloc] initWithDirectory:path];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSString *path = [self.directory stringByAppendingPathComponent:self.fileList[indexPath.row]];
        FileInfoViewController *controller = [[FileInfoViewController alloc] initWithFilePath:path];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
    }
}


@end
