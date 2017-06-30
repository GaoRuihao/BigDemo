//
//  LoadImageCell.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/29.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "LoadImageCell.h"

@implementation LoadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//添加文字
- (void)addlabel:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    [cell.contentView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label1.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label1.font = [UIFont boldSystemFontOfSize:13];
    label1.tag = 5;
    [cell.contentView addSubview:label1];
    
}

//加载第一张
- (void)addImage1With:(UITableViewCell *)cell {
    //第一张
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
//    imageView.tag = 1;
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path1];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.image = image;
//    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//        [cell.contentView addSubview:imageView];
//    } completion:nil];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView2.tag = 1;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView2.image = image2;
            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
                [cell.contentView addSubview:imageView2];
            } completion:nil];
        });
    });
}



//加载第二张
- (void)addImage2With:(UITableViewCell *)cell {
    //第二张
//    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
//    imageView1.tag = 2;
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
//    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
//    imageView1.contentMode = UIViewContentModeScaleAspectFit;
//    imageView1.image = image1;
//    [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//        [cell.contentView addSubview:imageView1];
//    } completion:nil];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView2.tag = 2;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView2.image = image2;
            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
                [cell.contentView addSubview:imageView2];
            } completion:nil];
        });
    });
}
//加载第三张
- (void)addImage3With:(UITableViewCell *)cell {
    //第三张
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView2.tag = 3;
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView2.image = image2;
            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
                [cell.contentView addSubview:imageView2];
            } completion:nil];
        });
    });
    
}

@end
