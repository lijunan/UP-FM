//
//  DownloadController.m
//  UP FM
//
//  Created by liubin on 15/2/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "DownloadController.h"
#import "CurrentUser.h"
#import "Music.h"
#import "DownloadedList.h"
#import "DownloadQueue.h"
#import "AppDelegate.h"
#import "Album.h"


@implementation DownloadController

+ (DownloadController *)sharedInstance
{
    static dispatch_once_t onceToken;
    static DownloadController *download;
    dispatch_once(&onceToken, ^{
        download = [[self alloc] init];
    });
    return download;
}

- (id)init
{
    if (self = [super init]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
        _downloadedListEntity = [NSEntityDescription entityForName:@"DownloadedList" inManagedObjectContext:_managedObjectContext];
        _downloadQueueEntity = [NSEntityDescription entityForName:@"DownloadQueue" inManagedObjectContext:_managedObjectContext];
        
        _operation = [[MCResumeDownloadRequestOperation alloc] init];
        _currentUser = [CurrentUser sharedInstance];
        _download_queue = dispatch_queue_create("http://120.24.231.13:7090/ra", DISPATCH_QUEUE_SERIAL);
        
        
        [self initNotificationReciever];
    }
    return self;
}

- (DownloadState)downloadState:(Music *)song
{
    
    if (([MCFile isExit:[LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@_%d.mp3", _currentUser.uId, [song.mediaId intValue]]]) && ([self songCountOfDownloaded:song] > 0)) {
        
        return Downloaded;
    } else if (_currentDownladingElement && [song.mediaId integerValue] == [_currentDownladingElement.mediaId integerValue]) {
        
        return Downloading;
    } else if ([self songCountOfQueue:song] > 0) {
        
        return InQueue;
    }
    
    return NotInQueue;
}

#pragma mark - core data operation
#pragma mark  downloaded list
- (void)createNewDownloaded:(DownloadQueue *)queueElement
{
    {
        //删除已下载列表
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [queueElement.mediaId intValue], _currentUser.uId];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:_downloadedListEntity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                     error:&error] mutableCopy];
        for (DownloadedList *downloadedList in resultArray) {
            [_managedObjectContext deleteObject:downloadedList];
                        [_managedObjectContext save:&error];
                        if (error) {
            #ifdef IDOUKOU_DEBUG
                            NSLog(@"error is\n%@", error);
            #endif
                        }
        }
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    DownloadedList *downloadedElement = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadedList"
                                                                      inManagedObjectContext:_managedObjectContext];

    downloadedElement.mediaId=queueElement.mediaId;
    downloadedElement.title=queueElement.title;
    downloadedElement.iconUrl=queueElement.icon;
    
    downloadedElement.icon=[NSString stringWithFormat:@"icon_%d.png",[queueElement.mediaId intValue]];
    downloadedElement.coverUrl=queueElement.cover;
    downloadedElement.cover=queueElement.cover;
    downloadedElement.fileURL=[NSString stringWithFormat:@"/%@_%d.mp3",_currentUser.uId, [queueElement.mediaId intValue]];
    downloadedElement.songUrl=queueElement.fileURL;
    downloadedElement.introduction=queueElement.introduction;
    downloadedElement.notice=queueElement.notice;
    downloadedElement.date=queueElement.date;
    downloadedElement.format=queueElement.format;
    downloadedElement.timeLength=queueElement.timeLength;
    downloadedElement.index=queueElement.index;
    downloadedElement.sample=queueElement.sample;
    downloadedElement.bit=queueElement.bit;
    downloadedElement.bitrate=queueElement.bitrate;
    downloadedElement.playSum=queueElement.playSum;
    downloadedElement.commentsSum=queueElement.commentsSum;
    downloadedElement.downloadSum=queueElement.downloadSum;
    downloadedElement.shareSum=queueElement.shareSum;
    downloadedElement.goodSum=queueElement.goodSum;
    downloadedElement.timePlay=queueElement.timePlay;
    downloadedElement.createDate=now;
    
    downloadedElement.albumId=queueElement.albumId;
    downloadedElement.albumTitle=queueElement.albumTitle;
    downloadedElement.albumTag=queueElement.albumTag;
    downloadedElement.albumIcon=queueElement.albumIcon;
    
    downloadedElement.currentUserId=_currentUser.uId;
}

