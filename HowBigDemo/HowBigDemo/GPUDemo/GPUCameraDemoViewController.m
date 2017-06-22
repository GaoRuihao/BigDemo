//
//  GPUCameraDemoViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/15.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "GPUCameraDemoViewController.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoEditViewController.h"

@interface GPUCameraDemoViewController ()

@property(nonatomic, strong)GPUImageVideoCamera *videoCamera;
@property(nonatomic, strong)GPUImageFilter *filter;
@property(nonatomic, strong)NSURL *movieURL;
@property(nonatomic, strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic, strong)GPUImageView *filterView;

@property(nonatomic, strong)NSMutableArray *fileURLArrays;

@end

@implementation GPUCameraDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetInputPriority cameraPosition:AVCaptureDevicePositionBack];
    //输出方向为竖屏
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //滤镜
    self.filter = [[GPUImageFilter alloc] init];
    //显示view
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.filterView];
    //组合
    [self.videoCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    
    //相机开始运行
    [self.videoCamera startCameraCapture];
    
    [self resetVideoWrite];
    
    [self setupViews];
    self.fileURLArrays = [NSMutableArray array];
    
    //延迟2秒开始
//    [self performSelector:@selector(starWrite) withObject:nil afterDelay:2];
//    //延迟12秒结束
//    [self performSelector:@selector(stopWrite) withObject:nil afterDelay:12];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupViews {
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake((self.view.width - 60) / 2, self.view.height - 100, 60, 60);
    cameraBtn.backgroundColor = [UIColor lightGrayColor];
    [cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterView addSubview:cameraBtn];
    
    UIButton *changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeCameraBtn.frame = CGRectMake(cameraBtn.maxX + 30, self.view.height - 100, 60, 60);
    [changeCameraBtn setImage:[UIImage imageNamed:@"story_publish_icon_cam_turn"] forState:UIControlStateNormal];
    [changeCameraBtn addTarget:self action:@selector(turnCameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterView addSubview:changeCameraBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(changeCameraBtn.maxX + 10, self.view.height - 100, 60, 60);
    [nextBtn setImage:[UIImage imageNamed:@"story_publish_icon_cam_turn"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterView addSubview:nextBtn];
}



- (void)turnCameraBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform = CGAffineTransformRotate(sender.transform, M_PI);
    } completion:^(BOOL finished) {
        [self.videoCamera rotateCamera];
    }];
}

- (void)cameraBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.movieWriter startRecording];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
           // self.videoCamera.audioEncodingTarget = nil;
            
            __weak typeof(self) weakSelf = self;
            [self.movieWriter finishRecordingWithCompletionHandler:^{
                [weakSelf.filter removeTarget:weakSelf.movieWriter];
                [weakSelf resetVideoWrite];
            }];
            
            
            NSLog(@"视频录制完毕");
            return;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.movieURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:self.movieURL completionBlock:^(NSURL *assetURL, NSError *error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (error) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         } else {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         }
                     });
                 }];
            }
        });
    }
}

- (void)nextBtnAction:(UIButton *)sender {
    VideoEditViewController *editVC = [[VideoEditViewController alloc] init];
    editVC.videosArray = self.fileURLArrays;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)resetVideoWrite {
    if (self.movieURL) {
        [self.fileURLArrays addObject:self.movieURL];
    }
    //设置写入地址
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/LiveMovied-%d.m4v", self.fileURLArrays.count]];
    self.movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(self.view.bounds.size.width + 1, self.view.bounds.size.height + 1)];
    
    //设置声音
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    //设置为liveVideo
    self.movieWriter.encodingLiveVideo = YES;
    [self.filter addTarget:self.movieWriter];
    
    
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
