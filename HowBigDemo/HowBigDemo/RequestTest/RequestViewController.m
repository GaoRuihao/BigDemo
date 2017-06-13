//
//  RequestViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "RequestViewController.h"
#import "DefaultRequest.h"

@interface RequestViewController ()

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [DefaultRequest requestURL:nil block:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSURLResponse *aaa = response;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
