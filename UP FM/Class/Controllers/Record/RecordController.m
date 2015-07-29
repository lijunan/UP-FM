//
//  RecordController.m
//  UP FM
//
//  Created by liubin on 15/3/6.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RecordController.h"
#import "AppDelegate.h"

@implementation RecordController

+(RecordController *)sharedInstance{
    
    static dispatch_once_t onceToken;
    static RecordController *recordCotroller;
    
    dispatch_once(&onceToken, ^{
        recordCotroller=[[self alloc] init];
    });
    return recordCotroller;
    
}

-(id)init{
    if(self = [super init]){
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext=appDelegate.managedObjectContext;
        _entity=[NSEntityDescription entityForName:@"Record" inManagedObjectContext:_managedObjectContext];
        _currentUser = [CurrentUser sharedInstance];
    }
    return self;
}


-(void)saveRecord:(Record *)record{
    
}
-(void)deleteRecord:(Record *)record{
    
}
-(NSArray *)getRecordListWithStatus:(NSNumber *)status{
    NSArray *recordList=[[NSArray alloc] init];
    
    return recordList;
}

@end
