//
//  VideoManagerCenter.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/19.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoManagerCenter : NSObject

+ (VideoManagerCenter *)shareInstance;

- (void)compressionSession:(NSArray *)fileURLs completeHandler:(void(^)(NSURL *mergeFileFath))block;

@end
