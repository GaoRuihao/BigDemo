//
//  DeviceModel.h
//  HowBigDemo
//
//  Created by Hao on 2018/1/13.
//  Copyright © 2018年 高瑞浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCTDatabase;

@interface DeviceModel : NSObject

@property(nonatomic, strong) NSString *mid;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *to_id;
@property(nonatomic, strong) NSString *from_id;
@property(nonatomic) int readCount; //如果是群聊就是已读消息数，如果是个人是已读和已送达（根据是否读了才判断）
@property(nonatomic) int sendState; //0是发送成功，1是正在发送，2是发送失败
@property(nonatomic, strong) NSString *msgContent;
@property(nonatomic, strong) NSString *msgTemp;
@property(nonatomic, strong) NSDate *readTime;
@property(nonatomic, strong) NSDate *showTime;
@property(nonatomic) BOOL showReadTime;
@property(nonatomic, retain) NSDate * send_time;
@property(nonatomic, strong) NSMutableArray *picList;
@property(nonatomic) BOOL voiceIsRead;
@property(nonatomic, strong) NSMutableDictionary *attachDic;
@property(nonatomic, strong) NSDictionary *notifyDic;
@property(nonatomic, strong) NSDictionary *cardDic;

- (void)update;

- (void)insertIntoDB:(WCTDatabase *)database;

- (NSArray *)search;

+ (WCTDatabase *)setupDatabase;

@end
