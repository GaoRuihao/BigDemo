//
//  GHHTableViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/29.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHTableViewController.h"

@interface GHHTableViewController ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation GHHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
