//
//  LumiRequest.h
//  HowBigDemo
//
//  Created by Hao on 2017/12/27.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LumiResponseBlock)(NSDictionary *response, NSError *error);

typedef enum : NSUInteger {
    HTTPBaseURLChina = 0,       //大陆
    HTTPBaseURLAmerica,         //美国
} HTTPBaseURLType;

@interface LumiRequest : NSObject

@property(nonatomic, strong)NSString *baseURL;


/**
 *  AIOT接口服务器地址
 */
@property(nonatomic)HTTPBaseURLType baseURLType;

+ (instancetype)instance;

- (void)postAsyncCompleteHandler:(LumiResponseBlock)completeHandler;

- (void)postWithURL:(NSString *)path parmas:(NSDictionary *)parmas completeHandle:(LumiResponseBlock)completeHandle;

- (void)getWithURL:(NSString *)path parmas:(NSDictionary *)parmas completeHandle:(LumiResponseBlock)completeHandle;

- (NSString *)localIPAddress;

@end