- (NSInteger)songCountOfDownloaded:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue], _currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadedListEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger songCount = [_managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error is\n%@", error);
        return 0;
    }
    return songCount;
}

- (void)deleteDownloadedFile:(Music *)song
{
    //删除文件
    NSString *target = [NSString stringWithFormat:@"%@_%d.mp3",
                        _currentUser.uId,
                        [song.mediaId intValue]];
    
    NSString *path = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@", target];
    [MCFile delete:path];
    
    NSString *targetPath = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/icon_%d.png", [song.mediaId intValue]];
    
    [MCFile delete:targetPath];
    //删除已下载列表
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId integerValue],_currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadedListEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    for (DownloadedList *downloadedList in resultArray) {
        [_managedObjectContext deleteObject:downloadedList];
        [_managedObjectContext save:&error];
        if (error) {
       
            NSLog(@"error is\n%@", error);
    
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCResumeDownloadDidDeleteFileNotification
                                                        object:song];
}

- (DownloadedList *)getDownloadedObject:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue], _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadedListEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (DownloadedList *element in resultArray) {
        return element;
    }
    return nil;
}

- (NSString *)getDownloadedFile:(Music *)song
{
    NSString *target = [NSString stringWithFormat:@"%@_%d.mp3",
                        _currentUser.uId,
                        [song.mediaId intValue]];
    
    NSString *path = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@", target];
    return path;
}

- (NSInteger)getDownloadedFileSize:(Music *)song
{
    NSString *target = [NSString stringWithFormat:@"%@_%d.mp3",
                        _currentUser.uId,
                        [song.mediaId intValue]];
    
    NSString *path = [LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@", target];
    
    NSError *error = nil;
    NSDictionary *fileAttributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {

        NSLog(@"error is\n%@", error);

    }
    return [fileAttributeDict fileSize];
}

- (NSArray *)getDownloadedList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadedListEntity];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error) {

        NSLog(@"error is\n%@", error);

    }
    return resultArray;
}

