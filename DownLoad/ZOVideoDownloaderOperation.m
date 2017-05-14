//
//  ZOVideoDownloaderOperation.m
//  DownLoad
//
//  Created by yanwu wei on 2017/5/10.
//  Copyright © 2017年 Ivan. All rights reserved.
//

#import "ZOVideoDownloaderOperation.h"

@interface ZOVideoDownloaderOperation ()

@property (strong, nonatomic, readwrite) NSURLSessionTask *dataTask;
@property (strong, nonatomic) NSURLSession *session;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@end

@implementation ZOVideoDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)initWithRequest:(NSURLRequest *)request
            inSession:(NSURLSession *)session
{
    if ((self = [super init])) {
    
        
        _request = [request copy];
        _url = request.URL;
        
        _session = session;
    

    }
    return self;
}

- (void)main {
    @synchronized (self)
    {
        self.dataTask = [_session dataTaskWithRequest:self.request];
    }
    
    [self.dataTask resume];
 
}



#pragma mark NSURLSessionDataDelegate



- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"_url1 = %@",_url);
    
    NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
    NSLog(@"%li",expected);
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"_url2 = %@",_url);
    
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    NSLog(@"_url3 = %@",_url);
    self.finished = YES;
    self.executing = NO;
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"_url4 = %@",_url);
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}
-(void)dealloc
{
    NSLog(@"dealloc");
}
@end
