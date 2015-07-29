//
//  History.h
//  UP FM
//
//  Created by liubin on 15/2/23.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface History : NSManagedObject

@property (nonatomic, retain) NSString *albumTitle;
@property (nonatomic, retain) NSString *albumTag;
@property (nonatomic, retain) NSString *albumIcon;
@property (nonatomic, retain) NSNumber *albumId;
@property (nonatomic, retain) NSDate *insertDate;

@property (nonatomic, retain) NSString *musicTitle;
@property (nonatomic, retain) NSNumber *musicId;
@property (nonatomic, retain) NSNumber *playTime;


@property (nonatomic, retain) NSString *currentUserId;


@end
