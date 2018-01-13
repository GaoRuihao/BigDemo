//
//  LumiRequest.m
//  HowBigDemo
//
//  Created by Hao on 2017/12/27.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "LumiRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface LumiRequest() {
    HTTPBaseURLType _baseURLType;
//    NSString *_path;
//    NSDictionary _params;
}

@property(nonatomic, strong)AFHTTPSessionManager *manager;

@end

@implementation LumiRequest

+ (instancetype)instance {
    static LumiRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[LumiRequest alloc] init];
    });
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.baseURL = @"https://aiot-rpc.aqara.cn/lumi";
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        [self setHeader];
    }
    return self;
}

- (void)postWithURL:(NSString *)path parmas:(NSDictionary *)parmas completeHandle:(LumiResponseBlock)completeHandle {
    NSString *url = [self.baseURL stringByAppendingPathComponent:path];
    NSURLSessionDataTask *task = [self.manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *response = ((NSDictionary *)responseObject)[@"result"];
        NSLog(@"Success 🐶🐶:  %@", response);
        if (completeHandle != nil) {
            completeHandle(response, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail 🐱🐱: %@", error);
        if (completeHandle != nil) {
            completeHandle(nil, error);
        }
    }];

    [task resume];
}

- (void)getWithURL:(NSString *)path parmas:(NSDictionary *)parmas completeHandle:(LumiResponseBlock)completeHandle {
     NSString *url = [self.baseURL stringByAppendingPathComponent:path];
    NSURLSessionDataTask *task = [self.manager GET:url parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = ((NSDictionary *)responseObject)[@"result"];
        NSLog(@"Success 🐶🐶:  %@", response);
        if (completeHandle != nil) {
            completeHandle(response, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail 🐱🐱: %@", error);
        if (completeHandle != nil) {
            completeHandle(nil, error);
        }
    }];
    [task resume];
}

- (void)setHeader {
    [self.manager.requestSerializer setValue:@"b7b84bb320389270.9951584441102893" forHTTPHeaderField:@"Userid"];
    [self.manager.requestSerializer setValue:@"283980881454a22d80f052ad1324af75" forHTTPHeaderField:@"Token"];
    [self.manager.requestSerializer setValue:@"255fe006ca7fc1f72179935e" forHTTPHeaderField:@"Appid"];
    [self.manager.requestSerializer setValue:@"Ap6exu8kRxlCksPitz3MfCk0yeBbbLeA" forHTTPHeaderField:@"Appkey"];
}

// 
- (void)setHTTPBaseURLType:(HTTPBaseURLType)type {
    switch (type) {
        case HTTPBaseURLChina:
            self.baseURL = @"https://aiot-rpc.aqara.cn/lumi";
            break;
        case HTTPBaseURLAmerica:
            self.baseURL = @"";
            break;
        default:
            break;
    }
    
    _baseURLType = type;
}

- (HTTPBaseURLType)getHTTPBaseURLType {
    return _baseURLType;
}



@end
