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

@property(nonatomic, strong)AVPlayer *player;

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    VideoManagerCenter *videoManager = [VideoManagerCenter shareInstance];
    if (videoManager.hasCombined) {
        [self setupPlayerWithPath:videoManager.mergeFilePath];
    } else {
        __weak typeof(self) weakSelf = self;
        [videoManager compressionSession:self.videosArray completeHandler:^(NSURL *mergeFileFath) {
            [weakSelf setupPlayerWithPath:mergeFileFath];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupPlayerWithPath:(NSURL *)filePath {
    self.player = [[AVPlayer alloc] initWithURL:filePath];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.repeatCount = 1000;
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    [self.player play];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(0, 0, 100, 100);
    playBtn.center = self.view.center;
    [self.view addSubview:playBtn];
}

#pragma mark - Notification
- (void)playerDidPlayToEndTime:(NSNotification *)notify {
    [self.player seekToTime:kCMTimeZero];
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
