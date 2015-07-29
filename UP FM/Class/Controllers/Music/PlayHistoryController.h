//
//  PlayHistoryController.h
//  UP FM
//
//  Created by liubin on 15/2/23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UPFMBase.h"

@class Music;
@class Album;
@class CurrentUser;
@interface PlayHistoryController : NSObject{
@private
    NSManagedObjectContext *_managedObjectContext;
    NSEntityDescription *_entity;
    
    CurrentUser         *_currentUser;
}

+ (PlayHistoryController *)sharedInstance;
- (void)playSong:(Music *)song;
- (NSArray *)getHistoryWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize timeType:(TimeType)timeType;
- (void)deleteHistory:(Music *)song;
-(void) setPlayTime:(NSNumber *)musicId playTime:(NSInteger)playTime;
@end
