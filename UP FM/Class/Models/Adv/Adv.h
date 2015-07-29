//
//  Adv.h
//  UP FM
//
//  Created by liubin on 15/2/12.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adv : NSObject

@property (nonatomic, strong) NSNumber *aId;    //id
@property (nonatomic, strong) NSString *title;  //标题
@property (nonatomic, strong) NSString *icon;   //图标
@property (nonatomic, strong) NSNumber *type;   //广告类型 0节目,1节目+主题,2用户
@property (nonatomic, strong) NSNumber *proId;  //节目id
@property (nonatomic, strong) NSNumber *musicId;    //主题id
@property (nonatomic, strong) NSString *userId; //用户id

-(Adv *)initAdvByDictionary:(NSDictionary *)dict;


@end
