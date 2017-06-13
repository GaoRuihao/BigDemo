//
//  UIScrollView+Additions.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/5.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "UIScrollView+Additions.h"
#import <objc/runtime.h>

@implementation UIScrollView (Additions)

+ (void)load {
//    Method contentOffsetMethod = class_getInstanceMethod([UIScrollView class], @selector(setContentOffset:));
//    
//    Method class_contentOffsetMethod = class_getInstanceMethod([UIScrollView class], @selector(class_setContentOffset:));
//    
//    method_exchangeImplementations(contentOffsetMethod, class_contentOffsetMethod);
//    
//    Method contentOffsetMethod1 = class_getInstanceMethod([UIScrollView class], @selector(setContentOffset:));
//    
//    Method ghh_contentOffsetMethod = class_getInstanceMethod([UIScrollView class], @selector(ghh_setContentOffset:));
//    
//    method_exchangeImplementations(contentOffsetMethod1, ghh_contentOffsetMethod);
    
}

-(void)class_setContentOffset:(CGPoint)contentOffset{
    NSLog(@"这里调用的先后顺序？？");
    if (contentOffset.y > self.bounds.size.height) {
        NSLog(@"change sucess!");
    } else {
        NSLog(@"change fail!");
    }
    [self class_setContentOffset:contentOffset];
}

- (void)ghh_setContentOffset:(CGPoint)contentOffset {
    NSLog(@"这里是怎么调用的");
    [self ghh_setContentOffset:contentOffset];
}



@end
