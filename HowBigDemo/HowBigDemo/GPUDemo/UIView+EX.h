//
//  UIView+EX.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/15.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EX)

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat originX;
@property(nonatomic) CGFloat originY;

@property(nonatomic, readonly)CGFloat maxX;
@property(nonatomic, readonly)CGFloat maxY;

@end
