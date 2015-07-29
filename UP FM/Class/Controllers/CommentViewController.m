//
//  CommentViewController.m
//  UP FM
//
//  Created by liubin on 15/2/20.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "CommentViewController.h"
#import "MarqueeLabel.h"
#import "Functions.h"

@interface CommentViewController (){
    MarqueeLabel *titleView;
    float commentFieldViewHeight;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"所有评论";
    
    [self navBackShow];
    
    
    mainTop=NAV_HEIGHT+STATUS_BAR_HEIGHT;
    mainHeight=WIN_HEIGHT-mainTop;
    
    UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, mainTop,WIN_WIDTH,mainHeight)];
    mainView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    commentFieldViewHeight=50;
    float commentSubmitWidth=70.0;
    float commentFiledWidth=WIN_WIDTH-commentSubmitWidth-30;
    commentFieldView=[[UIView alloc] initWithFrame:CGRectMake(0, mainHeight-commentFieldViewHeight, WIN_WIDTH, commentFieldViewHeight)];
    [mainView addSubview:commentFieldView];
    UIView *commentFieldLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    commentFieldLine.backgroundColor=TEXT_BORDER_COLOR;
    [commentFieldView addSubview:commentFieldLine];
    UIView *commentBorder=[[UIView alloc] initWithFrame:CGRectMake(10, 10, commentFiledWidth, commentFieldViewHeight-20)];
    commentBorder.layer.borderColor=TEXT_BORDER_COLOR.CGColor;
    commentBorder.layer.borderWidth=1.0;
    commentBorder.layer.cornerRadius=3.0;
    [commentFieldView addSubview:commentBorder];
    
    commentField=[[UITextField alloc] initWithFrame:CGRectMake(5, 0, commentFiledWidth-10, commentFieldViewHeight-20)];

    commentField.returnKeyType = UIReturnKeyDone;
    commentField.clearButtonMode = YES;
    commentField.delegate = self;
    commentField.font=FONT_14;
    commentField.keyboardType=UIKeyboardAppearanceDefault;
    commentField.placeholder = @"请输入评论内容";
    [commentBorder addSubview:commentField];
    
    UIButton *commentSubmit=[[UIButton alloc] initWithFrame:CGRectMake(WIN_WIDTH-commentSubmitWidth-10, 10,commentSubmitWidth, commentFieldViewHeight-20)];
    commentSubmit.backgroundColor=RED_COLOR;
    commentSubmit.layer.cornerRadius=3.0;
    [commentSubmit addTarget:self action:@selector(subimtParss) forControlEvents:UIControlEventTouchUpInside];
    [commentFieldView addSubview:commentSubmit];
    UILabel *commentSubmitText=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, commentSubmitWidth, commentFieldViewHeight-20)];
    commentSubmitText.text=@"发布";
    commentSubmitText.textAlignment=NSTextAlignmentCenter;
    commentSubmitText.textColor=[UIColor whiteColor];
    commentSubmitText.font=FONT_14;
    [commentSubmit addSubview:commentSubmitText];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float height = keyboardRect.size.height;
    [commentFieldView setFrame:CGRectMake(0, mainHeight-commentFieldViewHeight-height, WIN_WIDTH, commentFieldViewHeight)];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [commentFieldView setFrame:CGRectMake(0, mainHeight-commentFieldViewHeight, WIN_WIDTH, commentFieldViewHeight)];
}
//输入框协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int max=50;
    if ([Functions stringLeng:toBeString] > max) {
        
        textField.text = [toBeString substringToIndex:max];
        
        return NO;
        
    }
    
    return YES;
}

-(void)subimtParss{
    [self goToBack];
}

@end
