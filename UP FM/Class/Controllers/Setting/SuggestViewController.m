//
//  SuggestViewController.m
//  UP FM
//
//  Created by liubin on 15/1/28.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "SuggestViewController.h"
#import "SuggestSubmitViewController.h"


@implementation SuggestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     * 导航条设置
     */
    
    
    [self navBackShow];
    
    self.title=@"建议和投诉";
    
    
    viewTop=NAV_HEIGHT+STATUS_BAR_HEIGHT+20;
    viewHeight=WIN_HEIGHT-viewTop;
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, viewTop, WIN_WIDTH-20, 60)];
    title.text=@"感谢您的支持，我们会不定期随机抽取有效建议用户进行奖励";
    title.textColor=TEXT_COLOR;
    [self.view addSubview:title];
    title.numberOfLines=0;
    title.font=FONT_14;
    [self.view addSubview:title];
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, viewTop+60, WIN_WIDTH, 220)];
    mainView.backgroundColor=[UIColor whiteColor];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 35, 35)];
    titleLabel.text=@"标题";
    titleLabel.textColor=TEXT_COLOR;
    titleLabel.font=FONT_14;
    [mainView addSubview:titleLabel];
    
    _titleView=[[UITextField alloc] initWithFrame:CGRectMake(60, 10, WIN_WIDTH-70, 35)];
    _titleView.placeholder=@"请输入";
    _titleView.delegate=self;
    _titleView.font=FONT_14;
    _titleView.textColor=TEXT_COLOR;
    _titleView.returnKeyType=UIReturnKeyDone;
    _titleView.keyboardType=UIKeyboardTypeDefault;
    [mainView addSubview:_titleView];
    
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(20, 50, WIN_WIDTH-20, 1)];
    line1.backgroundColor=[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mainView addSubview:line1];
    
    
    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 62, 35, 20)];
    textLabel.text=@"正文";
    textLabel.textColor=TEXT_COLOR;
    textLabel.font=FONT_14;
    [mainView addSubview:textLabel];
    
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(55, 55, WIN_WIDTH-70, 150) textContainer:nil];
    _textView.text=@"请输入";
    _textView.delegate=self;
    _textView.backgroundColor=[UIColor clearColor];
    _textView.font=FONT_14;
    _textView.textColor=[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
    _textView.keyboardType=UIKeyboardTypeDefault;
    _textView.returnKeyType=UIReturnKeyDone;
    [mainView addSubview:_textView];
    [self.view addSubview:mainView];
    
    UIButton *butSubmit=[[UIButton alloc] initWithFrame:CGRectMake(0, viewTop+60+220+30, WIN_WIDTH, 50)];
    butSubmit.backgroundColor=[UIColor whiteColor];
    [butSubmit addTarget:self action:@selector(butSubmitParss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butSubmit];
    UILabel *butSubmitText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    butSubmitText.text=@"下一步";
    butSubmitText.font=FONT_18B;
    butSubmitText.textColor=RED_COLOR;
    butSubmitText.textAlignment=NSTextAlignmentCenter;
    [butSubmit addSubview:butSubmitText];
}

-(void) viewWillAppear:(BOOL)animated{
   
    
}

//UITextView限制字数
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = _textView.text.length;
    int Max=200;
    if (number > Max) {
        _textView.text = [_textView.text substringToIndex:Max];
        
    }
}
//UITextView 失去焦点
- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""] || [textView.text isEqualToString:@"请输入"]){
        _textView.text=@"请输入";
        _textView.textColor=[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
    }
}
//UITextView 获得焦点
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请输入"]){
        _textView.text=@"";
        _textView.textColor=TEXT_COLOR;
    }
}
//UITextView 键盘点击事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//UITextView 键盘点击事件
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [_titleView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)butSubmitParss{
    NSString *_titleText=_titleView.text;
    NSString *_textText=_textView.text;
    NSString *alertMsg=@"";
    NSString *alertTitle=@"提示";
    int _tag=0;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag=_tag;
    if([_titleText isEqualToString:@""]){
        alertMsg=@"请输入标题";
        [alert show];
    }else if([_textText isEqualToString:@""] || [_textText isEqualToString:@"请输入"]){
        alertMsg=@"请输入正文";
        [alert show];
    }else{
        SuggestSubmitViewController *_viewController = [[SuggestSubmitViewController alloc] init];
        _viewController.titleText=_titleText;
        _viewController.textText=_textText;
        [self pushViewRight:_viewController];
    }
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        [self goToBack];
    }
}

@end
