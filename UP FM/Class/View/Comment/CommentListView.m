//
//  CommentListView.m
//  UP FM
//
//  Created by liubin on 15/1/29.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "CommentListView.h"
#import "Comment.h"
#import "User.h"
#import "Functions.h"


@implementation CommentListView
@synthesize commentArray;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        commentArray=self.commentArray;
        frameWidth=frame.size.width;
        
        iconWidth=60.0;
        contentLeft=iconWidth+10+10;
        contentWidth=frameWidth-10-iconWidth-10-10;
        
        
        int len=(int)commentArray.count;
        contentHeightArray=[[NSMutableArray alloc] init];
        
        
        
        for (int i=0; i<len; i++) {
            Comment *comment=[commentArray objectAtIndex:i];
            CGFloat conethtHeight=[Functions getTextHeight:comment.content:CGSizeMake(contentWidth, 1000):FONT_14];
            [contentHeightArray addObject:[NSNumber numberWithFloat:conethtHeight]];
            
        }
        
        
        [self initView:frame];
    }
    return self;
}

-(void) initView:(CGRect) frame{
    UIView *mainView=[[UIView alloc] initWithFrame:frame];
    [self addSubview:mainView];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden           = NO;
    _tableView.scrollEnabled    = YES;
    _tableView.bounces          = YES;
    _tableView.alwaysBounceHorizontal   = NO;
    _tableView.alwaysBounceVertical     = NO;
    _tableView.bouncesZoom      = NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.allowsSelection  = YES;
    [mainView addSubview:_tableView];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    
    
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    } else {
        for(UIView *subview in cell.subviews){
            [subview removeFromSuperview];
        }
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSUInteger row=[indexPath row];
    
    
    Comment *comment=[commentArray objectAtIndex :row];
    
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10 ,iconWidth, iconWidth)];
    icon.image=[UIImage imageNamed:comment.user.icon];
    [cell addSubview:icon];
    
    float rightTextWidth=120.0;
    float line1TextHeight=20.0;
    
    UILabel *userName=[[UILabel alloc] initWithFrame:CGRectMake(contentLeft, 10, frameWidth-contentLeft-rightTextWidth-10-10, line1TextHeight)];
    userName.text=comment.user.nickName;
    userName.textColor=TEXT_COLOR_SHALLOW;
    userName.font=FONT_12;
    [cell addSubview:userName];
    
    UILabel *rightText=[[UILabel alloc] initWithFrame:CGRectMake(frameWidth-rightTextWidth-10-10, 10, rightTextWidth, line1TextHeight)];
    
    NSDateFormatter *dateAtter=[[NSDateFormatter alloc] init];
    [dateAtter setDateFormat:@"MM月DD日"];
    rightText.text=[NSString stringWithFormat:@"%@ %d楼",[dateAtter stringFromDate:comment.commentTime],[comment.sort intValue]];
    rightText.font=FONT_12;
    rightText.textAlignment=NSTextAlignmentRight;
    rightText.textColor=TEXT_COLOR_SHALLOW;
    [cell addSubview:rightText];
    
    float cententHeight=[[contentHeightArray objectAtIndex:row] floatValue];
    
    UILabel *contentText=[[UILabel alloc] initWithFrame:CGRectMake(contentLeft, 10+line1TextHeight+5, contentWidth, cententHeight)];
    contentText.text=comment.content;
    contentText.textColor=TEXT_COLOR;
    contentText.font=FONT_14;
    contentText.numberOfLines=0;
    [cell addSubview:contentText];
    
    float line1Top=10+line1TextHeight+5+cententHeight+5;
    line1Top=line1Top<79?79:line1Top;
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(10, line1Top, frameWidth-10, 1)];
    line1.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [cell addSubview:line1];
    
    //选中后的颜色又不发生改变，进行下面的设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

//返回总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentArray count];
}
//返回每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *contentHeight=[contentHeightArray objectAtIndex:indexPath.row];
    float _height=10+[contentHeight floatValue]+20+5+10;
    return _height>80.0?_height:80.0;
}
//设定可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
