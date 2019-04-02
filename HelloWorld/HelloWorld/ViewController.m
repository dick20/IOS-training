//
//  ViewController.m
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/20.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "ViewController.h"
#import "UIComponentViewController.h"
#import "CustomDrawViewController.h"
#import "TableViewController.h"
#import "HomeViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray<NSString*> *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataList = @[@"UI控件", @"自绘制", @"TableView", @"blueView"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIComponentViewController *controller = [[UIComponentViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 1) {
        CustomDrawViewController *controller = [[CustomDrawViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 2) {
        TableViewController *controller = [[TableViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 3) {
        HomeViewController *controller = [[HomeViewController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
}


@end


