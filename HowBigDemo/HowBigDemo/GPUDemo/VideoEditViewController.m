//
//  VideoEditViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/16.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "VideoEditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoManagerCenter.h"

@interface VideoEditViewController ()

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    VideoManagerCenter *videoManager = [VideoManagerCenter shareInstance];
    __weak typeof(self) weakSelf = self;
    [videoManager compressionSession:self.videosArray completeHandler:^(NSURL *mergeFileFath) {
        AVPlayer *player = [[AVPlayer alloc] initWithURL:mergeFileFath];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame = weakSelf.view.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [weakSelf.view.layer insertSublayer:playerLayer atIndex:0];
        [player play];
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
