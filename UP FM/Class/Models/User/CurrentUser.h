//
//  CurrentUser.h
//  iDouKou
//
//  Created by hiseh yin on 13-6-8.
//  Copyright (c) 2013年 vividomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CurrentUser : User

@property(nonatomic,assign) UIImage *iconImage;

+ (CurrentUser *)sharedInstance;



- (void)save;

-(void)update;

-(void)clear;

@end
