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

typedef NS_ENUM(NSInteger, CameraManagerFlashMode) {
    CameraManagerFlashModeAuto, /**<自动*/
    
    CameraManagerFlashModeOff, /**<关闭*/
    
    CameraManagerFlashModeOn /**<打开*/
};

@interface GPUCameraDemoViewController ()<CAAnimationDelegate>

@property(nonatomic, strong)GPUImageVideoCamera *videoCamera;       //GPU相机
@property(nonatomic, strong)GPUImageFilter *filter;     // 滤镜
@property(nonatomic, strong)NSURL *movieURL;
@property(nonatomic, strong)GPUImageMovieWriter *movieWriter;   // 沙盒输出
@property(nonatomic, strong)GPUImageView *filterView;       //UI界面

@property(nonatomic, strong)CALayer *focusLayer;        //聚焦层

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
    [self setfocusImage:[UIImage imageNamed:@"camera_focus_bg"]];
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

//设置聚焦图片
- (void)setfocusImage:(UIImage *)focusImage {
    if (!focusImage) return;
    
    if (!_focusLayer) {
        //增加tap手势，用于聚焦及曝光
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
        [self.filterView addGestureRecognizer:tap];
        //增加pinch手势，用于调整焦距
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(focusDisdance:)];
//        [self.filterView addGestureRecognizer:pinch];
//        pinch.delegate = self;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [self.filterView.layer addSublayer:layer];
    _focusLayer = layer;
    
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

//对焦方法
- (void)focus:(UITapGestureRecognizer *)tap {
    self.filterView.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    // CGContextRef *touchContext = UIGraphicsGetCurrentContext();
    [self layerAnimationWithPoint:touchPoint];
    /**
     *下面是照相机焦点坐标轴和屏幕坐标轴的映射问题，这个坑困惑了我好久，花了各种方案来解决这个问题，以下是最简单的解决方案也是最准确的坐标转换方式
     */
    if(self.videoCamera.cameraPosition == AVCaptureDevicePositionBack){
        touchPoint = CGPointMake( touchPoint.y /tap.view.bounds.size.height ,1-touchPoint.x/tap.view.bounds.size.width);
    }
    else
        touchPoint = CGPointMake(touchPoint.y /tap.view.bounds.size.height ,touchPoint.x/tap.view.bounds.size.width);
    /*以下是相机的聚焦和曝光设置，前置不支持聚焦但是可以曝光处理，后置相机两者都支持，下面的方法是通过点击一个点同时设置聚焦和曝光，当然根据需要也可以分开进行处理
     */
    if([self.videoCamera.inputCamera isExposurePointOfInterestSupported] && [self.videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([self.videoCamera.inputCamera lockForConfiguration:&error]) {
            [self.videoCamera.inputCamera setExposurePointOfInterest:touchPoint];
            [self.videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            if ([self.videoCamera.inputCamera isFocusPointOfInterestSupported] && [self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.videoCamera.inputCamera setFocusPointOfInterest:touchPoint];
                [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            [self.videoCamera.inputCamera unlockForConfiguration];
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

//对焦动画
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        ///聚焦点聚焦动画设置
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

//动画的delegate方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //    1秒钟延时
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.0f];
}

//focusLayer回到初始化状态
- (void)focusLayerNormal {
    self.filterView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
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
