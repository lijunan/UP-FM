//
//  MCResumeDownloadRequestOperation.h
//  iDouKou
//
//  Created by hiseh yin on 14-1-13.
//  Copyright (c) 2014年 vividomedia. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@class AFDownloadRequestOperation;
@class DownloadQueue;
@interface MCResumeDownloadRequestOperation : NSObject {
@private
    NSMutableURLRequest *_request;
    AFDownloadRequestOperation  *_operation;
    
    NSMutableURLRequest         *_imageURLRequest;
    AFHTTPRequestOperation      *_imageDownloadOperation;
}

- (void)downloadObject:(DownloadQueue *)element;
- (void)pause;
- (void)resume;
- (BOOL)isDownloading;

@end
