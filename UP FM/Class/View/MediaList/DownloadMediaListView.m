//
//  DownloadMediaListView.m
//  UP FM
//
//  Created by liubin on 15/1/26.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "DownloadMediaListView.h"
#import "Music.h"
#import "Announcer.h"
#import "DownloadQueue.h"

@implementation DownloadMediaListView

@synthesize mediaArray;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        frameWidth=frame.size.width;
        viewWidth=frameWidth-20;
        tableHeight=120.0; //frameWidth*(210.0/DESING_WIDTH);
        downloadViewHeight=30.0;
        imgWidth=tableHeight-30-10-downloadViewHeight;
        
        butPlayWidth=(tableHeight-50)/2;
        butPlayImgWidth=butPlayWidth/4;
        butPlayImgTop=(butPlayWidth-butPlayImgWidth)/2;
        
        downloadButWidth=80.0;
        downloadIconWidth=22.0;
        downloadIconTop=(downloadViewHeight-1-downloadIconWidth)/2;
        
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
    
    
    DownloadQueue *music=[self.mediaArray objectAtIndex :row];
    
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
    
    butPlayImg.image=[UIImage imageNamed:@"but-list-play-no"];
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
    playSum.text=[NSString stringWithFormat:@"[听]%d",[music.playSum intValue]];
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
    goodText.font=FONT_12;
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
   
    [img setImageWithURL:[NSURL URLWithString:music.icon] placeholderImage:DEFAULT_IMAGE];
    
    [view addSubview:img];
    UILabel *timeLength=[[UILabel alloc] initWithFrame:CGRectMake(viewWidth-imgWidth-10, 10+imgWidth, imgWidth, 14)];
    int _timeLength=[music.timeLength intValue];
    timeLength.text=[NSString stringWithFormat:@"%d分%@%d秒",(int)floor(_timeLength/60.0),_timeLength%60>9?@"":@"0",_timeLength%60];
    timeLength.textColor=TEXT_COLOR;
    timeLength.font=FONT_10;
    timeLength.textAlignment=NSTextAlignmentCenter;
    [view addSubview:timeLength];
    
    downloadView=[[UIView alloc] initWithFrame:CGRectMake(0, tableHeight-downloadViewHeight-10, viewWidth, downloadViewHeight)];
    downloadView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [view addSubview:downloadView];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 1)];
    line.backgroundColor=[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [downloadView addSubview:line];
    
    float downloadButLeft=10+butPlayWidth+10;
    
    
    //正在下载
    UIButton *downloadBut=[[UIButton alloc] initWithFrame:CGRectMake(downloadButLeft, 0, downloadButWidth, downloadViewHeight-1)];
    downloadBut.hidden=YES;
    downloadBut.tag = DOWNLOAD_LIST_TAG + [music.mediaId integerValue];
    [downloadBut addTarget:self action:@selector(percentageButParss:) forControlEvents:UIControlEventTouchUpInside];
    [downloadView addSubview:downloadBut];
    UIImageView *downloadButIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, downloadIconTop, downloadIconWidth, downloadIconWidth)];
    downloadButIcon.image=[UIImage imageNamed:@"icon-download-on"];
    [downloadBut addSubview:downloadButIcon];
    UILabel *downloadButText=[[UILabel alloc] initWithFrame:CGRectMake(downloadIconWidth+2, 0, downloadButWidth-downloadIconWidth-2, downloadViewHeight-1)];
    downloadButText.text=@"正在下载";
    downloadButText.font=FONT_12;
    downloadButText.textColor=TEXT_COLOR_SHALLOW;
    [downloadBut addSubview:downloadButText];
    downloadPercentageHeight=10;
    downloadPercentageWidth=100.0;
    //下载进度
    UIView *downloadPercentage=[[UIView alloc] initWithFrame:CGRectMake(downloadButLeft+downloadButWidth, (downloadViewHeight-1-downloadPercentageHeight)/2, downloadPercentageWidth, downloadPercentageHeight)];
    downloadPercentage.backgroundColor=[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    downloadPercentage.tag = DOWNLOAD_LIST_TAG + 500 + [music.mediaId integerValue];
    downloadPercentage.hidden=YES;
    [downloadView addSubview:downloadPercentage];
    UIView *downloadCompleted=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, downloadPercentageHeight)];
    //下载完成条
    downloadCompleted.tag = DOWNLOAD_LIST_TAG + 1000 + [music.mediaId integerValue];
    downloadCompleted.backgroundColor=RED_COLOR;
    [downloadPercentage addSubview:downloadCompleted];
    //文件大小
    float downladSizeLeft=downloadButLeft+downloadButWidth+downloadPercentageWidth+5;
    UILabel *downladSize=[[UILabel alloc] initWithFrame:CGRectMake(downladSizeLeft, (downloadViewHeight-14)/2, viewWidth - downladSizeLeft-5, 14)];
    downladSize.font=FONT_12;
    downladSize.textColor=TEXT_COLOR_SHALLOW;
    downladSize.hidden=YES;
    downladSize.tag=DOWNLOAD_LIST_TAG + 1500 + [music.mediaId integerValue];
    [downloadView addSubview:downladSize];
    
    //等待下载
    UIButton *waitingBut=[[UIButton alloc] initWithFrame:CGRectMake(downloadButLeft, 0, downloadButWidth, downloadViewHeight-1)];
    waitingBut.tag = DOWNLOAD_LIST_TAG + 2000 + [music.mediaId integerValue];
    [downloadView addSubview:waitingBut];
    [waitingBut addTarget:self action:@selector(waitingButParss:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *waitingButIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, downloadIconTop, downloadIconWidth, downloadIconWidth)];
    waitingButIcon.image=[UIImage imageNamed:@"icon-waiting-on"];
    [waitingBut addSubview:waitingButIcon];
    UILabel *waitingButText=[[UILabel alloc] initWithFrame:CGRectMake(downloadIconWidth+2, 0, downloadButWidth-downloadIconWidth-2, downloadViewHeight-1)];
    waitingButText.text=@"等待下载";
    waitingButText.font=FONT_12;
    waitingButText.textColor=TEXT_COLOR_SHALLOW;
    [waitingBut addSubview:waitingButText];
    
    
    UIButton *suspendedBut=[[UIButton alloc] initWithFrame:CGRectMake(downloadButLeft, 0, downloadButWidth, downloadViewHeight-1)];
    suspendedBut.hidden=YES;
    suspendedBut.tag = DOWNLOAD_LIST_TAG + 3000 + [music.mediaId integerValue];
    [suspendedBut addTarget:self action:@selector(suspendedButParss:) forControlEvents:UIControlEventTouchUpInside];
    [downloadView addSubview:suspendedBut];
    UIImageView *suspendedButIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, downloadIconTop, downloadIconWidth, downloadIconWidth)];
    suspendedButIcon.image=[UIImage imageNamed:@"icon-suspended-on"];
    [suspendedBut addSubview:suspendedButIcon];
    UILabel *suspendedButText=[[UILabel alloc] initWithFrame:CGRectMake(downloadIconWidth+2, 0, downloadButWidth-downloadIconWidth-2, downloadViewHeight-1)];
    suspendedButText.text=@"暂停下载";
    suspendedButText.font=FONT_12;
    suspendedButText.textColor=TEXT_COLOR_SHALLOW;
    [suspendedBut addSubview:suspendedButText];
    
    //成功后
    UILabel *successText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, downloadViewHeight-1)];
    successText.text=@"下载完成，数据处理中...";
    successText.textColor=TEXT_COLOR_SHALLOW;
    successText.font=FONT_14;
    successText.textAlignment=NSTextAlignmentCenter;
    successText.hidden=YES;
    successText.tag=DOWNLOAD_LIST_TAG + 5000 + [music.mediaId integerValue];
    [downloadView addSubview:successText];
    
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
//    [self.delegate downloadPlayParss:(int)paramSender.tag];
}

