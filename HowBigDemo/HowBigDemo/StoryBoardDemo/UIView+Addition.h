//
//  UIView+Addition.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/13.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 此文件不会被其他类引用，但不能删除
/// 这个类用于扩展 Interface Builder 功能，UIView 支持设置圆角和边框
@interface UIView (Addition)

@property(nonatomic) IBInspectable CGFloat  cornerRadius;
@property(nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable CGFloat  borderWidth;



@end