- (void)updateDownloadedList:(NSArray *)dataSource
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[dataSource count]];
    for (DownloadedList *tempElement in dataSource) {
        
        NSDate   *createDateObj = tempElement.createDate? tempElement.createDate: [[NSDate alloc] init];
        
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempElement.mediaId, @"mediaId",
                                  tempElement.title, @"title",
                                  tempElement.icon, @"icon",
                                  tempElement.cover, @"cover",
                                  tempElement.coverUrl, @"coverUrl",
                                  tempElement.iconUrl, @"iconUrl",
                                  tempElement.fileURL, @"fileURL",
                                  tempElement.songUrl, @"songUrl",
                                  tempElement.introduction, @"introduction",
                                  tempElement.notice, @"notice",
                                  tempElement.date, @"date",
                                  tempElement.format, @"format",
                                  tempElement.timeLength, @"timeLength",
                                  tempElement.index, @"index",
                                  tempElement.sample, @"sample",
                                  tempElement.bit, @"bit",
                                  tempElement.bitrate, @"bitrate",
                                  tempElement.playSum, @"playSum",
                                  tempElement.downloadSum, @"downloadSum",
                                  tempElement.commentsSum, @"commentsSum",
                                  tempElement.shareSum, @"shareSum",
                                  tempElement.goodSum, @"goodSum",
                                  tempElement.timePlay, @"timePlay",
                                  createDateObj, @"createDate",
                                  tempElement.albumId, @"albumId",
                                  tempElement.albumTitle,@"albumTitle",
                                  tempElement.albumTag,@"albumTag",
                                  tempElement.albumIcon,@"albumIcon",
                                  tempElement.currentUserId, @"currentUserId",
                                  nil];
        [tempArray addObject:tempDict];
    }
    
    //删除所有的记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@",_currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadedListEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    for (DownloadedList *downloadedList in resultArray) {
        [_managedObjectContext deleteObject:downloadedList];
    }
    
    if ([_managedObjectContext save:&error]) {
        //插入列表
        for (NSInteger i = [dataSource count] - 1; i >= 0; i --) {
            DownloadedList *downloadedListElement = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadedList"
                                                                                  inManagedObjectContext:_managedObjectContext];
            NSDictionary *element = [tempArray objectAtIndex:i];
            NSLog(@"i:%d",(int)i);
            downloadedListElement.mediaId = [element objectForKey:@"mediaId"];
            downloadedListElement.title = [element objectForKey:@"title"];
            downloadedListElement.icon = [element objectForKey:@"icon"];
            downloadedListElement.cover = [element objectForKey:@"cover"];
            downloadedListElement.coverUrl = [element objectForKey:@"coverUrl"];
            downloadedListElement.iconUrl = [element objectForKey:@"iconUrl"];
            downloadedListElement.fileURL = [element objectForKey:@"fileURL"];
            downloadedListElement.songUrl = [element objectForKey:@"songUrl"];
            downloadedListElement.introduction = [element objectForKey:@"introduction"];
            downloadedListElement.notice = [element objectForKey:@"notice"];
            downloadedListElement.date = [element objectForKey:@"date"];
            downloadedListElement.format = [element objectForKey:@"format"];
            downloadedListElement.timeLength = [element objectForKey:@"timeLength"];
            downloadedListElement.index = [element objectForKey:@"index"];
            downloadedListElement.sample = [element objectForKey:@"sample"];
            downloadedListElement.bit = [element objectForKey:@"bit"];
            downloadedListElement.bitrate = [element objectForKey:@"bitrate"];
            downloadedListElement.playSum = [element objectForKey:@"playSum"];
            downloadedListElement.downloadSum = [element objectForKey:@"downloadSum"];
            downloadedListElement.commentsSum = [element objectForKey:@"commentsSum"];
            downloadedListElement.shareSum = [element objectForKey:@"shareSum"];
            downloadedListElement.goodSum = [element objectForKey:@"goodSum"];
            downloadedListElement.timePlay = [element objectForKey:@"timePlay"];
            downloadedListElement.createDate = [element objectForKey:@"createDate"];
            
            downloadedListElement.albumId = [element objectForKey:@"albumId"];
            downloadedListElement.albumTitle = [element objectForKey:@"albumTitle"];
            downloadedListElement.albumTag = [element objectForKey:@"albumTag"];
            downloadedListElement.albumIcon = [element objectForKey:@"albumIcon"];
            
            downloadedListElement.currentUserId = [element objectForKey:@"currentUserId"];
        }
        error = nil;
        
        if ([_managedObjectContext save:&error]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataDidSaveSucess
                                                                object:nil];
        } else {

            NSLog(@"error is\n%@", error);
        }
    } else {
        NSLog(@"error is\n%@", error);
    }
}


#pragma mark download queue
- (void)download:(Music *)song
{
    //下载队列
    [self resume:song];
}

- (DownloadQueue *)getDownloadingObject:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue], _currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error) {

        NSLog(@"error is\n%@", error);

    }
    
    for (DownloadQueue *downloadQueue in resultArray) {
        return downloadQueue;
    }
    return nil;
}

- (void)addToQueue:(Music *)song
{
    
    switch ([self downloadState:song]) {
        case NotInQueue:
        {
            //插入
            [self createNewQueue:song];
            [SVProgressHUD showSuccessWithStatus:@"添加到下载列表"];
            break;
        }
        case InQueue:
        {
            //已在
            [self deleteQueue:song];
            [self createNewQueue:song];
            [SVProgressHUD showErrorWithStatus:@"已经在下载列表"];
            break;
        }
        case Downloaded:
        {
            //已下载
            [SVProgressHUD showSuccessWithStatus:@"已下载完成，请去本地歌曲查看"];
            break;
        }
        case Downloading:
        {
            //暂停
            break;
        }
        default:
            break;
    }
    [self start];
}

- (NSInteger)songCountOfQueue:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue],_currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger songCount = [_managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error is\n%@", error);
    }
    return songCount;
}

