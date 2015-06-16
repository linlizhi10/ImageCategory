//
//  DownloadImageTask.h
//  NSOperation异步下载图片
//
//  Created by skunk  on 15/4/28.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol DownloadImageDelegate;

@interface DownloadImageTask : NSOperation<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    int SKOperationID;
    long long SKTotalLength;
    BOOL SKIsDone;

}
@property (nonatomic, assign) int SKOperationID;
@property (nonatomic, assign) id<DownloadImageDelegate>SKDownDelegate;
@property (nonatomic, retain) NSMutableData *SKBuffer;
@property (nonatomic, retain) NSURLRequest *SKRequest;
@property (nonatomic, retain) NSURLConnection *SKConnection;

- (id)initWithUrlString:(NSString *)SKImageUrl;



@end
@protocol DownloadImageDelegate
/**
 *  图片下载完成的委托
 */
- (void)imageDownloadFinished:(UIImage *)image withOperation:(int)operationID;
/**
 *  更新图片下载进度条的值
 */
- (void)updateDownloadProgress:(double)value withOperation:(int)operationID;

@end