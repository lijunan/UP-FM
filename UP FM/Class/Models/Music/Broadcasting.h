//
//  Broadcasting.h
//  UP FM
//
//  Created by liubin on 15/3/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Album.h"

@interface Broadcasting : Album

@property(nonatomic,assign) BOOL open;
@property(nonatomic,retain) NSArray *column;


+ (Broadcasting *)sharedInstance;



-(void)save;

-(void)clear;


@end