- (void)createNewQueue:(Music *)song
{
    if(!_currentUser){
        _currentUser=[CurrentUser sharedInstance];
    }
    NSDate *now = [[NSDate alloc] init];
    
    DownloadQueue *downloadQueue = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadQueue"
                                                                 inManagedObjectContext:_managedObjectContext];
    
    [downloadQueue setMediaId:song.mediaId];
    [downloadQueue setTitle:song.title];
    [downloadQueue setIcon:song.icon];
    [downloadQueue setCover:song.cover];
    [downloadQueue setFileURL:song.fileURL];
    [downloadQueue setIntroduction:song.introduction];
    [downloadQueue setNotice:song.notice];
    [downloadQueue setDate:song.date];
    [downloadQueue setFormat:song.format];
    [downloadQueue setTimeLength:song.timeLength];
    [downloadQueue setIndex:song.index];
    [downloadQueue setSample:song.sample];
    [downloadQueue setBit:song.bit];
    [downloadQueue setBitrate:song.bitrate];
    [downloadQueue setPlaySum:song.playSum];
    [downloadQueue setCommentsSum:song.commentsSum];
    [downloadQueue setShareSum:song.shareSum];
    [downloadQueue setGoodSum:song.goodSum];
    [downloadQueue setTimePlay:song.timePlay];
    [downloadQueue setCreateDate:now];
    
    [downloadQueue setAlbumId:song.albumId];
    [downloadQueue setAlbumTitle:song.album.title];
    [downloadQueue setAlbumTag:song.album.mediaTag];
    [downloadQueue setAlbumIcon:song.album.icon];
    
    [downloadQueue setCurrentUserId:_currentUser.uId];
    
    downloadQueue.downloadState = [NSNumber numberWithBool:YES];
    
    downloadQueue.totalBytesRead = 0;
    downloadQueue.totalBytesExpectedToRead = 0;
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"error is\n%@", error);
    }
    
}

