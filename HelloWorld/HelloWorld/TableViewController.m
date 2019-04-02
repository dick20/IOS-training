//
//  TableViewController.m
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "TableViewController.h"
#import "LoadingTableViewCell.h"

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property(nonatomic, strong) NSMutableArray<NSDictionary<NSString*, id>*> *dataList;
@property(nonatomic, strong) NSMutableArray<NSString*> *dataList;
@property(nonatomic, assign) LoadingStatus status;
@property(nonatomic, assign) NSInteger pageIndex;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TableView";
    
    // Do any additional setup after loading the view, typically from a nib.
    

 
    //                      @{@"name": @"动物",
    //                        @"list": @[@"老鼠", @"老虎", @"兔子", @"龙", @"蛇"]},
    //                      @{@"name": @"水果",
    //                        @"list": @[@"苹果", @"菠萝", @"西瓜", @"桔子"]},
    //                      @{@"name": @"蔬菜",
    //                        @"list": @[@"白菜", @"蒜苗", @"花菜", @"黄瓜"]},
    //                      ] mutableCopy];
    NSArray *fistPage = [self generateData:0];
    self.dataList = [NSMutableArray arrayWithArray:fistPage];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
#if 0
    tableView.editing = YES;
#endif
}

- (NSArray*)generateData:(NSInteger)pageIndex {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    NSInteger begin = pageIndex*10;
    for (NSInteger i = begin; i < begin+10; i++) {
        NSString *text = [NSString stringWithFormat:@"row:%zd", i];
        [result addObject:text];
    }
    
    return result;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count + 1; // 增加的1为加载更多
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLodingCell = (indexPath.row == self.dataList.count);
    NSString *cellID = [NSString stringWithFormat:@"cellID:%d", isLodingCell];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        if (isLodingCell) {
            cell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            ((LoadingTableViewCell*)cell).status = self.status;
            cell.selectionStyle = ((self.status == LoadingStatusDefault) ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone);
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.text = self.dataList[indexPath.row];
        }
    }
    
    if (isLodingCell) {
        ((LoadingTableViewCell*)cell).status = self.status;
        cell.selectionStyle = ((self.status == LoadingStatusDefault) ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone);
    } else {
        cell.textLabel.text = self.dataList[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLodingCell = (indexPath.row == self.dataList.count);
    if (isLodingCell) {
        self.status = LoadingStatusLoding;
        [tableView reloadData]; // 从默认态切换到加载状态，需要更新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.pageIndex++;
            if (self.pageIndex < 2) {
                self.status = LoadingStatusDefault;
            } else {
                self.status = LoadingStatusNoMore;
            }
            
            NSArray *newPage = [self generateData:self.pageIndex];
            [self.dataList addObjectsFromArray:newPage];
            
            [tableView reloadData];  // 从默认态切换到加载状态或者加载技术，需要更新
        });
    }
}

#if 0
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (UITableViewCellEditingStyleInsert == editingStyle) {
        [self.dataList insertObject:[NSString stringWithFormat:@"new row:%zd", indexPath.row] atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
#endif


#if 0
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [tableView exchangeSubviewAtIndex:sourceIndexPath.row withSubviewAtIndex:destinationIndexPath.row];
}
#endif

@end


