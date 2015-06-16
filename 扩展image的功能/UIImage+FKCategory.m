//
//  UIImage+FKCategory.m
//  扩展image的功能
//
//  Created by linlizhi  on 15/1/30.
//  Copyright (c) 2015年 skunk . All rights reserved.
//

#import "UIImage+FKCategory.h"
#import <QuartzCore/QuartzCore.h>
//extern CGImageRef UIGetScreenImage();
@implementation UIImage (FKCategory)
//+(UIImage *)captureScreen
//{
//    extern CGImageRef UIGetScreenImage();//需要先声明该外部函数
//    CGImageRef screen=UIGetScreenImage();//调用UIGetScreenImage（）函数执行截屏
//    //获取截屏得到的图片
//    UIImage *newImage=[UIImage imageWithCGImage:screen];
//    return  newImage;
//}
+ (UIImage *)captureView:(UIView *)targetView
{
    CGRect rect=targetView.frame;//获取目标UIView所在的区域
    UIGraphicsBeginImageContext(rect.size);//开始绘图
    CGContextRef context=UIGraphicsGetCurrentContext();
    //调用CALayer的方法将当前控件绘制到绘图Context中
    [targetView.layer renderInContext:context];
    //获取该绘图Context中的图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)imageAtRect:(CGRect)rect
{
    //获取该UIImage图片对应的CGImageRef对象
    CGImageRef srcImage=[self CGImage];
    //从srcImage中挖取rect区域
    CGImageRef imageRef=CGImageCreateWithImageInRect(srcImage, rect);
    //将挖取出来的CGImageRef转换为UIImage对象；
    UIImage *subImage=[UIImage imageWithCGImage:imageRef];
    return  subImage;
}
- (UIImage *)imageByScalingAspectToMiniSize:(CGSize)targetSize
{
    //获取原图片的宽和高
    CGSize imageSize=self.size;
    CGFloat width=imageSize.width;
    CGFloat height=imageSize.height;
    //获取图片缩放目标大小的宽和高
    CGFloat targetWidth=targetSize.width;
    CGFloat targetHeight=targetSize.height;
    //定义图片缩放后的宽度
    CGFloat scaleWidth=targetWidth;
    //定义图片缩放后的高度
    CGFloat scaleHeight=targetHeight;
    
    CGPoint anchorPoint=CGPointZero;
    //如果原图片的大小和缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        //x上的缩放因子
        CGFloat xFactor=targetWidth/width;
        //y方向上的缩放因子
        CGFloat yFactor=targetHeight/height;
        //定义缩放因子为两个因子中较大的一个
        CGFloat scaleFactor=xFactor>yFactor?xFactor:yFactor;
        //根据缩放因子计算图片缩放后的宽度和高度
        scaleWidth=width*scaleFactor;
        scaleHeight=height*scaleFactor;
        //如果横向上的缩放因子大于纵向上的缩放因子，那么图片在纵向上需要裁减
        if (xFactor>yFactor) {
            anchorPoint.y=(targetHeight-scaleHeight)*0.5;
        }
        //如果横向上的缩放因子小于纵向上的缩放因子，那么图片在横向上需要裁减
        else if (xFactor<yFactor)
        {
            anchorPoint.x=(targetWidth-scaleWidth)*0.5;
        }
        
    }
    //开始绘图
    UIGraphicsBeginImageContext(targetSize);
    //定义图片缩放后的区域
    CGRect anchorRect=CGRectZero;
    anchorRect.origin=anchorPoint;
    anchorRect.size.width=scaleWidth;
    anchorRect.size.height=scaleHeight;
    //将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    //获取绘制后生成的新图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;//返回新图片；
    
}
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize
{

    CGSize imageSize=self.size;
    CGFloat width=imageSize.width;
    
    CGFloat height=imageSize.height;
    //获取图片缩放目标大小的宽和高
    CGFloat targetWidth=targetSize.width;
    CGFloat targetHeight=targetSize.height;
    //定义图片缩放后的实际宽度和高度
    CGFloat scaleWidth=targetWidth;
    CGFloat scaleHeight=targetHeight;
    CGPoint anchorPoint=CGPointZero;
    //如果原图片的大小和缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat xFactor=targetWidth/width;
        CGFloat yFactor=targetHeight/height;
        //定义缩放因子为两个中较小的一个
        CGFloat scaleFactor=xFactor<yFactor?xFactor:yFactor;
        //根据缩放因子计算图片缩放后的宽度和高度
        scaleWidth=width*scaleFactor;
        scaleHeight=height*scaleFactor;
        //如果横向的缩放因子小于纵向的缩放因子，图片在上边和下边有空白
        //那么图片在纵向上需要下移一段距离，保持图片在中间
        if (xFactor<yFactor) {
            anchorPoint.y=(targetHeight-scaleHeight)*0.5;
        }
        //如果横向的缩放因子小于纵向的缩放因子，图片在左边和右边有空白
        //那么图片在纵向上需要右移一段距离，保持图片在中间
        else if (xFactor>yFactor)
        {
            anchorPoint.x=(targetWidth-scaleWidth)*0.5;
            
        }
        
    }
    //开始绘图
    UIGraphicsBeginImageContext(targetSize);
    //定义图片缩放后的区域
    CGRect anchorRect=CGRectZero;
    anchorRect.origin=anchorPoint;
    anchorRect.size.width=scaleWidth;
    anchorRect.size.height=scaleHeight;
    //将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    //获取绘制后生成的新图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;//返回新图片
}
- (UIImage *)imageByscalingToSize:(CGSize)targetSize
{
    //开始绘图
    UIGraphicsBeginImageContext(targetSize);
    //定义图片缩放后的区域，无需保持纵横比，所以直接缩放
    CGRect anchorRect=CGRectZero;
    anchorRect.origin=CGPointZero;
    anchorRect.size=targetSize;
    [self drawInRect:anchorRect];//将图片本身绘制到auchorRect区域中
    //获取绘制后生成的的新图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;//返回新图片；
}
//图片旋转角度
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    //定义一个执行旋转的CGAffineTransform结构体
    CGAffineTransform t=CGAffineTransformMakeRotation(radians);
    //对图片原始区域进行旋转获取旋转后的区域
    CGRect rotateRect=CGRectApplyAffineTransform(CGRectMake(0, 0, self.size.width, self.size.height), t);
    CGSize rotatedSize=rotateRect.size;//获取图片旋转后的大小
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //指定坐标变换，将坐标中心平移到图片中心
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(ctx, radians);//执行坐标变换，旋转过radians弧度
    CGContextScaleCTM(ctx, 1.0, -1.0);//执行坐标变换，执行缩放；
    CGContextDrawImage(ctx, CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height), self.CGImage);//绘制图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)imageRotatedByDegree:(CGFloat)degree
{
    return [self imageRotatedByRadians:degree *M_PI/180];
}
- (void)saveToDocuments:(NSString *)fileName
{
    NSString *path=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    [UIImagePNGRepresentation(self) writeToFile:path atomically:YES];//保存png图片
    [UIImageJPEGRepresentation(self, 1.0) writeToFile:path atomically:YES];//1.0压缩比例
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    /*
     原因：UIGraphicsBeginImageContext在iOS7+，算法有所变动
     导致这一现象的条件：缩小有透明像素点的位图并重新绘制。
     
     问题描述：在iOS7+，使用UIGraphicsBeginImageContext开启一个基于位图的上下文（默认scalewei1.0），将一张长宽大于设定的画布长宽并且有透明的像素点的图像绘制到画布上，非连续的透明像素点会被丢弃，非透明的像素点会按向量比缩放至指定坐标，最终导致图片糊掉，而iOS7以下版本无此问题，故猜测iOS7绘图算法有所变动。
     */
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    
    CGContextFillRect(context, rect);
    //画布内修改后的image
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}
@end