//下载
-(void)waitingButParss:(UIButton *) paramSender{
    NSInteger mediaIdInt=paramSender.tag-DOWNLOAD_LIST_TAG - 2000;
    Music *music=[[Music alloc] init];
    music.mediaId=[NSNumber numberWithInteger:mediaIdInt];
    [self.delegate downloadResume:music];
    paramSender.hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + mediaIdInt]).hidden=NO;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 3000 + mediaIdInt]).hidden=YES;
}
//继续
-(void)suspendedButParss:(UIButton *) paramSender{
    NSInteger mediaIdInt=paramSender.tag-DOWNLOAD_LIST_TAG - 3000;
    Music *music=[[Music alloc] init];
    music.mediaId=[NSNumber numberWithInteger:mediaIdInt];
    [self.delegate downloadResume:music];
    paramSender.hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + mediaIdInt]).hidden=NO;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 2000 + mediaIdInt]).hidden=YES;
    
}
//暂停
-(void)percentageButParss:(UIButton *) paramSender{
    NSInteger mediaIdInt=paramSender.tag-DOWNLOAD_LIST_TAG;
    Music *music=[[Music alloc] init];
    music.mediaId=[NSNumber numberWithInteger:mediaIdInt];
    [self.delegate downloadPause:music];
    paramSender.hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 2000 + mediaIdInt]).hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 3000 + mediaIdInt]).hidden=NO;
}

