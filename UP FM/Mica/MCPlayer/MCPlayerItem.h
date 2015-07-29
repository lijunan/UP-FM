//
//  MCPlayerItem.h
//  Mica
//
//  Created by hiseh yin on 13-6-4.
//  Copyright (c) 2013年 movivi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MPEG1_LAYER3,
    MPEG4_AAC,
    FLAC
} AudioEncryption;

@class Music;
@class AVPlayerItem;

@interface MCPlayerItem : NSObject
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, assign) NSTimeInterval availableDuration;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) AudioEncryption encryption;

@property (nonatomic, strong) Music  *song;

@end
