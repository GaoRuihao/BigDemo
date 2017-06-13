//
//  ViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/2.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "RequestViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *jsBtn;
@property (nonatomic, strong)NSArray *functionArray;
@property (nonatomic, strong)NSArray *selectorArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.jsBtn addTarget:self action:@selector(jsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.functionArray = @[@"oc和js交互", @"webView拦截URL", @"NSURLSession"];
    self.selectorArray = @[@"jsBtnAction:", @"urlInterceptedAction:", @"urlSessionAction:"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:nil options:nil] firstObject];
    }
    cell.textLabel.text = self.functionArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *aSelectorName = self.selectorArray[indexPath.row];
    [self performSelector:NSSelectorFromString(aSelectorName) withObject:nil afterDelay:0.0];
}

#pragma mark - Action
- (void)jsBtnAction:(id)sender {
    RootViewController *rootVC = [[RootViewController alloc] init];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootVC];
//    [self presentViewController:navi animated:YES completion:nil];
    [self.navigationController pushViewController:rootVC animated:YES];
}

- (IBAction)urlInterceptedAction:(id)sender {
    MainViewController *mainVC = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mainVC];
//    [self presentViewController:navi animated:YES completion:nil];
}

- (void)urlSessionAction:(id)sender {
    RequestViewController *mainVC = [[RequestViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
