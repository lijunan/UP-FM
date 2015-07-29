//
//  GroupedView.m
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "GroupedView.h"

@implementation GroupedView

@synthesize groupedArray;
@synthesize groupedTieleArray;
@synthesize delegate;

@synthesize selectedBackgroundView;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:frame];
        
    }
    return self;
}

-(void) initView:(CGRect) frame{
    self._tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self._tableView.rowHeight =SETTING_HEIGHT;
    self._tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self._tableView.backgroundColor = [UIColor clearColor];
    self._tableView.backgroundView = nil;
    self._tableView.dataSource = self;
    self._tableView.delegate = self;
    
    [self addSubview:self._tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedArray.count;
}

//设置分组，每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.groupedArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.showsReorderControl=YES;
    }
    
    UIColor *textColor=TEXT_COLOR;
    
    NSArray *arr=[[self.groupedArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[arr objectAtIndex:0];
    cell.textLabel.font=SETTING_FONT;
    
    cell.detailTextLabel.text=[arr objectAtIndex:1];
    
    if([[arr objectAtIndex:2] isEqualToString:@"1"]){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.textColor=textColor;
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    aView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.selectedBackgroundView = aView;
    cell.selectedBackgroundView=aView;
    
    return cell;
}
//table点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate groupedButParss:indexPath.section row:indexPath.row];
    
}
//设置标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.groupedTieleArray objectAtIndex:section];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}





@end
