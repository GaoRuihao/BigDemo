//
//  VideoManagerCenter.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/19.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "VideoManagerCenter.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoManagerCenter()

@property(nonatomic, strong)NSMutableArray *videoPathArray;
@property(nonatomic)BOOL hasCombined;

@end

@implementation VideoManagerCenter

+ (VideoManagerCenter *)shareInstance {
    static dispatch_once_t onceToken;
    static VideoManagerCenter *videoManager;
    dispatch_once(&onceToken, ^{
        videoManager = [[VideoManagerCenter alloc] init];
    });
    return videoManager;
}

- (NSMutableArray *)videoPathArray {
    if (!_videoPathArray) {
        _videoPathArray = [NSMutableArray array];
        BOOL isStore = [self restoreLocalVideo];
    }
    return _videoPathArray;
}

-(AVMutableComposition *)mergeVideostoOnevideo:(NSArray*)array {
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    Float64 tmpDuration =0.0f;
    
    for (NSInteger i=0; i<array.count; i++)
    {
        
        AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:array[i] options:nil];
        
        CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
        
        NSError *error;
        BOOL tbool = [a_compositionVideoTrack insertTimeRange:video_timeRange
                                                      ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                       atTime:CMTimeMakeWithSeconds(tmpDuration, 0)
                                                        error:&error];
        tmpDuration += CMTimeGetSeconds(videoAsset.duration);
        
    }
    return mixComposition;
}

- (void)compressionSession:(NSArray *)fileURLs completeHandler:(void (^)(NSURL *))block {

    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    CMTime lastTime = kCMTimeZero;
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //合成视频轨道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (int i = 0; i < fileURLs.count; i++) {
        AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:fileURLs[i] options:nil];
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        AVAssetTrack *audioAsset = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        
        //一个 audio 轨道
        //AVMutableCompositionTrack provides a convenient interface for insertion, removals, and scaling of track
        //合成音频轨道    进行插入、缩放、删除
        
        //把第一段录制的 audio 插入到 AVMutableCompositionTrack
        if (audioAsset) {
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:audioAsset
                                 atTime:lastTime
                                  error:nil];
        }
        
        
        //把录制的第一段 视频轨道插入到 AVMutableCompositionTrack
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:lastTime
                              error:nil];
        
        // 记录上次时间
        CMTime duration =asset.duration;
        lastTime = CMTimeAdd(lastTime, duration);
    }
    
    //设置写入地址
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/FinalVideo-%d.mp4", arc4random() % 1000]];
    NSURL *mergeFileURL = [NSURL fileURLWithPath:pathToMovie];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果转换成功
            if ( exporter.status == AVAssetExportSessionStatusCompleted)
            {
                if (block) {
                    block(mergeFileURL);
                }
                
            }
        });
    }];
}

- (BOOL)restoreLocalVideo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:docDir];
    for (NSString *fileName in files) {
        NSURL *filePAth = [NSURL URLWithString:[docDir stringByAppendingPathComponent:fileName]];
        if ([fileName containsString:@"FinalVideo"]) {
            self.hasCombined = YES;
            self.mergeFilePath = filePAth;
        }
        [self.videoPathArray addObject:filePAth];
    }
    return files.count > 0;
}

- (BOOL)clearLocalVideos {
    for (NSURL *filePath in self.videoPathArray) {
        BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:filePath.absoluteString error:nil];
        if (!isSuccess) {
            NSLog(@"%@ is delete fail", filePath);
        }
    }
    return YES;
}

@end
