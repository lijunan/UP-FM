//
//  MCResumeDownloadRequestOperation.m
//  iDouKou
//
//  Created by hiseh yin on 14-1-13.
//  Copyright (c) 2014年 vividomedia. All rights reserved.
//

#import "MCResumeDownloadRequestOperation.h"
#import "AFDownloadRequestOperation.h"
#import "CurrentUser.h"
#import "DownloadQueue.h"
#import "DownloadController.h"
#import "UPFMBase.h"
#import "UrlAPI.h"

@implementation MCResumeDownloadRequestOperation

- (void)downloadObject:(DownloadQueue *)element
{
    if ([_operation isExecuting]) {
        return;
    }
    
    __weak MCResumeDownloadRequestOperation *_weekSelf = self;
    
    NSString *targetPath = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@_%d.mp3", [CurrentUser sharedInstance].uId, [element.mediaId intValue]];
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[element.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                   timeoutInterval:3600];
    _operation = [[AFDownloadRequestOperation alloc] initWithRequest:_request
                                                          targetPath:targetPath
                                                        shouldResume:YES];
    
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //发通知
        [_weekSelf postNotification:YES downloadItem:element];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"download error:%@", error);
        //发通知
        [_weekSelf postNotification:NO downloadItem:element];
    }];
    
    [_operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
//        NSLog(@"%lld / %lld", totalBytesReadForFile, totalBytesExpectedToReadForFile);

        element.totalBytesRead = [NSNumber numberWithLongLong:totalBytesReadForFile];
        element.totalBytesExpectedToRead = [NSNumber numberWithLongLong:totalBytesExpectedToReadForFile];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:MCResumeDownloadDidDownloadingNotification
                                                            object:element];
    }];
    [_operation start];
    
    [self downloadImage:element];
    
    [[DownloadController sharedInstance] saveDownloadQueue:element];
    //歌曲信息

//    NSString *url=[UrlAPI getSubjectDetail];
//    
//    NSDictionary *parameters = @{@"subject_id":element.mediaId};
    
//    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
//        NSNumber *code=[responseObj objectForKey:@"code"];
//        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
//            NSDictionary *resultDict=[responseObj objectForKey:@"content"];
//            element.title = [resultDict objectForKey:@"subject_title"];
//            element.icon= [resultDict objectForKey:@"subject_icon"];
//            element.cover= [resultDict objectForKey:@"subject_cover"];
//            element.fileUrl= [resultDict objectForKey:@"subject_url"];
//            element.introduction= [resultDict objectForKey:@""];
//            element.= [resultDict objectForKey:@""];
//            
//            
//            /*
//             
//             @dynamic notice;
//             @dynamic date;
//             @dynamic format;
//             @dynamic timeLength;
//             @dynamic albumId;
//             @dynamic index;
//             @dynamic sample;
//             @dynamic bit;
//             @dynamic bitrate;
//             @dynamic playSum;
//             @dynamic downloadSum;
//             @dynamic commentsSum;
//             @dynamic shareSum;
//             @dynamic goodSum;
//             @dynamic timePlay;
//             @dynamic createDate;
//             @dynamic currentUserId;
//             */
//
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)pause
{
    [_operation pause];
}

- (void)resume
{
    [_operation resume];
}

- (BOOL)isDownloading
{
    return [_operation isExecuting];
}

- (void)postNotification:(BOOL)state downloadItem:(DownloadQueue *)downloadItem
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (state) {
            //NSLog(@"mediaId is %d", [downloadItem.mediaId intValue]);
            [[NSNotificationCenter defaultCenter] postNotificationName:MCResumeDownloadDidDownloadSuccessNotification
                                                                object:downloadItem];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:MCResumeDownloadDidDownloadErrorNotification
                                                                object:downloadItem];
        }
    });
}

- (void)downloadImage:(DownloadQueue *)element
{
    NSString *targetPath = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/icon_%d.png", [element.mediaId intValue]];
    
    _imageURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[element.icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:3600];
    _imageDownloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:_imageURLRequest];
    _imageDownloadOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [_imageDownloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIImagePNGRepresentation((UIImage *)responseObject) writeToFile:targetPath atomically:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [_imageDownloadOperation start];
}


@end
