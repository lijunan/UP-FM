//
//  UPFMViewController.m
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "UPFMViewController.h"
#import "PlayerViewController.h"



@interface UPFMViewController (){
    NSNotificationCenter *notificationCenter;
    CurrentUser *_currentUser;
}

- (void)updateGPS:(CLLocation *)location;

@end

@implementation UPFMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=BACK_COLOR;
    
    
    
    
    
    //导航栏高
    NAV_HEIGHT=self.navigationController.navigationBar.frame.size.height;
    
    //状态栏高
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    STATUS_BAR_HEIGHT=rect.size.height;
    
    [self setNavStyle];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    [self.navigationItem setHidesBackButton:YES];
    
    navMusicButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,24,24)];
    [navMusicButton addTarget:self action:@selector(navMusicButtonParss) forControlEvents:UIControlEventTouchUpInside];
    [navMusicButton setImage:[UIImage imageNamed:@"icon-music"]forState:UIControlStateNormal];
    //右按钮
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithCustomView:navMusicButton];
    navMusicButton.hidden=YES;
    self.navigationItem.rightBarButtonItem= musicItem;
    
    _currentUser = [CurrentUser sharedInstance];
    if (! _currentUser.uId) {
        _currentUser.uId = nil;
    }
    self.mcPlayer=[MCPlayer sharedInstance];
    if([self.mcPlayer isPlaying]){
        [self navMusicButtonHide:NO];
    }
    self.playTime=0;
    
    
    
    _gps = [GPS sharedInstance];
    _gps.delegate = self;
    
    if (!_gps.isUpdate) {
        if (_gps.locationManager.location.coordinate.latitude > 0 && _gps.locationManager.location.coordinate.longitude > 0) {
            //已获得GPS
            [self updateGPS:_gps.locationManager.location];
        }
    }
    
   
    
    
    //测试网络
    //NSLog(@"%@",[UPHTTPTools sharedClient]);
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self setNavStyle];
}

-(void)viewWillDisappear{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//设置导航样式
-(void)setNavStyle{
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setTintColor:RED_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
}
//View左进入
-(void)pushViewLeft:(id)pushView{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype=kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:pushView animated:NO];
}
//View右进入
-(void)pushViewRight:(id)pushView{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype=kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:pushView animated:NO];
}
//View无动画切换
-(void)pushView:(id)view{
    [self.navigationController pushViewController:view animated:NO];
}
//返回上View
-(void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goToBack:(int)index{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 1 - index] animated:YES];
    
}
-(void)goToHome{
    [self goToHome:YES];
}
-(void)goToHome:(BOOL) animate{
    [self.navigationController popToRootViewControllerAnimated:animate];
}



//加载导航音乐播放器按钮
-(void)navMusicButtonHide:(BOOL)hide{
    navMusicButton.hidden=hide;
}
//加载返回按钮
-(void)navBackShow{
    [self.navigationItem setHidesBackButton:NO];
}
//导航音乐播放器按钮点击事件
-(void)navMusicButtonParss{
    PlayerViewController *_viewController = [[PlayerViewController alloc] init];
    [self pushViewRight:_viewController];
}
/**
 * 播放器 start
 **/
//设置当前音乐
-(void)musicPlay:(NSMutableArray *)musicArray index:(NSInteger)index{
    
    [self.mcPlayer initPlayer:musicArray];
    [self.mcPlayer play:index];
    [self navMusicButtonHide:NO];
    
}
//暂停
-(void)musicPause{
    self.playTime=_currentItem.currentTime;
    [self.mcPlayer pause];
}
//继续
-(void)musicContinuePlay{
    [self.mcPlayer play:self.mcPlayer.index];
}

/**
 * 播放器 end
 **/
#pragma mark - GPS

- (void)locationUpdate:(CLLocation *)location{
    NSLog(@"locationUpdate");
    [self updateGPS:location];
}

- (void)locationError:(NSError *)error{
    
}

- (void)updateGPS:(CLLocation *)location{
    //保存最新的GPS
    NSDictionary *gpsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:location.coordinate.latitude], @"latitude",
                             [NSNumber numberWithDouble:location.coordinate.longitude], @"longitude", nil];
    
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:gpsDict];
    [[NSUserDefaults standardUserDefaults] setObject:udObject forKey:@"GPS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //更新GPS
    if (_currentUser.uId) {
        _currentUser.longitude=[NSNumber numberWithFloat:location.coordinate.longitude];
        _currentUser.latitude=[NSNumber numberWithFloat:location.coordinate.latitude];
        [_currentUser save];
    }
    _gps.isUpdate = YES;
}



@end
