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
#import <GPUImage/GPUImage.h>
#import "FilterArray.h"

@interface VideoEditViewController ()

@property(nonatomic, strong)AVPlayer *player;
@property(nonatomic, strong)UIButton *playBtn;

@property(nonatomic, strong)NSURL *videoUrl;

@property(nonatomic, strong)GPUImageOutput<GPUImageInput> * pixellateFilter;
@property(nonatomic, strong)GPUImageMovie *movieFile;
@property(nonatomic, strong)GPUImageView *filterView;//预览层 view

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(filterBegin_click)];
    
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.filterView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"btn_play_bg_a"] forState:UIControlStateNormal];
    self.playBtn.frame = CGRectMake(0, 0, 100, 100);
    self.playBtn.center = self.view.center;
    self.playBtn.hidden = YES;
    [self.view addSubview:self.playBtn];
    
    UITapGestureRecognizer *playGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playGesture:)];
    [self.filterView addGestureRecognizer:playGesture];
    
    VideoManagerCenter *videoManager = [VideoManagerCenter shareInstance];
    if (videoManager.hasCombined) {
        self.videoUrl = videoManager.mergeFilePath;
        [self showVideoWith:videoManager.mergeFilePath];
    } else {
        __weak typeof(self) weakSelf = self;
        [videoManager compressionSession:self.videosArray completeHandler:^(NSURL *mergeFileFath) {
            self.videoUrl = mergeFileFath;
            [weakSelf showVideoWith:mergeFileFath];
        }];
    }
    
    for (int i = 0; i < 5; i ++) {
        UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        filterBtn.frame = CGRectMake(10 + 100 * i, self.view.height - 100, 90, 90);
        [filterBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Effects%d",i+1]] forState:UIControlStateNormal];
        filterBtn.tag = 1000 + i;
        [filterBtn addTarget:self action:@selector(chooseFilter:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterView addSubview:filterBtn];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showVideoWith:(NSURL *)videourl {
    [self.movieFile cancelProcessing];
    
    AVPlayerItem *item  = [[AVPlayerItem alloc] initWithURL:videourl];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    self.movieFile = [[GPUImageMovie alloc] initWithPlayerItem:item];
    if (self.pixellateFilter) {
        [self.movieFile addTarget:self.pixellateFilter];
        [self.pixellateFilter addTarget:self.filterView];
    } else {
        [self.movieFile addTarget:self.filterView];
    }
    self.movieFile.shouldRepeat = YES;
    self.movieFile
    .runBenchmark = YES;
    self.movieFile.audioEncodingTarget = [[GPUImageMovieWriter alloc] initWithMovieURL:self.videoUrl size:CGSizeMake(self.view.bounds.size.width + 1, self.view.bounds.size.height + 1)];
    [self.movieFile startProcessing];
    [self.player play];
    
}

- (void)chooseFilter:(UIButton *)sender {
    NSArray *array = [FilterArray creatFilterArray];
    self.pixellateFilter = (GPUImageOutput<GPUImageInput> *)[array[sender.tag - 1000] objectForKey:@"filter"];
    [self.movieFile cancelProcessing];
    [self.movieFile removeAllTargets];
    self.movieFile = [[GPUImageMovie alloc] initWithURL:self.videoUrl];
    self.movieFile.shouldRepeat = YES;
    self.movieFile.audioEncodingTarget = [[GPUImageMovieWriter alloc] initWithMovieURL:self.videoUrl size:CGSizeMake(self.view.bounds.size.width + 1, self.view.bounds.size.height + 1)];
    
    [self.movieFile addTarget:self.pixellateFilter];
    [self.pixellateFilter addTarget:self.filterView];
    [self.movieFile startProcessing];
    
}

- (void)setupPlayerWithPath:(NSURL *)filePath {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    [self.player play];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - Notification
- (void)playerDidPlayToEndTime:(NSNotification *)notify {
    [self.movieFile.playerItem seekToTime:kCMTimeZero];
    [self.movieFile startProcessing];
}

#pragma mark - Gesture
- (void)playGesture:(id)sender {
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self.movieFile endProcessing];
        self.playBtn.hidden = NO;
    } else {
        [self.movieFile startProcessing];
        self.playBtn.hidden = YES;
    }
}

#pragma mark 开始合成视频
-(void)filterBegin_click {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *fileName = [@"Documents/" stringByAppendingFormat:@"Movie%d.m4v",(int)[[NSDate date] timeIntervalSince1970]];
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        AVURLAsset * asset = [AVURLAsset URLAssetWithURL:_videoUrl options:nil];
        CGSize videoSize2 = asset.naturalSize;
        NSLog(@"%f    %f",videoSize2.width,videoSize2.height);
        
        GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:videoSize2];
        [self.pixellateFilter addTarget:movieWriter];
        
        movieWriter.shouldPassthroughAudio = YES;
        self.movieFile.audioEncodingTarget = movieWriter;
        [self.movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
        [movieWriter startRecording];
        
        __weak typeof(self) weakSelf = self;
        __weak GPUImageOutput<GPUImageInput> * weakpixellateFilter = self.pixellateFilter;
        __weak GPUImageMovieWriter * weakmovieWriter = movieWriter;
        [movieWriter setCompletionBlock:^{
            NSLog(@"视频合成结束");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"处理结束");                
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
                [alertview show];
            });
            [weakpixellateFilter removeTarget:weakmovieWriter];
            [weakmovieWriter finishRecording];
        }];
        
        [movieWriter setFailureBlock: ^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    });
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
