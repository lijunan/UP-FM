//
//  Record.h
//  UP FM
//
//  Created by liubin on 15/3/5.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Record : NSManagedObject

@property(nonatomic,retain) NSNumber *mediaId;
@property(nonatomic,retain) NSNumber *bit;
@property(nonatomic,retain) NSNumber *bitrate;
@property(nonatomic,retain) NSString *cover;
@property(nonatomic,retain) NSNumber *date;
@property(nonatomic,retain) NSString *fileURL;
@property(nonatomic,retain) NSString *format;
@property(nonatomic,retain) NSString *icon;
@property(nonatomic,retain) NSNumber *index;
@property(nonatomic,retain) NSDate *insertDate;
@property(nonatomic,retain) NSNumber *sample;
@property(nonatomic,retain) NSNumber *timeLength;
@property(nonatomic,retain) NSString *title;


@property(nonatomic,retain) NSNumber *status;



@end
