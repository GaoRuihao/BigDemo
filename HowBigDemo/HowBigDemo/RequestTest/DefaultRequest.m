//
//  DefaultRequest.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/8.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "DefaultRequest.h"

static id GHHJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:GHHJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = GHHJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    return JSONObject;
}

@interface DefaultRequest ()<NSURLConnectionDataDelegate, NSURLSessionDataDelegate>


@end

@implementation DefaultRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)requestURL:(NSString *)string block:(ResponseBlock)block {
    NSURL *url = [NSURL URLWithString:@"http://svr.star.vip.kankan.com/vip/getVipTitles"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    // 告诉服务器数据为 JSON 类型
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:@{@"userid":@"123456"} options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = jsondata;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // 有的时候，服务器访问正常，但是会没有数据
        // 以下的 if 是比较标准的错误处理代码
        if (connectionError != nil || data == nil) {
            //给用户的提示信息
            NSLog(@"网络不给力");
            return;
        } else {
            id result = [DefaultRequest responseObjectForResponse:response data:data error:connectionError];
            if (block) {
                block(response, result, connectionError);
            }
        }
    }];
}

- (void)requestURL:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLSession
- (void)postWithSharedSession {
    // 获取默认 Session
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建 URL
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    // 创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=1234&pwd=4321" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 获取数据后解析并输出
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
    // 启动任务
    [task resume];
}

- (void)sessionDataDelegate {
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/login?username=1234&pwd=4321"]]];
    
    // 启动任务
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
// 1. 接受到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    [response MIMEType];  // 获取返回的媒体类型
    
    NSLog(@"任务完成");
    // 必须设置对响应进行允许处理才会执行后面两个操作。
    completionHandler(NSURLSessionResponseAllow);
}


// 2. 接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data {

    // 处理每次接收的数据
    NSLog(@"%s",__func__);
}

// 3. 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"SessionTask %s",__func__);
}

#pragma mark - ConnectionDelegate
//正式接收数据(会调用多次)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}
//接收失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

// 接收数据完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}
//开始接受数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

#pragma mark - JSON
+ (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *)error{
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    
    BOOL isSpcae = [data isEqualToData:[NSData dataWithBytes:@" " length:1]];
    if (data.length == 0 || isSpcae) {
        return nil;
    }
    
    NSError *serializationError = nil;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (!responseObject) {
        return nil;
    }
    
    return GHHJSONObjectByRemovingKeysWithNullValues(responseObject, NSJSONReadingMutableContainers);
}

@end
