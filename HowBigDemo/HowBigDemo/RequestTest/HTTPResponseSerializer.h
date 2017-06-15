//
//  HTTPResponseSerializer.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResponseSerializer : NSObject
// 编码格式
@property(nonatomic, assign)NSStringEncoding stringEncoding;
// 状态码
@property(nonatomic, strong)NSIndexSet *acceptableStatusCodes;

@property(nonatomic, strong)NSArray *acceptableContentTypes;

@end
