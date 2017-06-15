//
//  WawterFlowViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/14.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "WawterFlowViewController.h"

@interface WawterFlowViewController ()

@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation WawterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
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
