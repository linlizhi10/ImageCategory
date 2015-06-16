//
//  UIImage+FKCategory.h
//  扩展image的功能
//
//  Created by linlizhi  on 15/1/30.
//  Copyright (c) 2015年 skunk . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FKCategory)
//对指定的UI控件进行截图
+ (UIImage *)captureView:(UIView *)targetView;

//+(UIImage *)captureScreen;
//定义一个方法用于“挖取”图片的指定区域
- (UIImage *)imageAtRect:(CGRect)rect;

//保持图片纵横缩放，最短边必须匹配targetSize的大小
//可能有一条边的长度回超过targetSize指定的大小
- (UIImage *)imageByScalingAspectToMiniSize:(CGSize)targetSize;

//保持图片纵横缩放，最长边必须匹配targetSize的大小
//可能有一条边的长度回小于targetSize指定的大小
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize;

//不保持图片纵横比缩放
- (UIImage *)imageByscalingToSize:(CGSize)targetSize;

//对图片按弧度执行旋转
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

//对图片按角度执行旋转
- (UIImage *)imageRotatedByDegree:(CGFloat)degree;

- (void)saveToDocuments:(NSString *)fileName;


//改变image某个范围内的颜色
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;



@end
