//
//  MessageViewController.m
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "MessageSetViewController.h"

@implementation MessageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /*
     * 导航条设置
     */
    
    
    //加载返回导航条按钮
    [self navBackShow];
    
    self.title=@"设置";
    
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
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    
                    cell.textLabel.text = @"每日推荐消息";
                    BOOL dayRecommendOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"dayRecommendOn"];

                    UISwitch *butSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 10, 50, 30)];
                    butSwitch.on=dayRecommendOn;
                    [cell addSubview:butSwitch];
                    [butSwitch addTarget:self
                                   action:@selector(setDayRecommend)
                         forControlEvents:UIControlEventValueChanged];
                    
                    break;
                }
                case 1:{
                    
                    cell.textLabel.text = @"节目更新提示（仅小红点）";
                    BOOL televisionUpdateOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"televisionUpdateOn"];
                    
                    UISwitch *butSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 10, 50, 30)];
                    butSwitch.on=televisionUpdateOn;
                    [cell addSubview:butSwitch];
                    [butSwitch addTarget:self
                                  action:@selector(setTelevisionUpdate)
                        forControlEvents:UIControlEventValueChanged];
                    
                    break;
                }
                case 2:{
                    
                    cell.textLabel.text = @"好友评论提示（小红点）";
                    BOOL commentSetOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"commentSetOn"];
                    UISwitch *butSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(WIN_WIDTH-70, 10, 50, 30)];
                    butSwitch.on=commentSetOn;
                    [cell addSubview:butSwitch];
                    [butSwitch addTarget:self
                                  action:@selector(setComment)
                        forControlEvents:UIControlEventValueChanged];
                    
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
    
    cell.textLabel.font=SETTING_FONT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark 设置提示
- (void)setDayRecommend{
    BOOL notOnlyWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"dayRecommendOn"];
    [[NSUserDefaults standardUserDefaults] setBool:!notOnlyWifi forKey:@"dayRecommendOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setTelevisionUpdate{
    BOOL notOnlyWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"televisionUpdateOn"];
    [[NSUserDefaults standardUserDefaults] setBool:!notOnlyWifi forKey:@"televisionUpdateOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setComment{
    BOOL notOnlyWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"commentSetOn"];
    [[NSUserDefaults standardUserDefaults] setBool:!notOnlyWifi forKey:@"commentSetOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
