//
//  User.h
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Person.h"


@interface User : Person

//相关信息
@property (nonatomic,assign) NSMutableArray *subscriptionList;  //订阅列表
@property (nonatomic,assign) NSMutableArray *downloadList;  //下载列表

-(User *)initUserByDictionary:(NSDictionary *)dict;

-(User *)getUserById:(NSNumber *)userId;

@end
