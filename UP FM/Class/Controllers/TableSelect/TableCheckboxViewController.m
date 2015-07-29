//
//  TableCheckboxViewController.m
//  UP FM
//
//  Created by liubin on 15/3/3.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "TableCheckboxViewController.h"
#import "Functions.h"

@interface TableCheckboxViewController ()

@end

@implementation TableCheckboxViewController

@synthesize checkboxArray;
@synthesize currentArray;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    self.title=@"请选择";
    
    [self navBackShow];
    
    //导航右侧完成按钮
    UIButton *finishButton=[Functions initBarRightButton:BarButtonTypeFinish];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    
    tableTop=0.0;//NAV_HEIGHT+STATUS_BAR_HEIGHT;
    tableHeight=WIN_HEIGHT-tableTop;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, tableTop, WIN_WIDTH, tableHeight)];
    
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled=YES;
    
    
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }
    NSDictionary *dict=[self.checkboxArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[dict objectForKey:@"value"];
    if(self.currentArray){
        for(NSNumber *num in self.currentArray){
            if([num isEqualToNumber:[dict objectForKey:@"key"]]){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
                break;
            }
        }
    }
    
    cell.detailTextLabel.font=FONT_14;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//table点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *key=[[self.checkboxArray objectAtIndex:indexPath.row] objectForKey:@"key"];
    int index=-1;
    int len=(int)self.currentArray.count;
    for(int i=0;i<len;i++){
        NSNumber *k =[self.currentArray objectAtIndex:i];
        if([k isEqualToNumber:key]){
            index=i;
            break;
        }
    }
    if(index>-1){
        [self.currentArray removeObjectAtIndex:index];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
        [self.currentArray addObject:key];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
}
//返回总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.checkboxArray.count;
}
//返回每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SETTING_HEIGHT;
}
//设定可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}




-(void)finishAction{
    [self.delegate tableCheckboxGoBack:self.currentArray signal:self.signal];
    [self goToBack];
}

@end
