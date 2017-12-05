//
//  TargetManager.h
//  HowBigDemo
//
//  Created by Hao on 2017/12/4.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetManager : NSObject

- (UIViewController *)Action_RootViewController;

// 容错
- (id)Action_nativeNoImage:(NSDictionary *)params;

@end
