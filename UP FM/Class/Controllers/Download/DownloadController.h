//
//  DownloadController.h
//  UP FM
//
//  Created by liubin on 15/2/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Mica.h"

typedef enum {
    NotInQueue = 0,
    InQueue,
    Downloaded,
    Downloading
} DownloadState;

@class Music;
@class DownloadedList;
@class DownloadQueue;
@class CurrentUser;
@class Album;
@interface DownloadController : NSObject<UIAlertViewDelegate>{
@private
    NSManagedObjectContext  *_managedObjectContext;
    NSEntityDescription     *_downloadedListEntity;
    NSEntityDescription     *_downloadQueueEntity;
    
    MCResumeDownloadRequestOperation *_operation;
    CurrentUser             *_currentUser;
    
    DownloadQueue           *_currentDownladingElement;
    
    dispatch_queue_t        _download_queue;
}

+ (DownloadController *)sharedInstance;

- (void)addToQueue:(Music *)song;
- (DownloadQueue *)getDownloadingObject:(Music *)song;
- (DownloadState)downloadState:(Music *)song;

- (DownloadedList *)getDownloadedObject:(Music *)song;
- (NSString *)getDownloadedFile:(Music *)song;
- (NSInteger)getDownloadedFileSize:(Music *)song;
- (NSArray *)getDownloadedList;
- (NSArray *)getDownloadQueue;
- (BOOL)saveDownloadQueue:(DownloadQueue *)queueElement;

- (void)updateDownloadedList:(NSArray *)dataSource;
- (void)updateDownloadQueue:(NSArray *)dataSource;

- (void)download:(Music *)song;
- (void)start;
- (void)pause:(Music *)song;
- (void)resume:(Music *)song;
- (void)deleteDownloadedFile:(Music *)song;

- (void)deleteQueue:(Music *)song;


@end
