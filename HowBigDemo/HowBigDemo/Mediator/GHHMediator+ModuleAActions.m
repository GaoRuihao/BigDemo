//
//  GHHMediator+ModuleAActions.m
//  HowBigDemo
//
//  Created by Hao on 2017/12/4.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GHHMediator+ModuleAActions.h"

NSString *const kGHHMediatorTargetManager = @"Manager";

NSString *const kRootViewController = @"RootViewController";

@implementation GHHMediator(ModuleAActions)

- (UIViewController *)JumpViewController {
    UIViewController *viewController = [self performTarget:kGHHMediatorTargetManager withAction:kRootViewController params:nil shouldCacheTarget:false];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
