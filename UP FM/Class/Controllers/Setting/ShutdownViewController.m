//
//  ShutdownViewController.m
//  UP FM
//
//  Created by liubin on 15/1/27.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "ShutdownViewController.h"
#import "UPFMBase.h"
#import "ShutdownDefinedTimeViewController.h"


@implementation ShutdownViewController

@synthesize selectedBackgroundView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    
    //加载导航右侧音乐按钮
    UIButton *butComplete=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
    UILabel *butCompleteText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
    butCompleteText.text=@"完成";
    [butComplete addTarget:self action:@selector(setComplete) forControlEvents:UIControlEventTouchUpInside];
    [butComplete addSubview:butCompleteText];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butComplete];
    
    [self navBackShow];
    
    self.title=@"定时关机";
    
    tableTop=0;//NAV_HEIGHT+STATUS_BAR_HEIGHT;
    tableHeight=WIN_HEIGHT-tableTop;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, tableTop, WIN_WIDTH, tableHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = SETTING_HEIGHT;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    isShutdown = [[NSUserDefaults standardUserDefaults] boolForKey:@"shutdownOn"];
    currentTime=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"definedShutdownTime"]?(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"definedShutdownTime"]:0;
    timeArr=[NSArray arrayWithObjects:@"15",@"30",@"45",@"60",[NSString stringWithFormat:@"%d",(int)currentTime,nil],
             nil];
    currentIndex=[timeArr indexOfObject:[NSString stringWithFormat:@"%d",(int)currentTime,nil]];
    
    [_tableView  reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//设置分组，每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
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
    BOOL isBackColor=YES;
    UIColor *textColor=isShutdown?TEXT_COLOR:TEXT_COLOR_SHALLOW;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.textLabel.text = @"开启定时";
                    textColor=TEXT_COLOR;
                    UISwitch *shutdownSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 10, 50, 30)];
                    shutdownSwitch.on=isShutdown;
                    [cell addSubview:shutdownSwitch];
                    [shutdownSwitch addTarget:self
                                   action:@selector(setShutdownOn)
                         forControlEvents:UIControlEventValueChanged];
                    
                    
                    isBackColor=NO;
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                   
                    cell.textLabel.text = @"15分钟后";
                    
                    break;
                }
                case 1:
                {
                    
                    cell.textLabel.text = @"30分钟后";
                    
                    break;
                }
                case 2:
                {
                    
                    cell.textLabel.text = @"45分钟后";
                    
                    break;
                }
                case 3:
                {
                    
                    cell.textLabel.text = @"60分钟后";
                    
                    break;
                }
                case 4:
                {
                    cell.textLabel.text = @"自定义";
                    if(isShutdown && currentIndex==4){
                        cell.detailTextLabel.text=currentTime==0?@"未设置":[NSString stringWithFormat:@"%d分钟",(int)currentTime];
                        cell.detailTextLabel.font=FONT_12;
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    if(!isShutdown){
                cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
        switch (indexPath.section){
            case 0:{
                
                break;
            }
            case 1:{
                if(indexPath.row==4){
                    
                    
                }else if(indexPath.row==currentIndex){
                    cell.accessoryType=UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }
                break;
            }
            default:
                cell.accessoryType=UITableViewCellAccessoryNone;
                break;
        }
    }
    
    
    cell.textLabel.textColor=textColor;
    cell.textLabel.font=SETTING_FONT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//table点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    
                    break;
                }
                case 1:
                {
                    
                    break;
                }
                case 2:
                {
                    
                    break;
                }
                case 3:
                {
                    
                    break;
                }
                case 4:
                {
                    if(isShutdown){
                    //自定义时间
                    ShutdownDefinedTimeViewController *_viewController = [[ShutdownDefinedTimeViewController alloc] init];
                        [self pushViewRight:_viewController];
                    }
                    break;
                    
                }
                default:
                    break;
            }
            if(isShutdown){
                currentIndex=indexPath.row;
            }
            
            
            break;
        }
        default:
            break;
    }
    [_tableView  reloadData];
}
//设置标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tit=@"";
    switch (section) {
        case 0:
            
            break;
        case 1:
            tit=@"播放完当前节目";
            break;
        default:
            break;
    }
    
    
    return tit;
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
//    if(!isShutdown){
//        return UITableViewCellAccessoryNone;
//    }
//    switch (indexPath.section){
//        case 0:{
//            return UITableViewCellAccessoryNone;
//            break;
//        }
//        case 1:{
//            if(indexPath.row==4){
//                return UITableViewCellAccessoryDisclosureIndicator;
//                
//            }else if(indexPath.row==currentIndex){
//                return UITableViewCellAccessoryCheckmark;
//            }else{
//                return UITableViewCellAccessoryNone;
//            }
//            break;
//        }
//        default:
//            return UITableViewCellAccessoryNone;
//            break;
//    }
//    
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark 设置开启定时关机
- (void)setShutdownOn{
    isShutdown=!isShutdown;
    [self performSelector:@selector(setTimeout) withObject:nil afterDelay:0.2f];
}
-(void)setTimeout {
    [_tableView  reloadData];
}
#pragma mark 设置完成
-(void)setComplete{
    [[NSUserDefaults standardUserDefaults] setInteger:[[timeArr objectAtIndex:currentIndex] integerValue] forKey:@"definedShutdownTime"];
    [[NSUserDefaults standardUserDefaults] setBool:isShutdown forKey:@"shutdownOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self goToBack];
}

@end
