//
//  SaveMediaListView.m
//  UP FM
//
//  Created by liubin on 15/1/25.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "OperationMediaListView.h"

#import "Music.h"

@implementation OperationMediaListView

@synthesize mediaArray;
@synthesize butFirst;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        frameWidth=frame.size.width;
        viewWidth=frameWidth-20;
        tableHeight=130.0; //frameWidth*(210.0/DESING_WIDTH);
        butViewHeight=40.0;
        imgWidth=tableHeight-30-10-butViewHeight;
        
        butPlayWidth=(tableHeight-50)/2;
        butPlayImgWidth=butPlayWidth/4;
        butPlayImgTop=(butPlayWidth-butPlayImgWidth)/2;
        
        butWidth=(viewWidth-3)/4;
        butIconWidth=20.0;
        butSubTop=(butViewHeight-butIconWidth-1)/2;
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
    
    Music *music=[self.mediaArray objectAtIndex:row];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 5, viewWidth, tableHeight-10)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=3.0;
    view.layer.masksToBounds=YES;
    [cell addSubview:view];
    
    UIButton *butPlay=[[UIButton alloc] initWithFrame:CGRectMake(10, butPlayWidth/2, butPlayWidth, butPlayWidth)];
    butPlay.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butPlay.layer.borderColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor;
    butPlay.layer.cornerRadius=butPlayWidth/2;
    butPlay.tag=row;
    [butPlay addTarget:self action:@selector(playParss:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butPlay];
    
    UIImageView *butPlayImg=[[UIImageView alloc] initWithFrame:CGRectMake(butPlayImgTop+butPlayImgWidth/4, butPlayImgTop, butPlayImgWidth, butPlayImgWidth)];
    
    butPlayImg.image=[UIImage imageNamed:@"but-list-play"];
    [butPlay addSubview:butPlayImg];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10+butPlayWidth+10,10, viewWidth-10-butPlayWidth-10-10-imgWidth-10, 20)];
    title.text=music.title;
    
    title.font=FONT_14B;
    title.adjustsFontSizeToFitWidth=YES;
    title.lineBreakMode =NSLineBreakByTruncatingTail ;
    
    title.minimumScaleFactor=6.0;
    title.textColor=TEXT_COLOR;
    [view addSubview:title];

    
    
        
    float line2Top=33.0;
    
    UILabel *time=[[UILabel alloc] initWithFrame:CGRectMake(10+butPlayWidth+10, line2Top, 55, 20)];
        
    NSDateFormatter *dateAtter=[[NSDateFormatter alloc] init];
    [dateAtter setDateFormat:@"MM月dd日"];
    time.text=[dateAtter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[music.date integerValue]]];
    time.textColor=TEXT_COLOR;
    time.font=FONT_12;
    [view addSubview:time];
    
    UILabel *playSum=[[UILabel alloc] initWithFrame:CGRectMake(10+butPlayWidth+10+55, line2Top, viewWidth-10-butPlayWidth-10-60-10-10-imgWidth, 20)];
    playSum.text=[NSString stringWithFormat:@"[听]%@",[music.playSum stringValue]];
    playSum.textColor=TEXT_COLOR;
    playSum.font=FONT_12;
    [view addSubview:playSum];
    
    
    
    float line3top=55.0;
    float line3Width=viewWidth-10-butPlayWidth-10-10-imgWidth-10;
    float line3Left=10+butPlayWidth+10;
    float line3IconWidth=16.0;
    float line3IconTop=line3top+2.0;
    float line3LabelWidth=(line3Width-line3IconWidth*4)/4;
    
    UIImageView *downIcon=[[UIImageView alloc] initWithFrame:CGRectMake(line3Left, line3IconTop, line3IconWidth, line3IconWidth)];
    downIcon.image=[UIImage imageNamed:@"icon-download"];
    [view addSubview:downIcon];
    
    UILabel *downText=[[UILabel alloc] initWithFrame:CGRectMake(line3Left+line3IconWidth, line3top, line3LabelWidth, 20)];
    downText.text=[NSNumber friendlyNumber:music.downloadSum];
    downText.textColor=TEXT_COLOR;
    downText.font=FONT_10;
    [view addSubview:downText];

    UIImageView *commentsIcon=[[UIImageView alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*1, line3IconTop, line3IconWidth, line3IconWidth)];
    commentsIcon.image=[UIImage imageNamed:@"icon-comments"];
    [view addSubview:commentsIcon];
    
    UILabel *commentsText=[[UILabel alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*1+line3IconWidth, line3top, line3LabelWidth, 20)];
    commentsText.text=[NSNumber friendlyNumber:music.commentsSum];
    commentsText.textColor=TEXT_COLOR;
    commentsText.font=FONT_10;
    [view addSubview:commentsText];
    
    UIImageView *goodIcon=[[UIImageView alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*2, line3IconTop, line3IconWidth, line3IconWidth)];
    goodIcon.image=[UIImage imageNamed:@"icon-good"];
    [view addSubview:goodIcon];
    
    UILabel *goodText=[[UILabel alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*2+line3IconWidth, line3top, line3LabelWidth, 20)];
    goodText.text=[NSNumber friendlyNumber:music.goodSum];
    goodText.textColor=TEXT_COLOR;
    goodText.font=FONT_10;
    [view addSubview:goodText];
    
    UIImageView *shareIcon=[[UIImageView alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*3, line3IconTop, line3IconWidth, line3IconWidth)];
    shareIcon.image=[UIImage imageNamed:@"icon-share"];
    [view addSubview:shareIcon];
    
    UILabel *shareText=[[UILabel alloc] initWithFrame:CGRectMake(line3Left+(line3IconWidth+line3LabelWidth)*3+line3IconWidth, line3top, line3LabelWidth, 20)];
    shareText.text=[NSNumber friendlyNumber:music.shareSum];
    shareText.textColor=TEXT_COLOR;
    shareText.font=FONT_10;
    [view addSubview:shareText];

    
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-imgWidth-10, 10, imgWidth, imgWidth)];   
    //img.image=[UIImage imageWithContentsOfFile:music.icon];
    img.image=[UIImage imageWithContentsOfFile:[LOCAL_MUSIC_DIRECTORY stringByAppendingFormat:@"/%@", music.icon]];
    [view addSubview:img];
    UILabel *timeLength=[[UILabel alloc] initWithFrame:CGRectMake(viewWidth-imgWidth-10, 10+imgWidth, imgWidth, 14)];
    int _timeLength=[music.timeLength intValue];
    timeLength.text=[NSString stringWithFormat:@"%d分%@%d秒",(int)floor(_timeLength/60.0),_timeLength%60>9?@"":@"0",_timeLength%60];
    timeLength.textColor=TEXT_COLOR;
    timeLength.font=FONT_12;
    timeLength.textAlignment=NSTextAlignmentCenter;
    timeLength.adjustsFontSizeToFitWidth=YES;
    timeLength.numberOfLines=1;
    [view addSubview:timeLength];
    
    butView=[[UIView alloc] initWithFrame:CGRectMake(0, tableHeight-butViewHeight-10, viewWidth, butViewHeight)];
    butView.backgroundColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    
    [view addSubview:butView];
    
    
    float butTextWidth=30;
    float butIconLeft=(butWidth-butIconWidth-butTextWidth-5)/2;
    
    butDownload=[[UIButton alloc] initWithFrame:CGRectMake(0, 1, butWidth, butViewHeight-1)];
    butDownload.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butDownload.tag=row;
    [butDownload addTarget:self action:@selector(downloadParss:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:butDownload];
    UIImageView *butDownloadIcon=[[UIImageView alloc] initWithFrame:CGRectMake(butIconLeft, butSubTop, butIconWidth, butIconWidth)];
    butDownloadIcon.image=[UIImage imageNamed:@"icon-download"];
    [butDownload addSubview:butDownloadIcon];
    UILabel *butDownloadText=[[UILabel alloc] initWithFrame:CGRectMake(butIconLeft+butIconWidth, butSubTop, butTextWidth, butIconWidth)];
    butDownloadText.text=@"下载";
    butDownloadText.textColor=TEXT_COLOR_SHALLOW;
    butDownloadText.font=FONT_12;
    [butDownload addSubview:butDownloadText];
    
    
    butDel=[[UIButton alloc] initWithFrame:CGRectMake(0, 1, butWidth, butViewHeight-1)];
    butDel.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butDel.tag=row;
    [butDel addTarget:self action:@selector(deleteParss:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:butDel];
    UIImageView *butDelIcon=[[UIImageView alloc] initWithFrame:CGRectMake(butIconLeft, butSubTop, butIconWidth, butIconWidth)];
    butDelIcon.image=[UIImage imageNamed:@"icon-del"];
    [butDel addSubview:butDelIcon];
    UILabel *butDelText=[[UILabel alloc] initWithFrame:CGRectMake(butIconLeft+butIconWidth, butSubTop, butTextWidth, butIconWidth)];
    butDelText.text=@"删除";
    butDelText.textColor=TEXT_COLOR_SHALLOW;
    butDelText.font=FONT_12;
    [butDel addSubview:butDelText];
    
    switch (self.butFirst) {
        case 1:{
            butDel.hidden=YES;
            break;
        }
        case 2:{
            butDownload.hidden=YES;
            break;
        }
        default:
            break;
    }
    
    
    
    butTextWidth=20;
    butIconLeft=(butWidth-butIconWidth-butTextWidth-5)/2;
    UIButton *butCom=[[UIButton alloc] initWithFrame:CGRectMake((butWidth+1)*1, 1, butWidth, butViewHeight-1)];
    butCom.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butCom.tag=row;
    [butCom addTarget:self action:@selector(commentsParss:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:butCom];
    
    UIImageView *butComIcon=[[UIImageView alloc] initWithFrame:CGRectMake(butIconLeft, butSubTop, butIconWidth, butIconWidth)];
    butComIcon.image=[UIImage imageNamed:@"icon-comments"];
    [butCom addSubview:butComIcon];
    UILabel *butComText=[[UILabel alloc] initWithFrame:CGRectMake(butIconLeft+butIconWidth+3, butSubTop, butTextWidth, butIconWidth)];
    butComText.text=@"评";
    butComText.textColor=TEXT_COLOR_SHALLOW;
    butComText.font=FONT_12;
    [butCom addSubview:butComText];
    
    butTextWidth=20;
    butIconLeft=(butWidth-butIconWidth-butTextWidth-5)/2;
    UIButton *butGood=[[UIButton alloc] initWithFrame:CGRectMake((butWidth+1)*2, 1, butWidth, butViewHeight-1)];
    butGood.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butGood.tag=row;
    [butGood addTarget:self action:@selector(goodParss:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:butGood];
    
    UIImageView *butGoodIcon=[[UIImageView alloc] initWithFrame:CGRectMake(butIconLeft, butSubTop, butIconWidth, butIconWidth)];
    butGoodIcon.image=[UIImage imageNamed:@"icon-good"];
    [butGood addSubview:butGoodIcon];
    UILabel *butGoodText=[[UILabel alloc] initWithFrame:CGRectMake(butIconLeft+butIconWidth+3, butSubTop, butTextWidth, butIconWidth)];
    butGoodText.text=@"赞";
    butGoodText.textColor=TEXT_COLOR_SHALLOW;
    butGoodText.font=FONT_12;
    [butGood addSubview:butGoodText];
    
    butTextWidth=30;
    butIconLeft=(butWidth-butIconWidth-butTextWidth-5)/2;
    UIButton *butShare=[[UIButton alloc] initWithFrame:CGRectMake((butWidth+1)*3, 1, butWidth, butViewHeight-1)];
    butShare.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    butShare.tag=row;
    [butShare addTarget:self action:@selector(shareParss:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:butShare];
    
    UIImageView *butShareIcon=[[UIImageView alloc] initWithFrame:CGRectMake(butIconLeft, butSubTop, butIconWidth, butIconWidth)];
    butShareIcon.image=[UIImage imageNamed:@"icon-share"];
    [butShare addSubview:butShareIcon];
    UILabel *butShareText=[[UILabel alloc] initWithFrame:CGRectMake(butIconLeft+butIconWidth+3, butSubTop, butTextWidth, butIconWidth)];
    butShareText.text=@"分享";
    butShareText.textColor=TEXT_COLOR_SHALLOW;
    butShareText.font=FONT_12;
    [butShare addSubview:butShareText];
    
    //选中后的颜色又不发生改变，进行下面的设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

//返回总行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mediaArray count];
}
//返回每行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableHeight;
}

-(void)playParss:(UIButton *) paramSender{
    [self.delegate operationPlayParss:paramSender.tag];
}

-(void)deleteParss:(UIButton *) paramSender{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除已下载的文件吗？" delegate:self cancelButtonTitle:@"不了，谢谢" otherButtonTitles:@"确定删除", nil];
    
    alert.tag=1001;
    operationIndex=paramSender.tag;
    [alert show];
}

-(void)commentsParss:(UIButton *) paramSender{
    [self.delegate operationCommentsParss:paramSender.tag];
}

-(void)goodParss:(UIButton *) paramSender{
    [self.delegate operationGoodParss:paramSender.tag];
}
-(void)shareParss:(UIButton *) paramSender{
    [self.delegate operationShareParss:paramSender.tag];
}
-(void)downloadParss:(UIButton *) paramSender{
    Music *music=[self.mediaArray objectAtIndex:paramSender.tag];
    [music downloadMusic];
    music.downloadSum=[NSNumber numberWithInt:[music.downloadSum intValue]+1];
    [self.mediaArray replaceObjectAtIndex:paramSender.tag withObject:music];
    [_tableView reloadData];
    [self.delegate operationDownloadParss:paramSender.tag];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1001:  //删除按钮
            switch (buttonIndex) {
                case 1:{
                    [self.delegate operationDeleteParss:operationIndex];
                    break;
                }
                    
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
}

-(void)setOffset:(CGPoint)point{
    [_tableView setContentOffset:point animated:NO];
}

-(void)refreshView{
    [_tableView reloadData];
}

@end
