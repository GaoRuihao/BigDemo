//
//  ShowImageViewController.m
//  HowBigDemo
//
//  Created by 高瑞浩 on 2017/6/30.
//  Copyright © 2017年 高瑞浩. All rights reserved.
//

#import "ShowImageViewController.h"
#import "UIImageView+WebCache.h"


@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.width, 400)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://d11.baidupcs.com/file/5bc84044d5b9dc7b11434c423bf9a356?bkt=p3-14005bc84044d5b9dc7b11434c423bf9a35618d7d36d0000015084ab&xcode=def0451b4d5c4eb498024f169862d3b4362ddd505d5ccf950b2977702d3e6764&fid=2348921759-250528-20584700306291&time=1498790051&sign=FDTAXGERLBHS-DCb740ccc5511e5e8fedcff06b081203-4E%2FjqOtRm3tssuyDTty1euLG6Rg%3D&to=d11&size=22054059&sta_dx=22054059&sta_cs=1664&sta_ft=jpg&sta_ct=0&sta_mt=0&fm2=MH,Yangquan,Netizen-anywhere,,guangdong,ct&newver=1&newfm=1&secfm=1&flow_ver=3&pkey=14005bc84044d5b9dc7b11434c423bf9a35618d7d36d0000015084ab&sl=83034191&expires=8h&rt=pr&r=388851374&mlogid=4184922514215950734&vuk=2348921759&vbdid=2502874665&fin=%E9%AB%98%E8%BE%BE%E4%B8%80%E4%BA%BF%E5%83%8F%E7%B4%A0%E7%9A%84%E4%B8%AD%E5%9B%BD%E5%9C%B0%E5%9B%BE+%E6%9E%81%E9%80%82%E5%90%88%E5%81%9A%E6%A1%8C%E9%9D%A2.jpg&fn=%E9%AB%98%E8%BE%BE%E4%B8%80%E4%BA%BF%E5%83%8F%E7%B4%A0%E7%9A%84%E4%B8%AD%E5%9B%BD%E5%9C%B0%E5%9B%BE+%E6%9E%81%E9%80%82%E5%90%88%E5%81%9A%E6%A1%8C%E9%9D%A2.jpg&rtype=1&iv=0&dp-logid=4184922514215950734&dp-callid=0.1.1&hps=1&csl=300&csign=UnhSYvlHppazHVvtyMeNkjz3RBM%3D&so=0&ut=6&uter=4&serv=0&by=themis，https://pan.baidu.com/disk/home"]];
    [self.view addSubview:imageView];
    
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
