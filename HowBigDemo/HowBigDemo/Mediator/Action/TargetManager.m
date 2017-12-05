//
//  TargetManager.m
//  HowBigDemo
//
//  Created by Hao on 2017/12/4.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "TargetManager.h"
#import "RootViewController.h"

@implementation TargetManager

- (UIViewController *)Action_RootViewController {
    // 因为action是从属于ModuleA的，所以action直接可以使用ModuleA里的所有声明
    RootViewController *viewController = [[RootViewController alloc] init];
    return viewController;
}

@end
