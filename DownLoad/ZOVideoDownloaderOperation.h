//
//  ZOVideoDownloaderOperation.h
//  DownLoad
//
//  Created by yanwu wei on 2017/5/10.
//  Copyright © 2017年 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZOVideoDownloaderOperation : NSOperation <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURL *url;
/**
 * The request used by the operation's task.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/**
 * The operation's task
 */
@property (strong, nonatomic, readonly) NSURLSessionTask *dataTask;

- (id)initWithRequest:(NSURLRequest *)request
            inSession:(NSURLSession *)session;
@end