- (void)updateDownloadQueue:(NSArray *)dataSource
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[dataSource count]];
    for (DownloadQueue *tempElement in dataSource) {
        NSDate   *createDateObj = tempElement.createDate? tempElement.createDate: [[NSDate alloc] init];
        NSNumber *totalBytesReadNum = [tempElement.totalBytesRead integerValue] > 0? tempElement.totalBytesRead: [NSNumber numberWithInteger:0];
        NSNumber *totalBytesExpectedToReadNum = [tempElement.totalBytesExpectedToRead integerValue] > 0? tempElement.totalBytesExpectedToRead: [NSNumber numberWithInteger:0];

        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempElement.mediaId, @"mediaId",
                                  tempElement.title, @"title",
                                  tempElement.icon, @"icon",
                                  tempElement.cover, @"cover",
                                  tempElement.fileURL, @"fileURL",
                                  tempElement.introduction, @"introduction",
                                  tempElement.notice, @"notice",
                                  tempElement.date, @"date",
                                  tempElement.format, @"format",
                                  tempElement.timeLength, @"timeLength",
                                  tempElement.index, @"index",
                                  tempElement.sample, @"sample",
                                  tempElement.bit, @"bit",
                                  tempElement.bitrate, @"bitrate",
                                  tempElement.playSum, @"playSum",
                                  tempElement.downloadSum, @"downloadSum",
                                  tempElement.commentsSum, @"commentsSum",
                                  tempElement.shareSum, @"shareSum",
                                  tempElement.goodSum, @"goodSum",
                                  tempElement.timePlay, @"timePlay",
                                  
                                  tempElement.albumId, @"albumId",
                                  tempElement.albumTitle,@"albumTitle",
                                  tempElement.albumTag,@"albumTag",
                                  tempElement.albumIcon,@"albumIcon",
                                  
                                  tempElement.currentUserId, @"currentUserId",
                                  
                                  tempElement.downloadState, @"downloadState",
                                  totalBytesReadNum, @"totalBytesRead",
                                  totalBytesExpectedToReadNum, @"totalBytesExpectedToRead",
                                  createDateObj, @"createDate",
                                  nil];
        [tempArray addObject:tempDict];
    }
    //删除所有的记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    for (DownloadQueue *downloadQueue in resultArray) {
        [_managedObjectContext deleteObject:downloadQueue];
    }
    if ([_managedObjectContext save:&error]) {
        //插入列表
        for (NSInteger i = [tempArray count] - 1; i >= 0; i --) {
            DownloadQueue *downloadQueueElement = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadQueue"
                                                                                inManagedObjectContext:_managedObjectContext];
            NSDictionary *element = [tempArray objectAtIndex:i];
            NSDate *now = [[NSDate alloc] init];
            
            downloadQueueElement.mediaId = [element objectForKey:@"mediaId"];
            downloadQueueElement.title = [element objectForKey:@"title"];
            downloadQueueElement.icon = [element objectForKey:@"icon"];
            downloadQueueElement.cover = [element objectForKey:@"cover"];
            downloadQueueElement.coverUrl = [element objectForKey:@"coverUrl"];
            downloadQueueElement.iconUrl = [element objectForKey:@"iconUrl"];
            downloadQueueElement.fileURL = [element objectForKey:@"fileURL"];
            downloadQueueElement.songUrl = [element objectForKey:@"songUrl"];
            downloadQueueElement.introduction = [element objectForKey:@"introduction"];
            downloadQueueElement.notice = [element objectForKey:@"notice"];
            downloadQueueElement.date = [element objectForKey:@"date"];
            downloadQueueElement.format = [element objectForKey:@"format"];
            downloadQueueElement.timeLength = [element objectForKey:@"timeLength"];
            downloadQueueElement.index = [element objectForKey:@"index"];
            downloadQueueElement.sample = [element objectForKey:@"sample"];
            downloadQueueElement.bit = [element objectForKey:@"bit"];
            downloadQueueElement.bitrate = [element objectForKey:@"bitrate"];
            downloadQueueElement.playSum = [element objectForKey:@"playSum"];
            downloadQueueElement.downloadSum = [element objectForKey:@"downloadSum"];
            downloadQueueElement.commentsSum = [element objectForKey:@"commentsSum"];
            downloadQueueElement.shareSum = [element objectForKey:@"shareSum"];
            downloadQueueElement.goodSum = [element objectForKey:@"goodSum"];
            downloadQueueElement.timePlay = [element objectForKey:@"timePlay"];
            downloadQueueElement.createDate = now;
            
            downloadQueueElement.albumId = [element objectForKey:@"albumId"];
            downloadQueueElement.albumTitle = [element objectForKey:@"albumTitle"];
            downloadQueueElement.albumTag = [element objectForKey:@"albumTag"];
            downloadQueueElement.albumIcon = [element objectForKey:@"albumIcon"];
            
            downloadQueueElement.currentUserId = [element objectForKey:@"currentUserId"];
            
            downloadQueueElement.downloadState = [element objectForKey:@"downloadState"];
            downloadQueueElement.totalBytesRead = [element objectForKey:@"totalBytesRead"];
            downloadQueueElement.totalBytesExpectedToRead = [element objectForKey:@"totalBytesExpectedToRead"];
            
        }
        error = nil;
        if ([_managedObjectContext save:&error]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataDidSaveSucess
                                                                object:nil];
        } else {

            NSLog(@"error is\n%@", error);

        }
    } else {

        NSLog(@"error is\n%@", error);

    }
}

- (void)deleteQueue:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId integerValue], _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    for (DownloadQueue *downloadQueue in resultArray) {
        [_managedObjectContext deleteObject:downloadQueue];
    }
    [_managedObjectContext save:&error];
    if (error) {
    
        NSLog(@"error is\n%@", error);
    
    }
}

- (NSArray *)getDownloadQueue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error is\n%@", error);
    }
    return resultArray;
}

- (void)start
{
    //下载第0个
    [self checkWifi];
}

