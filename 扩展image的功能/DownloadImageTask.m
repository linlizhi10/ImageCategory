//
//  DownloadImageTask.m
//  NSOperation异步下载图片
//
//  Created by skunk  on 15/4/28.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import "DownloadImageTask.h"

@implementation DownloadImageTask
@synthesize SKOperationID,SKDownDelegate,SKBuffer,SKRequest,SKConnection;
/**
 *  init method
 *
 *  @param SKImageUrl image url
 *
 *  @return instance object
 */
- (id)initWithUrlString:(NSString *)SKImageUrl
{
    NSLog(@"url is %@",SKImageUrl);
    self = [super init];
    if (self) {
        SKRequest = [NSURLRequest requestWithURL:
                     [NSURL URLWithString:SKImageUrl]];
        SKBuffer = [NSMutableData data];
    }
    return self;
}
- (void)start{
    NSLog(@"DownloadImageTask-start");
    
    if (![self isCancelled]) {
        //pause
        [NSThread sleepForTimeInterval:1];
        //set the delegate for connection
        SKConnection = [NSURLConnection connectionWithRequest:SKRequest delegate:self];
        if (SKConnection != nil) {
            while (!SKIsDone) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
            }
        }
    }
}

- (void)httpConnectionEndWithError
{
    NSLog(@"httpConnectionWithError");
}
/**
 *  dealloc for not arc
 
 - (void)dealloc
 {
 [super dealloc];
 SKBuffer = nil;
 SKConnection = nil;
 SKRequest = nil;
 SKDownDelegate = nil;
 }
 */

#pragma mark NSURLConnection delegate methods
/**
 *  set cache strategy
 *
 *  @param connection     <#connection description#>
 *  @param cachedResponse <#cachedResponse description#>
 *
 *  @return strategy for cache ,nil for no cache
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(httpConnectionEndWithError) withObject:self waitUntilDone:NO];
    [SKBuffer setLength:0];
}

/**
 *  receive responce
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        SKTotalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        NSLog(@"totalLength is %lld",SKTotalLength);
    }
}
/**
 *  receive data
 *
 *  @param connection <#connection description#>
 *  @param data       <#data description#>
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [SKBuffer appendData:data];
    double progressValue = SKTotalLength == 0 ? 0 : ((double)([SKBuffer length])/(double) SKTotalLength);
    /**
     *  update progressValue
     */
    [SKDownDelegate updateDownloadProgress:progressValue withOperation:SKOperationID];
    
}
/**
 *  finish down
 *
 *  @param connection <#connection description#>
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    SKIsDone = YES;
    UIImage *img = [[UIImage alloc] initWithData:SKBuffer];
    [SKDownDelegate imageDownloadFinished:img withOperation:SKOperationID];
}
/**
 *  asynchronous call or synchonous call
 *
 *  @return yes for asynchronous
 */
- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isFinished{
    return SKConnection = nil;
}

@end
