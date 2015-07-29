//
//  RecordController.h
//  UP FM
//
//  Created by liubin on 15/3/6.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UPFMBase.h"
#import "Record.h"

@class CurrentUser;

@interface RecordController : NSObject{
@private
    NSManagedObjectContext *_managedObjectContext;
    NSEntityDescription *_entity;
    
    CurrentUser         *_currentUser;
}

+ (RecordController *)sharedInstance;

-(void)saveRecord:(Record *)record;
-(void)deleteRecord:(Record *)record;
-(NSArray *)getRecordListWithStatus:(NSNumber *)status;



@end
