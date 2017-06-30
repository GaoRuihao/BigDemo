//
//  LoadImageCell.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/29.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "LoadImageCell.h"

@interface LoadImageCell()

@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UILabel *label1;
@property(nonatomic, strong)UIImageView *imageView1;
@property(nonatomic, strong)UIImageView *imageView2;
@property(nonatomic, strong)UIImageView *imageView3;

@end

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
    if (!self.label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor redColor];
        self.label.font = [UIFont boldSystemFontOfSize:13];
        self.label.tag = 4;
        [cell.contentView addSubview:self.label];
    }
    _label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    
    if (!self.label1) {
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
        self.label1.lineBreakMode = NSLineBreakByWordWrapping;
        self.label1.numberOfLines = 0;
        self.label1.backgroundColor = [UIColor clearColor];
        self.label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
        self.label1.font = [UIFont boldSystemFontOfSize:13];
        self.label1.tag = 5;
        [cell.contentView addSubview:self.label1];
    }
    _label1.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    
}

//加载第一张
- (void)addImage1With:(UITableViewCell *)cell {
    //第一张
    if (!self.imageView1) {
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
        self.imageView1.tag = 1;
        [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            [cell.contentView addSubview:self.imageView1];
        } completion:nil];
    }
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path1];
    _imageView1.contentMode = UIViewContentModeScaleAspectFit;
    _imageView1.image = image;
    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
//    imageView2.tag = 1;
//    imageView2.contentMode = UIViewContentModeScaleAspectFit;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
//        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView2.image = image2;
//            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//                [cell.contentView addSubview:imageView2];
//            } completion:nil];
//        });
//    });
}



//加载第二张
- (void)addImage2With:(UITableViewCell *)cell {
    //第二张
    if (!self.imageView2) {
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
        self.imageView2.tag = 2;
        
        [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            [cell.contentView addSubview:self.imageView2];
        } completion:nil];
    }
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView2.image = image1;
    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
//    imageView2.tag = 2;
//    imageView2.contentMode = UIViewContentModeScaleAspectFit;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
//        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView2.image = image2;
//            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//                [cell.contentView addSubview:imageView2];
//            } completion:nil];
//        });
//    });
}
//加载第三张
- (void)addImage3With:(UITableViewCell *)cell {
    //第三张
    if (!self.imageView3) {
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
        self.imageView3.tag = 2;
        
        [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            [cell.contentView addSubview:self.imageView3];
        } completion:nil];
    }
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:path1];
    self.imageView3.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView3.image = image1;
    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
//    imageView2.tag = 3;
//    imageView2.contentMode = UIViewContentModeScaleAspectFit;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"png"];
//        UIImage *image2 = [UIImage imageWithContentsOfFile:path1];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView2.image = image2;
//            [UIView transitionWithView:cell.contentView duration:0.3 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
//                [cell.contentView addSubview:imageView2];
//            } completion:nil];
//        });
//    });
    
}

@end
