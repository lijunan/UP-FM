//
//  ListenMediaListView.m
//  UP FM
//
//  Created by liubin on 15/1/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "ListenMediaListView.h"
#import "Media.h"
#import "Album.h"
#import "Music.h"
#import "Announcer.h"
#import "MarqueeLabel.h"


@implementation ListenMediaListView

@synthesize mediaArray;
@synthesize isDelBut;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        mediaArray=self.mediaArray;
        frameWidth=frame.size.width;
        tableHeight=100.0; //frameWidth*(210.0/DESING_WIDTH);
        
        imgWidth=tableHeight-10-20;
        
        [self initView:frame];
    }
    return self;
}

-(void) initView:(CGRect) frame{
    UIView *mainView=[[UIView alloc] initWithFrame:frame];
    [self addSubview:mainView];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 5, frameWidth, frame.size.height-10)];
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
    
    
    Music *music=[mediaArray objectAtIndex :row];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 5, frameWidth-20, tableHeight-10)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=3.0;
    view.tag=row;
    view.userInteractionEnabled=YES;
    [cell addSubview:view];
    
    
    
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToAlbum:)];
        [view addGestureRecognizer:gesture];
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imgWidth, imgWidth)];
    
        [img setImageWithURL:[NSURL URLWithString:music.album.icon] placeholderImage:DEFAULT_IMAGE];
        [view addSubview:img];
        
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10+imgWidth+10,10, frameWidth-20-10-imgWidth-10-10, 20)];
        title.text=music.album.title;
    
        title.font=FONT_16B;
        title.adjustsFontSizeToFitWidth=YES;
        title.lineBreakMode = NSLineBreakByCharWrapping;
        title.numberOfLines=1;
        title.minimumScaleFactor=8.0;
        title.textColor=TEXT_COLOR;
        [view addSubview:title];
        
        UILabel *owner=[[UILabel alloc] initWithFrame:CGRectMake(10+imgWidth+10,40, frameWidth-20-10-imgWidth-10-10, 20)];
        owner.text=music.album.mediaTag;
        
        owner.font=FONT_14B;
        owner.adjustsFontSizeToFitWidth=YES;
        owner.lineBreakMode = NSLineBreakByCharWrapping;
        owner.numberOfLines=1;
        owner.minimumScaleFactor=8.0;
        owner.textColor=TEXT_COLOR_SHALLOW;
        [view addSubview:owner];
        
        
        
        MarqueeLabel *subTitle=[[MarqueeLabel alloc] initWithFrame:CGRectMake(10+imgWidth+10,60, frameWidth-20-10-imgWidth-10-10, 20)];
        int timePlay=[music.timePlay intValue];
        NSString *playTime=[NSString stringWithFormat:@"(%d分%@%d秒)",(int)floor(timePlay/60.0),timePlay%60>9?@"":@"0",timePlay%60];
    subTitle.text=[NSString stringWithFormat:@"播放到：%@%@",music.title,timePlay>0?playTime:@""];
        subTitle.font=FONT_12;
        subTitle.numberOfLines=1;
        
        subTitle.marqueeType = MLContinuous;
        subTitle.textColor=TEXT_COLOR;
        [view addSubview:subTitle];
        
    
    
    
    //选中后的颜色又不发生改变，进行下面的设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

//返回总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mediaArray count];
}
//返回每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableHeight;
}
//设定可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isDelBut){
        return YES;
    }else{
        return NO;
    }
}
//划动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Music *music=[self.mediaArray objectAtIndex:indexPath.row];
        [self.delegate listenDel:music];
        //数组中删除数据
        [mediaArray removeObjectAtIndex:indexPath.row];
        //view中删除
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)handleTapToAlbum:(id)sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    Music *music=[self.mediaArray objectAtIndex:[singleTap view].tag];
    [self.delegate listenToAlbum:music.album];
}


@end
