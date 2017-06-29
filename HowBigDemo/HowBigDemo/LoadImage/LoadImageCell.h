//
//  LoadImageCell.h
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/29.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadImageCell : UITableViewCell

- (void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)addImage1With:(UITableViewCell *)cell;

- (void)addImage2With:(UITableViewCell *)cell;

- (void)addImage3With:(UITableViewCell *)cell;

@end
