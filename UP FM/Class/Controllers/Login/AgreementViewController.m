//
//  AgreementViewController.m
//  UP FM
//
//  Created by liubin on 15/2/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "AgreementViewController.h"
#import "Functions.h"

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *agreementArr=[NSArray arrayWithObjects:
                           @"1、用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"2、用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"3、用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"4、用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议,用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"5、用户协议用户协议用户,协议用户协议用户协议用,户协议用户协议",
                           @"6、用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"7、用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           @"8、用户协议用户协议用户协议用户协议用户协议用户协,议用户协议用户协议用户协议用户协议用户协议用户协议用户协议用户协议",
                           nil];
    
    
    /*
     * 导航条设置
     */
    self.title=@"用户协议";
    
    [self navBackShow];
    
    
    viewTop=0.0;//NAV_HEIGHT+STATUS_BAR_HEIGHT;
    viewHeight=WIN_HEIGHT-viewTop;;
    

    UIScrollView *_mainView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,viewTop , WIN_WIDTH, viewHeight)];
    _mainView.delegate=self;
    _mainView.backgroundColor=[UIColor clearColor];
    _mainView.pagingEnabled=YES;
    _mainView.showsVerticalScrollIndicator=YES;
    _mainView.showsHorizontalScrollIndicator=NO;
    _mainView.bounces=YES;
    [self.view addSubview:_mainView];
    
    float contentHeight=0;
    float contentMargin=20.0;
    
    int len=(int)agreementArr.count;
    for(int i=0;i<len;i++){
        NSString *_text=[agreementArr objectAtIndex:i];
        float h=[Functions getTextHeight:_text :CGSizeMake(WIN_WIDTH-contentMargin*2, 1000) :FONT_14];
        contentHeight+=contentMargin;
        UILabel *textView=[[UILabel alloc] initWithFrame:CGRectMake(contentMargin, contentHeight, WIN_WIDTH-contentMargin*2, h)];
        textView.text=_text;
        textView.font=FONT_14;
        textView.textColor=TEXT_COLOR;
        textView.numberOfLines=0;
        [_mainView addSubview:textView];
        contentHeight+=h;
    }
    contentHeight+=contentMargin;
    _mainView.contentSize=CGSizeMake(WIN_WIDTH, contentHeight);

    
    
}


@end
