//
//  InformationViewController.m
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "InformationViewController.h"
#import "UPFMBase.h"
#import "AreaAPI.h"
#import "DownloadController.h"
#import "DownloadedList.h"

@implementation InformationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initThisData];
    self.loginInfo=[[LoginInfo alloc] init];
    /*
     * 导航条设置
     */
    
    [self navBackShow];
    
    self.title=@"修改资料";
    
    
    currentIndex=0;
    
    _currentUser=[CurrentUser sharedInstance];
    
    sexArr=SEX_ARR;
    conditionArr=CONDITION_ARR;
    
    //加载tab
    tabBarArray=[NSMutableArray arrayWithObjects:@"基本信息",@"账号信息",nil];
    
    
    tabBarHeight=WIN_WIDTH*(95/DESING_WIDTH);
    tabBarViewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    
    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0,tabBarViewTop , WIN_WIDTH, tabBarHeight)];
    [self.view addSubview:tabBarView];
    self.view.layer.masksToBounds=YES;
    tabBar=[TabBarView alloc];
    tabBar.tabArray=tabBarArray;
    tabBar.delegate=self;
    tabBar=[tabBar initWithFrame:CGRectMake(0, 0, WIN_WIDTH, tabBarHeight)];
    [tabBarView addSubview:tabBar];
    
    
    //加载列表
    float footViewHeight=40.0;
    listViewTop=tabBarViewTop+tabBarHeight;
    listViewHeight=WIN_HEIGHT-listViewTop-footViewHeight;
    
    listView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, listViewTop, WIN_WIDTH, listViewHeight)];
    listView.backgroundColor=[UIColor clearColor];
    listView.delegate=self;
    listView.contentSize=CGSizeMake(WIN_WIDTH*(int)tabBarArray.count, listViewHeight);
    listView.pagingEnabled=YES;
    listView.showsVerticalScrollIndicator=NO;
    listView.showsHorizontalScrollIndicator=NO;
    listView.bounces=NO;
    //listView.scrollEnabled=NO;
    
    [listView setCanCancelContentTouches:YES];
    [self.view addSubview:listView];
    
    
    //基本信息列表
    
    basicTitleArray=[NSMutableArray arrayWithObjects:@"", nil];
    UIView *basicView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*0, 0, WIN_WIDTH, listViewHeight)];
    [listView addSubview:basicView];
    basicListView=[GroupedView alloc];
    basicListView.delegate=self;
    basicListView.groupedArray=basicArray;
    basicListView.groupedTieleArray=basicTitleArray;
    basicListView=[basicListView initWithFrame:CGRectMake(0,0, WIN_WIDTH, listViewHeight)];
    [basicView addSubview:basicListView];
    
    
    //账号信息列表
    accountArray=[NSMutableArray arrayWithObjects:
                  [NSMutableArray arrayWithObjects:
                   [NSMutableArray arrayWithObjects:@"注册手机",[_currentUser.tel stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"],@"0",nil],
//                   [NSMutableArray arrayWithObjects:@"注册时间",@"2015-01-12",@"0",nil],
//                   [NSMutableArray arrayWithObjects:@"会员级别",@"VIP",@"0",nil],
                   nil
                   ],
//                  [NSMutableArray arrayWithObjects:
//                   [NSMutableArray arrayWithObjects:@"QQ",@"未绑定",@"1",nil],
//                   [NSMutableArray arrayWithObjects:@"新浪微博",@"已绑定",@"1",nil],
//                   [NSMutableArray arrayWithObjects:@"微信",@"未绑定",@"1",nil],
//                   nil
//                   ],
                  nil
                ];
    accountTitleArray=[NSMutableArray arrayWithObjects:@"账号信息",@"绑定信息",@"", nil];
    UIView *accountView=[[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH*1, 0, WIN_WIDTH, listViewHeight)];
    [listView addSubview:accountView];
    accountListView=[GroupedView alloc];
    accountListView.delegate=self;
    accountListView.groupedArray=accountArray;
    accountListView.groupedTieleArray=accountTitleArray;
    accountListView=[accountListView initWithFrame:CGRectMake(0,0, WIN_WIDTH, listViewHeight)];
    [accountView addSubview:accountListView];

    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, WIN_HEIGHT-footViewHeight, WIN_WIDTH, footViewHeight)];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    UIView *footViewBorder=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    footViewBorder.backgroundColor=FOOT_BORDER_COLOR;
    [footView addSubview:footViewBorder];
    UIButton *outLogin=[[UIButton alloc] initWithFrame:CGRectMake(0, 1, WIN_WIDTH, footViewHeight-1)];
    [outLogin addTarget:self action:@selector(outLoginParss) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:outLogin];
    UILabel *outLoginText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, footViewHeight-1)];
    outLoginText.text=@"退出登录";
    outLoginText.textAlignment=NSTextAlignmentCenter;
    outLoginText.textColor=RED_COLOR;
    outLoginText.font=FONT_16B;
    [outLogin addSubview:outLoginText];
}
-(void) viewWillAppear:(BOOL)animated{
   
    basicArray=[self getBasicArray];
    basicListView.groupedArray=basicArray;
    [basicListView._tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


//划动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    currentIndex=ceil(listView.contentOffset.x/WIN_WIDTH);
    [tabBar setCurrentTab:currentIndex];
}

//tab协议
-(void)tabButParss:(int)index{
    currentIndex=index;
    [listView setContentOffset:CGPointMake(WIN_WIDTH*index, 0) animated:YES];
}

//分组列表协议
-(void)groupedButParss:(NSInteger)section row:(NSInteger)row{
    switch (currentIndex) {
        case 0:{
            _currSection=section;
            _currRow=row;
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            NSMutableArray *titArr=[[NSMutableArray alloc] init];
            NSString *titStr=@"";
            NSString *_currString=nil;
            NSInteger _viewCurrSection=0;
            switch (row) {
                case 0:{
                    NSMutableArray *tempArr1=[NSMutableArray arrayWithCapacity:0];
                    for(int i=0;i<sexArr.count;i++){
                        NSMutableArray *tempArr2=[NSMutableArray arrayWithObjects:[sexArr objectAtIndex:i],@"",@"0", nil];
                        [tempArr1 addObject:tempArr2];
                    }
                    [arr addObject:tempArr1];
                    
                    _currString=_currentUser.sex;
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
                    _currString=_currentUser.age;
                    break;
                }
                case 2:{
                    
                    arr=constellationArr;
                    
                    _currString=_currentUser.constellation;
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
                    _currString=_currentUser.condition;
                    titStr=@"状况";
                    break;
                }
                case 4:{
                    titArr=provinceArr;
                    arr=cityArr;
                    _viewCurrSection=[provinceArr indexOfObject:_currentUser.province];
                    _currString=_currentUser.city;
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
        case 1:
            NSLog(@"%@",[[[accountArray objectAtIndex:section] objectAtIndex:row] objectAtIndex:0]);
        default:
            break;
    }
}

//tableSelect协议
-(void)tableSelectGoBack:(NSString *)currString section:(NSInteger) section{
    switch(_currSection){
        case 0:
            switch (_currRow) {
                case 0:
                    _currentUser.sex=currString;
                    break;
                case 1:
                    _currentUser.age=currString;
                    break;
                case 2:
                    _currentUser.constellation=currString;
                    
                    break;
                case 3:
                    _currentUser.condition=currString;
                    break;
                case 4:
                    _currentUser.city=currString;
                    _currentUser.province=[provinceArr objectAtIndex:section];
                    break;
                default:
                    break;
            }
            [_currentUser update];
            break;
        default:
            break;
    }
}

-(NSMutableArray *)getBasicArray{
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableArray arrayWithObjects:
             [NSMutableArray arrayWithObjects:@"性别",[NSString stringWithFormat:@"%@",_currentUser.sex?_currentUser.sex:@""],@"1",nil],
             [NSMutableArray arrayWithObjects:@"年龄",[_currentUser.age intValue]?[NSString stringWithFormat:@"%d",[_currentUser.age intValue]]:@"",@"1",nil],
             [NSMutableArray arrayWithObjects:@"星座",[NSString stringWithFormat:@"%@",_currentUser.constellation?_currentUser.constellation:@""],@"1",nil],
             [NSMutableArray arrayWithObjects:@"状况",[NSString stringWithFormat:@"%@",_currentUser.condition?_currentUser.condition:@""],@"1",nil],
             [NSMutableArray arrayWithObjects:@"城市",[NSString stringWithFormat:@"%@ %@",_currentUser.province?_currentUser.province:@"",_currentUser.city?_currentUser.city:@""],@"1",nil],
             nil
             ],
            
            nil
            ];
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

-(void)outLoginParss{
    if([[DownloadController sharedInstance] getDownloadedList].count>0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退出登录" message:@"有下载的节目是否同时删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除并退出",@"不删除，只退出", nil];
        alert.tag=8888;
        [alert show];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"是否退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        alert.tag=9999;
        [alert show];
    }
}
-(void)clearDownloadFile{
    DownloadController *downloadController=[DownloadController sharedInstance];
    NSArray *fileArr=[downloadController getDownloadedList];
    for(Music *file in fileArr){
        [downloadController deleteDownloadedFile:file];
    }
}
#pragma mark 退出
- (void)signOut {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CurrentUser *currentUser = [CurrentUser sharedInstance];
    [currentUser clear];
    [self goToBack];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 8888:{ //有下载退出
            switch (buttonIndex) {
                case 1:
                    [self clearDownloadFile];
                    [self signOut];
                    break;
                case 2:
                    [self signOut];
                    break;
                default:
                    break;
            }

            break;
        }
        case 9999:{ //无下载退出
            switch (buttonIndex) {
                case 1:
                    [self signOut];
                    break;
                
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

@end
