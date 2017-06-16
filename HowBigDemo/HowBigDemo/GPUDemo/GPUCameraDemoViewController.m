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

@interface GPUCameraDemoViewController ()

@property(nonatomic, strong)GPUImageVideoCamera *videoCamera;
@property(nonatomic, strong)GPUImageFilter *filter;
@property(nonatomic, strong)NSURL *movieURL;
@property(nonatomic, strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic, strong)GPUImageView *filterView;


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
    self.filter = [[GPUImageSepiaFilter alloc] init];
    //显示view
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.filterView];
    //组合
    [self.videoCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    
    //相机开始运行
    [self.videoCamera startCameraCapture];
    
    //设置写入地址
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/LiveMovied.m4v"];
    self.movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:self.view.bounds.size];
    //设置为liveVideo
    self.movieWriter.encodingLiveVideo = YES;
    [self.filter addTarget:self.movieWriter];
    //设置声音
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    
    [self setupViews];
    
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
            self.videoCamera.audioEncodingTarget = nil;
            [self.filter removeTarget:self.movieWriter];
            [self.movieWriter finishRecording];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
