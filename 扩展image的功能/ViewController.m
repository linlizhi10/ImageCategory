//
//  ViewController.m
//  扩展image的功能
//
//  Created by skunk  on 15/1/30.
//  Copyright (c) 2015年 skunk . All rights reserved.
//

#import "ViewController.h"
#import "UIImage+FKCategory.h"
#import "DownloadImageTask.h"
@interface ViewController ()<DownloadImageDelegate>
{
    NSOperationQueue *_SKImageQueue;
    UIImageView *_iView;
}
@end

@implementation ViewController
UIImage *rawImage;
- (void)viewDidLoad {
    [super viewDidLoad];
//    rawImage=[UIImage imageNamed:@"round"];
//    UIImageView *iv1=[[UIImageView alloc]initWithImage:[rawImage imageRotatedByDegree:30]];
//    iv1.frame=CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:iv1];
//    //获取图片不保持纵横比缩放到130效果
//    UIImageView *iv2=[[UIImageView alloc]initWithImage:[rawImage imageByscalingToSize:CGSizeMake(130, 130)]];
//    iv2.center=CGPointMake(220, 80);
//    [self.view addSubview:iv2];
//    //获取图片纵横比，最长边不超过180；
//    UIImageView *iv3=[[UIImageView alloc]initWithImage:[rawImage imageByScalingAspectToMaxSize:CGSizeMake(180, 180)]];
//    iv3.center=CGPointMake(100, 210);
//    [self.view addSubview:iv3];
//    
//    //挖取图片指定区域的一块
//    UIImageView *iv4=[[UIImageView alloc]initWithImage:[rawImage imageAtRect:CGRectMake(40, 20, 60, 40)]];
//    iv4.center=CGPointMake(240, 210);
//    [self.view addSubview:iv4];
//    //获取图片纵横比，最短边至少180，长边将会被截断
//    UIImageView *iv5=[[UIImageView alloc]initWithImage:[rawImage imageByScalingAspectToMiniSize:CGSizeMake(180, 180)]];
//    iv5.center=CGPointMake(150, 360);
//    [self.view addSubview:iv5];
    _iView = [[UIImageView alloc]init];
    _iView.frame = CGRectMake(50, 50, 200, 200);
    _iView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_iView];
    NSString *imageUrl = @"http://img1.funshion.com/pictures01/246/402/6/2464026.jpg?200_112";
    int index = 1;
    
    DownloadImageTask *task = [[DownloadImageTask alloc]initWithUrlString:imageUrl];
    task.SKDownDelegate = self;
    task.SKOperationID = index++;
    
    _SKImageQueue = [[NSOperationQueue alloc]init];
    [_SKImageQueue addOperation:task];
}
- (void)imageDownloadFinished:(UIImage *)image withOperation:(int)operationID
{
    _iView.image = [image imageAtRect:CGRectMake(0, 0, 100, 100)];
}
- (void)updateDownloadProgress:(double)value withOperation:(int)operationID
{


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
