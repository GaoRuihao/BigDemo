//
//  GHHMediator.h
//  HowBigDemo
//
//  Created by Hao on 2017/12/4.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHHMediator : NSObject

+ (instancetype)Instance;

- (id)performTarget:(NSString *)targetName withAction:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCacheTarget:(NSString *)targetName;

@end
