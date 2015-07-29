//
//  PlayHistoryController.m
//  UP FM
//
//  Created by liubin on 15/2/23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "PlayHistoryController.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "Music.h"
#import "History.h"

@implementation PlayHistoryController

+(PlayHistoryController *)sharedInstance{
    
    static dispatch_once_t onceToken;
    static PlayHistoryController *playHistoryController;
    
    dispatch_once(&onceToken, ^{
        playHistoryController=[[self alloc] init];
    });
    return playHistoryController;
    
}

-(id)init{
    if(self = [super init]){
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext=appDelegate.managedObjectContext;
        _entity=[NSEntityDescription entityForName:@"History" inManagedObjectContext:_managedObjectContext];
        _currentUser = [CurrentUser sharedInstance];
    }
    return self;
}


- (void)playSong:(Music *)song
{
    //判断是否已在播放列表
    if ([self songCount:song] == 0) {
        //插入
        [self createHistory:song];
    } else {
        //删除\/插入
        [self deleteHistory:song];
        [self createHistory:song];
    }
}

- (NSArray *)getHistoryWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize timeType:(TimeType)timeType{
    unsigned unitFlags = NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitYear | NSCalendarUnitQuarter;
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *comps = [greCalendar components:unitFlags fromDate:[[NSDate alloc] init]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    switch (timeType) {
        case ttWeek:
        {
            NSDateComponents *weekDayComponents = [[NSDateComponents alloc] init];
            [weekDayComponents setYear:[comps year]];
            [weekDayComponents setWeekOfYear:[comps weekOfYear]];
            [weekDayComponents setWeekday:1];
            NSDate *beginWeekDate = [greCalendar dateFromComponents:weekDayComponents];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"insertDate >= %@ AND currentUserId == %@", beginWeekDate, _currentUser.uId];
            [request setPredicate:predicate];
            break;
        }
        case ttMonth:
        {
            NSDate *beginMonthDate = [NSDate dateWithString:[NSString stringWithFormat:@"%d-%d-01",(int)[comps year],(int)[comps month]] dateParttern:MCDatePartternyyyyMMdd];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"insertDate >= %@ AND currentUserId == %@", beginMonthDate, _currentUser.uId];
            [request setPredicate:predicate];
            break;
        }
        case ttQuarter:
        {
            NSDateFormatter *quarterOnly = [[NSDateFormatter alloc]init];
            [quarterOnly setDateFormat:@"Q"];
            NSInteger quarter = [[quarterOnly stringFromDate:[[NSDate alloc] init]] integerValue];
            
            NSDate *beginQuarterDate = [NSDate dateWithString:[NSString stringWithFormat:@"%d-%d-01", (int)[comps year], (int)(quarter - 1) * 3 + 1] dateParttern:MCDatePartternyyyyMMdd];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"insertDate >= %@ AND currentUserId == %@", beginQuarterDate, _currentUser.uId];
            [request setPredicate:predicate];
            break;
            
        }
        case ttYear:
        {
            NSDate *beginYearDate = [NSDate dateWithString:[NSString stringWithFormat:@"%d", (int)[comps year]] dateParttern:MCDatePartternyyyy];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"insertDate >= %@ AND currentUserId == %@", beginYearDate, _currentUser.uId];
            [request setPredicate:predicate];
            break;
        }
        case ttAll:{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
            [request setPredicate:predicate];
            break;
        }
        default:
            break;
    }
    [request setEntity:_entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"insertDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:pageSize];
    [request setFetchOffset:page * pageSize];
    
    NSError *error = nil;
    NSArray *resultArray = [_managedObjectContext executeFetchRequest:request error:&error];
//    NSLog(@"resultArray:%@",resultArray);
    if (error) {

    }
    return resultArray;
}

- (NSInteger)songCount:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"albumId == %d AND currentUserId == %@", [song.albumId intValue], _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger songCount = [_managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }
    return songCount;
}

- (void)createHistory:(Music *)song
{
    if ([self countCurrentUserNum] > 99) {
        [self deleteTheOldest];
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    History *playedHistory = [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:_managedObjectContext];
    [playedHistory setAlbumTitle:song.album.title];
    [playedHistory setAlbumId:song.albumId];
    [playedHistory setAlbumTag:song.album.mediaTag];
    [playedHistory setAlbumIcon:song.album.icon];
    
    [playedHistory setMusicId:song.mediaId];
    [playedHistory setMusicTitle:song.title];
    [playedHistory setPlayTime:song.timePlay];
    [playedHistory setCurrentUserId:_currentUser.uId];
    [playedHistory setInsertDate:now];
    NSError *error = nil;
    
    if ([_managedObjectContext save:&error]) {
        //NSLog(@"保存历史");
    
    }else{
        NSLog(@"error is\n%@", error);
        
    }
    
}

- (void)deleteHistory:(Music *)song
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"albumId == %d AND currentUserId == %@", [song.albumId intValue], _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    for (History *playHistory in resultArray) {
        [_managedObjectContext deleteObject:playHistory];
    }
}

#pragma mark 100条
- (NSInteger)countCurrentUserNum
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger songCount = [_managedObjectContext countForFetchRequest:request error:&error];
    if (error) {

        NSLog(@"error is\n%@", error);

    }
    return songCount;
}

- (void)deleteTheOldest
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUserId == %@", _currentUser.uId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:_entity];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"insertDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *resultArray = [[_managedObjectContext executeFetchRequest:request
                                                                 error:&error] mutableCopy];
    History *playedHistory = [resultArray objectAtIndex:0];
    [_managedObjectContext deleteObject:playedHistory];
    
}
-(void) setPlayTime:(NSNumber *)musicId playTime:(NSInteger)playTime{
    
}
@end
