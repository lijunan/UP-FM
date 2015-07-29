//
//  RegisterDetailedViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "RegisterDetailedViewController.h"
#import "AreaAPI.h"


@implementation RegisterDetailedViewController

@synthesize loginInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initThisData];
    
    /*
     * 导航条设置
     */
    self.title=@"注册";
    
    [self navBackShow];
    //加载导航右侧按钮
//    UIButton *butSkip=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
//    [butSkip addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *butSkipText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
//    butSkipText.text=@"跳过";
//    butSkipText.font=FONT_14;
//    butSkipText.textAlignment=NSTextAlignmentRight;
//    [butSkip addSubview:butSkipText];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butSkip];
    
    sexArr=SEX_ARR;
    conditionArr=CONDITION_ARR;
    
    tableTop=0.0;//NAV_HEIGHT+STATUS_BAR_HEIGHT;
    tableHeight=WIN_HEIGHT-tableTop;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, tableTop, WIN_WIDTH, tableHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = SETTING_HEIGHT;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled=YES;
    
    [self.view addSubview:_tableView];
    
    
}
-(void) viewWillAppear:(BOOL)animated{

    [_tableView  reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"性别";
                    cell.detailTextLabel.text=self.loginInfo.sex;
                    break;
                }
                case 1:{
                    cell.textLabel.text = @"年龄";
                    cell.detailTextLabel.text=self.loginInfo.age;
                    break;
                }
                case 2:{
                    cell.textLabel.text = @"星座";
                    cell.detailTextLabel.text=self.loginInfo.constellation;
                    break;
                }
                case 3:{
                    cell.textLabel.text = @"状况";
                    cell.detailTextLabel.text=self.loginInfo.condition;
                    break;
                }
                case 4:{
                    cell.textLabel.text = @"城市";
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",self.loginInfo.province?self.loginInfo.province:@"",self.loginInfo.city?self.loginInfo.city:@""];
                    break;
                }
            default:
                break;
            }
            cell.detailTextLabel.font=FONT_14;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:{
                    UILabel *butText=[[UILabel alloc] initWithFrame:cell.frame];
                    butText.text=@"完成";
                    butText.textAlignment=NSTextAlignmentCenter;
                    butText.textColor=RED_COLOR;
                    butText.font=FONT_16;
                    [cell addSubview:butText];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//table点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currSection=0;
    _currRow=indexPath.row;
    switch (indexPath.section) {
        case 0:{
            NSMutableArray *arr=[NSMutableArray arrayWithCapacity:0];
            NSMutableArray *titArr=[NSMutableArray arrayWithCapacity:0];
            NSString *titStr=@"";
            NSString *_currString=nil;
            NSInteger _viewCurrSection=0;
            switch (indexPath.row) {
                case 0:{
                    NSMutableArray *tempArr1=[NSMutableArray arrayWithCapacity:0];
                    for(int i=0;i<sexArr.count;i++){
                        NSMutableArray *tempArr2=[NSMutableArray arrayWithObjects:[sexArr objectAtIndex:i],@"",@"0", nil];
                        [tempArr1 addObject:tempArr2];
                    }
                    [arr addObject:tempArr1];
                    
                    
                    _currString=self.loginInfo.sex;
                    titStr=@"性别";
                    break;
                }
                case 1:{
                    NSMutableArray *ageArr=[[NSMutableArray alloc] init];
                    for(int i=10;i<=80;i++){
                        [ageArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",i],@"",@"0", nil]];
                    }
                    
                    [arr addObject:ageArr];
                    titStr=@"年龄";
                    _currString=[NSString stringWithFormat:@"%d",[self.loginInfo.age intValue]];
                    break;
                }
                case 2:{
                    
                    arr=constellationArr;
                    
                    _currString=self.loginInfo.constellation;
                    titStr=@"星座";
                    break;

                    break;
                }
                case 3:{
                    NSMutableArray *tempArr1=[NSMutableArray arrayWithCapacity:0];
                    for(int i=0;i<conditionArr.count;i++){
                        NSMutableArray *tempArr2=[NSMutableArray arrayWithObjects:[conditionArr objectAtIndex:i],@"",@"0", nil];
                        [tempArr1 addObject:tempArr2];
                    }
                    [arr addObject:tempArr1];
                    _currString=self.loginInfo.condition;
                    titStr=@"状况";
                    break;
                }
                case 4:{
                    titArr=provinceArr;
                    arr=cityArr;
                    _viewCurrSection=[provinceArr indexOfObject:self.loginInfo.province];
                    _currString=self.loginInfo.city;
                    titStr=@"城市";
                    break;
                }
                default:
                    break;
            }
            TableSelectViewController *_viewController = [[TableSelectViewController alloc] init];
            _viewController.title=titStr;
            _viewController.selectArray=arr;
            _viewController.titleArray=titArr;
            _viewController.delegate=self;
            _viewController.currString=_currString;
            _viewController.currSection=_viewCurrSection;
            [self pushViewRight:_viewController];
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    //完成事件
                    
                    //注册账号
                    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
                    if(self.loginInfo.phone){
                        [param setObject:self.loginInfo.phone forKey:@"user_mobile"];
                    }
                    if(self.loginInfo.nickName){
                        [param setObject:[self.loginInfo.nickName stringFromEmoji] forKey:@"user_name"];
                    }
                    if(self.loginInfo.pwd){
                        [param setObject:self.loginInfo.pwd forKey:@"user_password"];
                    }
                    if(self.loginInfo.sex){
                        [param setObject:[NSNumber numberWithInteger:[sexArr indexOfObject:self.loginInfo.sex]] forKey:@"user_sex"];
                    }
                    if(self.loginInfo.age){
                        [param setObject:self.loginInfo.age forKey:@"user_age"];
                    }
                    if(self.loginInfo.constellation){
                        [param setObject:[self.loginInfo.constellation stringFromEmoji] forKey:@"user_constellation"];
                    }
                    if(_gps){
                        [param setObject:[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.latitude] forKey:@"user_latitude"];
                        [param setObject:[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.longitude] forKey:@"user_longitude"];
                    }
                    [param setObject:@"ios" forKey:@"user_platform"];
                    if(self.loginInfo.condition){
                        [param setObject:[NSNumber numberWithInteger:[conditionArr indexOfObject:self.loginInfo.condition]] forKey:@"user_marriage"];
                    }
                    if(self.loginInfo.city){
                        [param setObject:[self.loginInfo.city stringFromEmoji] forKey:@"user_city"];
                    }
                    if([MCSystem getAppVersion]){
                        [param setObject:[MCSystem getAppVersion] forKey:@"user_version"];
                    }
                    if(self.loginInfo.iconImage){
                        NSData *uploadData=UIImageJPEGRepresentation((UIImage*)self.loginInfo.iconImage, 0.8);
                        //[param setObject:uploadData forKey:@"user_icon"];
                        [self upFileLoading:param fiel:uploadData];
                    }else{
                        [self upLoading:param];
                    }
                    

                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

//UIAlertView协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2){
        [self goToHome];
    }
}
//tableSelect协议
-(void)tableSelectGoBack:(NSString *)currString section:(NSInteger) section{
    switch(_currSection){
        case 0:
            switch (_currRow) {
                case 0:
                    self.loginInfo.sex=currString;
                    break;
                case 1:
                    self.loginInfo.age=currString;
                    break;
                case 2:
                    self.loginInfo.constellation=currString;
                    
                    break;
                case 3:
                    self.loginInfo.condition=currString;
                    break;
                case 4:
                    self.loginInfo.city=currString;
                    self.loginInfo.province=[provinceArr objectAtIndex:section];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void) initThisData{
    constellationArr=[NSMutableArray arrayWithObjects:
                      [NSMutableArray arrayWithObjects:
                       [NSMutableArray arrayWithObjects:@"白羊座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"金牛座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"双子座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"巨蟹座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"狮子座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"处女座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"天秤座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"天蝎座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"射手座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"摩羯座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"水瓶座",@"",@"0", nil],
                       [NSMutableArray arrayWithObjects:@"双鱼座",@"",@"0", nil],
                       nil],
                      [NSMutableArray arrayWithObjects:
                       [NSMutableArray arrayWithObjects:@"我是第十三星座",@"",@"1", nil],
                       nil],
                      nil];
    NSArray *timeProvinceArr=[AreaAPI getArea];
    provinceArr=[[NSMutableArray alloc] init];
    cityArr=[[NSMutableArray alloc] init];
    int timeProvinceLen=(int)timeProvinceArr.count;
    for(int i=0;i<timeProvinceLen;i++){
        NSDictionary *dictProvince=[timeProvinceArr objectAtIndex:i];
        [provinceArr addObject:[NSString replaceUnicode:[NSString stringWithFormat:@"%@",[dictProvince objectForKey:@"name"]]]];
        NSArray *tempCityArr=[dictProvince objectForKey:@"cities"];
        //NSLog(@"tempCityArr:%@",tempCityArr);
        int tempCityLen=(int)tempCityArr.count;
        NSMutableArray *subCityArr=[[NSMutableArray alloc] init];
        for(int j=0;j<tempCityLen;j++){
            NSDictionary *dictCity=[tempCityArr objectAtIndex:j];
            NSString *cityName=[NSString replaceUnicode:[NSString stringWithFormat:@"%@",[dictCity objectForKey:@"name"]]];
            [subCityArr addObject:[NSMutableArray arrayWithObjects:cityName,@"",@"0", nil]];
        }
        [cityArr addObject:subCityArr];
    }
    [provinceArr addObject:@"其它地区"];
    [cityArr addObject:[NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"其它",@"",@"1", nil], nil]];
}

-(void)upLoading:(NSDictionary *)param{
    NSString *url=[UrlAPI getUserReg];
    [UPHTTPTools post:url params:param success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            CurrentUser *currentUser=[CurrentUser sharedInstance];
            currentUser.uId=[NSString replaceUnicode:[[responseObj objectForKey:@"content"]objectForKey:@"user_id"]];
            currentUser.auth=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_auth"]];
            currentUser.nickName=self.loginInfo.nickName;
            currentUser.age=self.loginInfo.age;
            currentUser.sex=self.loginInfo.sex;
            currentUser.tel=self.loginInfo.phone;
            currentUser.constellation=self.loginInfo.constellation;
            currentUser.condition=self.loginInfo.condition;
            currentUser.province=self.loginInfo.province;
            currentUser.city=self.loginInfo.city;
            currentUser.longitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.longitude];
            currentUser.latitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.latitude];
            currentUser.loginTime=[NSNumber numberWithInteger:[NSDate timeStamp]];
            
            
            [currentUser save];
            //设置为已注册过
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegister"];
            //设置为已登录
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=2;
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString replaceUnicode:[responseObj objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }];
}
-(void)upFileLoading:(NSDictionary *)param fiel:(NSData *)fiel{
    NSString *url=[UrlAPI getUserRegFiel];
    
    [UPHTTPTools postFiel:url fiel:fiel params:param success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        NSLog(@"responseObj:%@",responseObj);
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            CurrentUser *currentUser=[CurrentUser sharedInstance];
            currentUser.uId=[NSString replaceUnicode:[[responseObj objectForKey:@"content"]objectForKey:@"user_id"]];
            currentUser.auth=[NSString replaceUnicode:[[responseObj objectForKey:@"content"] objectForKey:@"user_auth"]];
            currentUser.nickName=self.loginInfo.nickName;
            currentUser.age=self.loginInfo.age;
            currentUser.sex=self.loginInfo.sex;
            currentUser.tel=self.loginInfo.phone;
            currentUser.constellation=self.loginInfo.constellation;
            currentUser.condition=self.loginInfo.condition;
            currentUser.province=self.loginInfo.province;
            currentUser.city=self.loginInfo.city;
            currentUser.longitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.longitude];
            currentUser.latitude=[NSNumber numberWithFloat:_gps.locationManager.location.coordinate.latitude];
            currentUser.loginTime=[NSNumber numberWithInteger:[NSDate timeStamp]];
            
            
            [currentUser save];
            //设置为已注册过
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRegister"];
            //设置为已登录
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=2;
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString replaceUnicode:[responseObj objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=1;
            [alert show];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
    }];
}
@end
