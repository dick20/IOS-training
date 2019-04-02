//
//  FileInfoViewController.m
//  FileExplore
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "FileInfoViewController.h"

@interface FileInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, strong) NSArray<NSString*> *allAttributeKeys;
@property(nonatomic, strong) NSArray<id> *allAttributeValues;

@end

@implementation FileInfoViewController

- (instancetype)initWithFilePath:(NSString*)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.filePath lastPathComponent];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onClickBack:)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)onClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
    NSLog(@"%@", fileAttributes);
    self.allAttributeKeys = fileAttributes.allKeys;
    self.allAttributeValues = fileAttributes.allValues;
}


#pragma mark ------------ UITableViewDataSource ------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allAttributeKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.allAttributeKeys[indexPath.section];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.allAttributeValues[indexPath.section]];
    }
    
    return cell;
}



@end