-(void)refreshView{
    [_tableView reloadData];
}
#pragma mark 通知
- (void)DLV_Downloading:(DownloadQueue *)downloadingElement
{
    
    NSInteger mediaIdInt=[downloadingElement.mediaId integerValue];

    float p=(float)[downloadingElement.totalBytesRead doubleValue] / [downloadingElement.totalBytesExpectedToRead doubleValue]*downloadPercentageWidth;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + mediaIdInt]).hidden=NO;
    ((UIView *)[self viewWithTag:DOWNLOAD_LIST_TAG + 500 + mediaIdInt]).hidden=NO;
    [((UIView *)[self viewWithTag:DOWNLOAD_LIST_TAG + 1000 + mediaIdInt]) setFrame:CGRectMake(0, 0, p, downloadPercentageHeight)];
    UILabel *sizeText=(UILabel *)[self viewWithTag:DOWNLOAD_LIST_TAG + 1500 + mediaIdInt];
    sizeText.hidden=NO;
    sizeText.text=[NSString stringWithFormat:@"%.2fM",[downloadingElement.totalBytesExpectedToRead doubleValue]/1024.0/1024];
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 2000 + mediaIdInt]).hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 3000 + mediaIdInt]).hidden=YES;
}

- (void)DLV_DownloadedSuccess:(Music *)downloadedElement{
    NSInteger mediaIdInt=[downloadedElement.mediaId integerValue];
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + mediaIdInt]).hidden=YES;
    ((UIView *)[self viewWithTag:DOWNLOAD_LIST_TAG + 500 + mediaIdInt]).hidden=YES;
    ((UILabel *)[self viewWithTag:DOWNLOAD_LIST_TAG + 1500 + mediaIdInt]).hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 2000 + mediaIdInt]).hidden=YES;
    ((UIButton *)[self viewWithTag:DOWNLOAD_LIST_TAG + 3000 + mediaIdInt]).hidden=YES;
    ((UILabel *)[self viewWithTag:DOWNLOAD_LIST_TAG + 5000 + mediaIdInt]).hidden=NO;
    
    [_tableView reloadData];
}

- (void)DLV_DeleteSuccess:(Music *)deleteSong{
//    [_tableView reloadData];
}

- (void)DLV_Pause:(Music *)pauseSong{

}
@end
