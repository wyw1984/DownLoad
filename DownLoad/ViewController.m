//
//  ViewController.m
//  DownLoad
//
//  Created by yanwu wei on 2017/5/10.
//  Copyright © 2017年 Ivan. All rights reserved.
//

#import "ViewController.h"
#import "ZOVideoDownloaderOperation.h"

@interface ViewController ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.downloadQueue = [[NSOperationQueue alloc] init];
    self.downloadQueue.maxConcurrentOperationCount = 2;
    self.downloadQueue.name = @"com.hackemist.ZOVideoDownloader";
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    sessionConfig.timeoutIntervalForRequest = 15;
    self.session  = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:self
                                                     delegateQueue:nil];

    
//    {
//        NSURL *url = [NSURL URLWithString:@"http://record2.a8.com/mp4/1472913426203263.mp4"];
//        [self downloadWithURL:url];
//    }
    {
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        [self downloadWithURL:url];
    }
    
//    {
//        NSURL *url = [NSURL URLWithString:@"http://record2.a8.com/mp4/1472911906988120.mp4"];
//        [self downloadWithURL:url];
//    }
//    
//    {
//        NSURL *url = [NSURL URLWithString:@"http://record2.a8.com/mp4/1472915496161518.mp4"];
//        [self downloadWithURL:url];
//    }
//    
//    {
//        NSURL *url = [NSURL URLWithString:@"http://record2.a8.com/mp4/1472913211613274.mp4"];
//        [self downloadWithURL:url];
//    }
}


- (id)downloadWithURL:(NSURL *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    request.HTTPShouldUsePipelining = YES;
    
    ZOVideoDownloaderOperation *operation = [[ZOVideoDownloaderOperation alloc] initWithRequest:request
                                                    inSession:self.session];
    
    
    

    [self.downloadQueue addOperation:operation];
    return operation;
}


- (ZOVideoDownloaderOperation *)operationWithTask:(NSURLSessionTask *)task {
    ZOVideoDownloaderOperation *returnOperation = nil;
    for (ZOVideoDownloaderOperation *operation in self.downloadQueue.operations) {
        if (operation.dataTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}

#pragma mark NSURLSessionDataDelegate


#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    ZOVideoDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    // Identify the operation that runs this task and pass it the delegate method
    ZOVideoDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    ZOVideoDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    ZOVideoDownloaderOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
