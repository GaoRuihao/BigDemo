//
//  DefaultRequest.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/8.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(NSURLResponse *response, NSData *data, NSError *error);

@interface DefaultRequest : NSObject

+ (void)requestURL:(NSString *)string block:(ResponseBlock)block;

- (void)requestURL:(NSString *)string;

@end
