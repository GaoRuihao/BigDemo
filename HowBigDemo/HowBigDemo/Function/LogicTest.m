//
//  LogicTest.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/27.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "LogicTest.h"

@implementation LogicTest

- (void)testPointer {
    NSString *aaa = nil;
    NSLog(@"star str is: %@", aaa);
    [self doSomething:aaa];
    NSLog(@"end str is: %@", aaa);
    [self usePointerToPointer:&aaa];
    NSLog(@"use local str is: %@", aaa);
}

- (void)doSomething:(NSString *)string {
    string = @"run doSomething method";
}

- (void)usePointerToPointer:(NSString **)string {
    *string = @"run doSomething method";
}

@end
