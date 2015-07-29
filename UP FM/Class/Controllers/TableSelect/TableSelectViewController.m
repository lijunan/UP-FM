//
//  TableSelectViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "TableSelectViewController.h"
#import "Functions.h"

@implementation TableSelectViewController

@synthesize title;
@synthesize selectArray;
@synthesize titleArray;
@synthesize currSection;
@synthesize currString;
@synthesize editTextMax;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    [self navBackShow];

    //导航右侧完成按钮
    UIButton *finishButton=[Functions initBarRightButton:BarButtonTypeFinish];
    [finishButton addTarget:self action:@selector(accomplish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    
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
    return self.selectArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr=[self.selectArray objectAtIndex:section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }
    NSArray *arr=[[self.selectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *str=[arr objectAtIndex:0];
    cell.textLabel.text=str;
    cell.detailTextLabel.text=[arr objectAtIndex:1];
    switch ([[arr objectAtIndex:2] intValue]){
        case 0:
            if(indexPath.section==self.currSection && [str isEqualToString:self.currString]){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            break;
        case 1:
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    cell.detailTextLabel.font=FONT_14;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray.count>section?[self.titleArray objectAtIndex:section]:@"";
}
//table点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currSection=indexPath.section;
    self.currRow=indexPath.row;
    NSArray *arr=[[self.selectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if([[arr objectAtIndex:2] isEqualToString:@"1"]){
        
        TableSelectEditViewController *_viewController = [[TableSelectEditViewController alloc] init];
        _viewController.title=self.title;
        _viewController.labelString=[arr objectAtIndex:0];
        _viewController.content=[arr objectAtIndex:1];
        _viewController.delegate=self;
        _viewController.editTextMax=self.editTextMax;
        [self pushViewRight:_viewController];
        
        
    }else{
        self.currString=[arr objectAtIndex:0];
    }
    [_tableView  reloadData];
}

-(void)accomplish{
    [self.delegate tableSelectGoBack:self.currString section:self.currSection];
    [self goToBack];
}

//TableSelectEditViewController 协议
-(void)tableSelectEditComplete:(NSString *)string{
    self.currString=string;
    [[[self.selectArray objectAtIndex:self.currSection] objectAtIndex:self.currRow] replaceObjectAtIndex:1 withObject:string];
}

@end
