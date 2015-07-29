//
//  Login.h
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoginInfo : NSObject

@property (nonatomic,strong) NSString *state;   //国家
@property (nonatomic,strong) NSString *phone;    //手机号
@property (nonatomic,assign) NSInteger verifyCode;    //验证码
@property (nonatomic,strong) NSString *icon;    //头像
@property (nonatomic,strong) NSString *nickName;    //昵称
@property (nonatomic,strong) NSString *pwd;    //密码
@property (nonatomic, strong) NSString *sex;    //性别
@property (nonatomic,strong) NSString *age;   //年龄
@property (nonatomic,strong) NSString *constellation;   //星座
@property (nonatomic,strong) NSString *condition;   //个人状况

@property (nonatomic,strong) NSString *province;    //省
@property (nonatomic,strong) NSString *city;    //市
@property (nonatomic,strong) NSString *area;    //区
@property (nonatomic,strong) NSString *address;  //地址
@property (nonatomic,assign) UIImage *iconImage;

@end
