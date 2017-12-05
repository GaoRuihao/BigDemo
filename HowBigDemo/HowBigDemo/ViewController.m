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
#import "GPUCameraDemoViewController.h"
#import <objc/runtime.h>
#import "LogicTest.h"
#import "LoadImageViewController.h"
#import "ShowImageViewController.h"


#import "VideoManagerCenter.h"
#import "VideoEditViewController.h"
#import "GHHMediator+ModuleAActions.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *jsBtn;
@property (nonatomic, strong)NSArray *functionArray;
@property (nonatomic, strong)NSArray *selectorArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.functionArray = @[@"oc和js交互", @"webView拦截URL", @"NSURLSession", @"美颜功能", @"tableViewCell加载大图"];
    self.selectorArray = @[@"RootViewController", @"MainViewController", @"RequestViewController",  @"GPUCameraDemoViewController", @"LoadImageViewController"];
    
    BOOL hadLocalVideo = [[VideoManagerCenter shareInstance] restoreLocalVideo];
    if (hadLocalVideo) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"还有上次编辑视频，是否继续" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            VideoEditViewController *editVC = [[VideoEditViewController alloc] init];
            editVC.videosArray = [VideoManagerCenter shareInstance].videoPathArray;
            [self.navigationController pushViewController:editVC animated:YES];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[VideoManagerCenter shareInstance] clearLocalVideos];
            
        }];
        
        [alertVC addAction:OKAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    // KVO
    // 在我们对某个对象完成监听的注册后，编译器会修改监听对象（上文中的tableView）的isa指针，让这个指针指向一个新生成的中间类。
    NSLog(@"address: %p", self.tableView);
    NSLog(@"class method: %@", self.tableView.class);
    NSLog(@"description method: %@", self.tableView);
    NSLog(@"use runtime to get class: %@", object_getClass(self.tableView));
    [self.tableView addObserver: self forKeyPath: @"contentOffset" options: NSKeyValueObservingOptionNew context: nil];
    NSLog(@"===================================================");
    NSLog(@"address: %p", self.tableView);
    NSLog(@"class method: %@", self.tableView.class);
    NSLog(@"description method: %@", self.tableView);
    NSLog(@"use runtime to get class %@", object_getClass(self.tableView));
    
    // 测试指针
    LogicTest *test = [[LogicTest alloc] init];
    [test testPointer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
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
    NSString *className = self.selectorArray[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = self.functionArray[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
//    UIViewController *viewController = [[GHHMediator Instance] JumpViewController];
//    [self.navigationController pushViewController:viewController animated:YES];
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
