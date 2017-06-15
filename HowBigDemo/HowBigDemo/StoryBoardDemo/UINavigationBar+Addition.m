//
//  UINavigationBar+Addition.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/15.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "UINavigationBar+Addition.h"

@implementation UINavigationBar (Addition)

-(void)setSBarTintColor:(UIColor *)SBarTintColor {
    self.barTintColor = SBarTintColor;
}

- (UIColor *)SBarTintColor {
    return self.barTintColor;
}

@end
