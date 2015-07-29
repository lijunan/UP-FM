//
//  Person.h
//  UP FM
//
//  Created by liubin on 15/1/31.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

//用户信息
@property (nonatomic, strong) NSString *uId;    //id
@property (nonatomic, strong) NSString *uName;      //用户名
@property (nonatomic, strong) NSString *auth;   //用户验证
@property (nonatomic, strong) NSString *password;   //密码
@property (nonatomic, strong) NSString *nickName;   //昵称
@property (nonatomic, strong) NSString *sex;    //性别
@property (nonatomic,strong) NSString *age;   //年龄
@property (nonatomic,strong) NSString *tel;   //电话
@property (nonatomic,strong) NSString *introduction;    //签名
@property (nonatomic, strong) NSString *icon;       //头像
@property (nonatomic,strong) NSString *constellation;   //星座
@property (nonatomic, strong) NSString *imgUrl;    //大图
@property (nonatomic,strong) NSString *condition;   //个人状况
@property (nonatomic,assign) NSNumber *member;  //会员状态


@property (nonatomic,strong) NSString *state;   //国家
@property (nonatomic,strong) NSString *province;    //省
@property (nonatomic,strong) NSString *city;    //市
@property (nonatomic,strong) NSString *area;    //区
@property (nonatomic,strong) NSString *address;  //地址
@property (nonatomic, strong) NSNumber  *registerDate;    //注册日期


//交互信息
@property (nonatomic, assign) NSNumber *friendSum;  //好友数量
@property (nonatomic, assign) NSMutableArray *friendList; //好友列表
@property (nonatomic, assign) NSNumber *fansSum;    //粉丝数量
@property (nonatomic, assign) NSMutableArray *fansList;   //粉丝列表


//登录信息
@property (nonatomic, assign) NSString *ip;    //IP
@property (nonatomic, assign) NSString *lastIp;    //上次IP
@property (nonatomic, assign) NSNumber  *loginTime;   //登录时间
@property (nonatomic, assign) NSNumber  *lastLoginTime;   //上次登录时间
@property (nonatomic,strong) NSNumber *longitude;   //经度
@property (nonatomic,strong) NSNumber *latitude;    //纬度
@property (nonatomic,strong) NSNumber *lastLongitude;   //经度
@property (nonatomic,strong) NSNumber *lastLatitude;    //纬度


//用户类型

@property (nonatomic,assign) NSString *PersonType;  //用户类型


@end