#pragma mark - 检查网络
- (void)checkWifi
{
    __weak DownloadController *_weakDownload = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无网络
                ComplaxNotification *complaxNotification = [[ComplaxNotification alloc] init];
                complaxNotification.title = @"无网络链接，请检查您的手机设置";
                complaxNotification.notificationObject = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:OtherComplaxNotification object:complaxNotification];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //wifi
                NSArray *downloadQueueArray = [self getDownloadQueue];
                for (DownloadQueue *element in downloadQueueArray) {
                    if ([element.downloadState boolValue]) {
                        dispatch_sync(_download_queue, ^{
                            [_operation downloadObject:element];
                        });
                        return;
                    }
                }
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //3G
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notOnlyWifi"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"notWifiNotification"]) {
                    UIAlertView *wifiAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"等待Wi-Fi下载，或者您可以去设置关闭“仅在Wi-Fi环境下载”"
                                                                       delegate:_weakDownload
                                                              cancelButtonTitle:@"不再提醒"
                                                              otherButtonTitles:@"去设置", nil];
                    [wifiAlert show];
                } else {
                    NSArray *downloadQueueArray = [self getDownloadQueue];
                    for (DownloadQueue *element in downloadQueueArray) {
                        if ([element.downloadState boolValue]) {
                            dispatch_sync(_download_queue, ^{
                                [_operation downloadObject:element];
                            });
                            return;
                        }
                    }
                }
                break;
            }
            case AFNetworkReachabilityStatusUnknown:
            {
                //other
                ComplaxNotification *complaxNotification = [[ComplaxNotification alloc] init];
                complaxNotification.title = @"无法找到可用的网络链接，请检查您的手机设置";
                complaxNotification.notificationObject = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:OtherComplaxNotification object:complaxNotification];
                break;
            }
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"不再提醒"]) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notWifiNotification"];
        
    } else if ([buttonTitle isEqualToString:@"去设置"]) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        
        //发通知
        NSNotification *boardNotification = [NSNotification notificationWithName:@"SetWifi" object:self];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotification:boardNotification];
    }
}

#pragma mark - 通知中心
- (void)initNotificationReciever
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //下载成功
    [notificationCenter addObserver:self selector:@selector(downloadSuccess:)
                               name:MCResumeDownloadDidDownloadSuccessNotification
                             object:nil];
    
    //下载失败
    [notificationCenter addObserver:self selector:@selector(downloadError:)
                               name:MCResumeDownloadDidDownloadErrorNotification
                             object:nil];
    
    [notificationCenter addObserver:self selector:@selector(downloadProgress:)
                               name:MCResumeDownloadDidDownloadingNotification
                             object:nil];
}

- (void)downloadSuccess:(NSNotification *)notification
{
    _currentDownladingElement = nil;
    //加一个
    DownloadQueue *downloadItem = [notification object];
    
    [self createNewDownloaded:downloadItem];
    
    //减一个
    Music *music = [[Music alloc] init];
    music.mediaId = downloadItem.mediaId;
    [self deleteQueue:music];
    
    //继续下载
    [self start];
}

- (void)downloadError:(NSNotification *)notification
{
    DownloadQueue *downloadItem = [notification object];
    Music *song = [[Music alloc] init];
    song.mediaId = downloadItem.mediaId;
    
    //downloadstate设为暂停
    [self pause:song];
}

- (void)downloadProgress:(NSNotification *)notification
{
    _currentDownladingElement = [notification object];
}

#pragma mark - 操作
- (BOOL)saveDownloadQueue:(DownloadQueue *)queueElement
{
    NSError *error = nil;
    if ([_managedObjectContext save:&error]) {
        return YES;
    } else {
   
        NSLog(@"error is\n%@", error);
   
        return NO;
    }
    return NO;
}
- (void)pause:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue],_currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    DownloadQueue *element = [self getDownloadingObject:song];
    element.downloadState = [NSNumber numberWithBool:NO];
    
        NSError *error = nil;
        [_managedObjectContext save:&error];
        if (error) {
   
            NSLog(@"error is\n%@", error);
    
        }
    
    [_operation pause];
    _currentDownladingElement = nil;
    [self start];
}

- (void)resume:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaId == %d AND currentUserId == %@", [song.mediaId intValue],_currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_downloadQueueEntity];
    [request setPredicate:predicate];
    
    DownloadQueue *element = [self getDownloadingObject:song];
    element.downloadState = [NSNumber numberWithBool:YES];
    
        NSError *error = nil;
        [_managedObjectContext save:&error];
        if (error) {
   
            NSLog(@"error is\n%@", error);
   
        }
    [_operation resume];
    [self start];
}

@end
