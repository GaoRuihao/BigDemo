//
//  DeviceModel.m
//  HowBigDemo
//
//  Created by Hao on 2018/1/13.
//  Copyright © 2018年 高瑞浩. All rights reserved.
//

#import "DeviceModel.h"
#import <WCDB/WCDB.h>

@interface DeviceModel()<WCTTableCoding>

WCDB_PROPERTY(mid)
WCDB_PROPERTY(user_id)
WCDB_PROPERTY(to_id)
WCDB_PROPERTY(from_id)

@property(nonatomic, strong)WCTDatabase *database;

@end

@implementation DeviceModel

WCDB_IMPLEMENTATION(DeviceModel)
WCDB_SYNTHESIZE(DeviceModel, mid)
WCDB_SYNTHESIZE(DeviceModel, user_id)
WCDB_SYNTHESIZE(DeviceModel, to_id)
WCDB_SYNTHESIZE(DeviceModel, from_id)

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)update {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    self.mid =  [dateFormatter stringFromDate:date];
    self.user_id = @"10086";
    self.to_id = @"10010";
    self.from_id = @"testttt";
}

- (void)insertIntoDB:(WCTDatabase *)database {
    DeviceModel *t4est = [[DeviceModel alloc] init];
    [t4est update];
    t4est.user_id = @"60098";
    if ([database isOpened]) {
        BOOL result = [database insertObject:t4est into:@"Device"];
        NSLog(@"database test 🐶🐶: %@", result?@"YES":@"NO");
    } else {
        NSLog(@"error 🐶🐶");
    }
}

- (NSArray *)search {
    NSArray<DeviceModel *> *array = [self.database getObjectsOfClass:DeviceModel.class fromTable:@"Device" offset:0];
    return array;
}

+ (WCTDatabase *)setupDatabase {
    // 1.获取Documents路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.创建文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test"];
    
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:filePath];
    if (![database isTableExists:@"Device"]) {
        BOOL result = [database createTableAndIndexesOfName:@"Device" withClass:DeviceModel.class];
    }
    return database;
}

@end
