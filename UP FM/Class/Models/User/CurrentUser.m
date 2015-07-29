//
//  CurrentUser.m
//  iDouKou
//
//  Created by hiseh yin on 13-6-8.
//  Copyright (c) 2013年 vividomedia. All rights reserved.
//

#import "CurrentUser.h"

#import "UPFMViewController.h"

@implementation CurrentUser

@synthesize iconImage;


+ (CurrentUser *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CurrentUser *currentUser;
    dispatch_once(&onceToken, ^{
        NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
        if (! currentUser) {
            currentUser = [[self alloc] init];

        }
    });
    return currentUser;
}

- (void)save
{
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:[CurrentUser sharedInstance]];
    [[NSUserDefaults standardUserDefaults] setObject:udObject forKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.uId = [aDecoder decodeObjectForKey:@"uId"];
        self.uName = [aDecoder decodeObjectForKey:@"uName"];
        self.auth=[aDecoder decodeObjectForKey:@"auth"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
       
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.introduction = [aDecoder decodeObjectForKey:@"introduction"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
        self.condition = [aDecoder decodeObjectForKey:@"condition"];
        self.member = [aDecoder decodeObjectForKey:@"member"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
    
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.registerDate = [aDecoder decodeObjectForKey:@"registerDate"];
        
        self.ip = [aDecoder decodeObjectForKey:@"ip"];
        self.lastIp = [aDecoder decodeObjectForKey:@"lastIp"];
        self.loginTime = [aDecoder decodeObjectForKey:@"loginTime"];
        self.lastLoginTime = [aDecoder decodeObjectForKey:@"lastLoginTime"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.lastLongitude = [aDecoder decodeObjectForKey:@"lastLongitude"];
        self.lastLatitude = [aDecoder decodeObjectForKey:@"lastLatitude"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uId forKey:@"uId"];
    [aCoder encodeObject:self.uName forKey:@"uName"];
    [aCoder encodeObject:self.auth forKey:@"auth"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.introduction forKey:@"introduction"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:self.condition forKey:@"condition"];
    [aCoder encodeObject:self.member forKey:@"member"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.registerDate forKey:@"registerDate"];
    [aCoder encodeObject:self.ip forKey:@"ip"];
    [aCoder encodeObject:self.lastIp forKey:@"lastIp"];
    [aCoder encodeObject:self.loginTime forKey:@"loginTime"];
    [aCoder encodeObject:self.lastLoginTime forKey:@"lastLoginTime"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.lastLongitude forKey:@"lastLongitude"];
    [aCoder encodeObject:self.lastLatitude forKey:@"lastLatitude"];
    
}

-(void)update{
    NSArray *sexArr=SEX_ARR;
    NSArray *conditionArr=CONDITION_ARR;
    //注册账号
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    if(self.tel){
        [param setObject:self.tel forKey:@"user_mobile"];
    }
    if(self.nickName){
        [param setObject:self.nickName forKey:@"user_name"];
    }
    if(self.password){
        [param setObject:self.password forKey:@"user_password"];
    }
    if(self.sex){
        [param setObject:[NSNumber numberWithInteger:[sexArr indexOfObject:self.sex]] forKey:@"user_sex"];
    }
    if(self.age){
        [param setObject:self.age forKey:@"user_age"];
    }
    if(self.constellation){
        [param setObject:self.constellation forKey:@"user_constellation"];
    }
    [param setObject:@"ios" forKey:@"user_platform"];
    if(self.condition){
        [param setObject:[NSNumber numberWithInteger:[conditionArr indexOfObject:self.condition]] forKey:@"user_marriage"];
    }
    if(self.city){
        [param setObject:self.city forKey:@"user_city"];
    }
    if([MCSystem getAppVersion]){
        [param setObject:[MCSystem getAppVersion] forKey:@"user_version"];
    }
    if(self.iconImage){
        NSData *uploadData=UIImageJPEGRepresentation((UIImage*)self.iconImage, 0.8);
        [self updateFielUser:param fiel:uploadData];
    }else{
        [self updateUser:param];
    }

}

-(void)updateUser:(NSDictionary *)param{
    NSString *url=[UrlAPI getUserUpdateInfo];
    [UPHTTPTools post:url params:param success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSLog(@"修改成功");
            [self save];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString replaceUnicode:[responseObj objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        }
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }];

}
-(void)updateFielUser:(NSDictionary *)param fiel:(NSData *)fiel{
    
}

-(void)clear{
//    self.uId = nil;
//    self.uName = nil;
//    self.auth=nil;
//    self.tel = nil;
//    self.password = nil;
//    
//    self.nickName = nil;
//    self.sex = nil;
//    self.age = nil;
//    self.introduction = nil;
//    self.icon = nil;
//    self.constellation = nil;
//    self.imgUrl = nil;
//    self.condition = nil;
//    self.member = nil;
//    self.state = nil;
//    self.province = nil;
//    self.auth=nil;
//    
//    self.city = nil;
//    self.area = nil;
//    self.address = nil;
//    self.registerDate = nil;
//    [self save];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
