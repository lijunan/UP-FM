//
//  DefinedShutdownTimeViewController.m
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "ShutdownDefinedTimeViewController.h"
#import "UPFMBase.h"



@implementation ShutdownDefinedTimeViewController

@synthesize textView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    
    //加载导航右侧完成按钮
    UIButton *butComplete=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
    UILabel *butCompleteText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, NAV_HEIGHT)];
    butCompleteText.text=@"完成";
    [butComplete addTarget:self action:@selector(setComplete) forControlEvents:UIControlEventTouchUpInside];
    [butComplete addSubview:butCompleteText];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:butComplete];
    
    [self navBackShow];
    
    self.title=@"自定义时间";
    
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT+30;
    viewHeight=WIN_HEIGHT-viewTop;
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, viewTop, WIN_WIDTH-20, 20)];
    title.text=@"请设置时间";
    title.textColor=TEXT_COLOR;
    [self.view addSubview:title];
    UIView *inputView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop+30, WIN_WIDTH, 50)];
    inputView.backgroundColor=[UIColor whiteColor];
    self.textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 100, 30) textContainer:nil];
    self.textView.text=[[NSUserDefaults standardUserDefaults] stringForKey:@"definedShutdownTime"];
    self.textView.layer.borderColor=TEXT_BORDER_COLOR.CGColor;
    self.textView.layer.borderWidth=1.0;
    self.textView.layer.cornerRadius=3.0;
    self.textView.delegate=self;
    self.textView.textColor=TEXT_COLOR;
    self.textView.returnKeyType=UIReturnKeyDone;
    self.textView.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    
    
    [inputView addSubview:self.textView];
    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(115, 10, 50, 30)];
    textLabel.text=@"分钟后";
    textLabel.textColor=TEXT_COLOR;
    textLabel.font=FONT_14;
    [inputView addSubview:textLabel];
    
    [self.view addSubview:inputView];
    
    
}


//限制字数
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = self.textView.text.length;
    int Max=3;
    if (number > Max) {
        self.textView.text = [self.textView.text substringToIndex:Max];
        
    }
}

//设置回车键
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark 设置完成
-(void)setComplete{
    
    [[NSUserDefaults standardUserDefaults] setInteger:[self.textView.text integerValue] forKey:@"definedShutdownTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self goToBack];
}

@end
