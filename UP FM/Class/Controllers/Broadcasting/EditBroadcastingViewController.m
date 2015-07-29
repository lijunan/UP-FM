//
//  EditBroadcastingViewController.m
//  UP FM
//
//  Created by liubin on 15/3/2.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "EditBroadcastingViewController.h"
#import "Functions.h"
#import "VPImageCropperViewController.h"


@interface EditBroadcastingViewController ()<VPImageCropperDelegate>

@end

@implementation EditBroadcastingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _broadcasting=[Broadcasting sharedInstance];
    _currentUser=[CurrentUser sharedInstance];
    self.title=self.creation?@"开通我的电台":@"编辑我的电台";
    
    //设置导航左侧返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //设置导航右侧完成按钮
    UIButton *finishButton=[Functions initBarRightButton:BarButtonTypeFinish];
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    //主体
    mainTop=0;
    mainHeight=WIN_HEIGHT-mainTop;
    mainContentHeight=0;
    UIScrollView *mainView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, mainTop, WIN_WIDTH, mainHeight)];
    mainView.delegate=self;
    mainView.bounces=YES;
    mainView.scrollEnabled=YES;
    mainView.showsHorizontalScrollIndicator=NO;
    mainView.showsVerticalScrollIndicator=NO;
    mainView.maximumZoomScale=1;
    mainView.minimumZoomScale=1;
    [self.view addSubview:mainView];
    
    float coverHeight=WIN_WIDTH*(504/DESING_WIDTH);
    UIView *coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, coverHeight)];
    coverView.layer.masksToBounds=YES;
    [mainView addSubview:coverView];
    coverImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, COVER_WIDTH, COVER_HEIGHT)];
    if(_broadcasting.cover){
        coverImage.image=[UIImage imageWithContentsOfFile:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",_broadcasting.cover]];
    }else{
        coverImage.image=DEFAULT_COVER;
    }
    
    [coverView addSubview:coverImage];
    float addCoverButtonWidth=50;
    UIButton *addCoverButton=[[UIButton alloc] initWithFrame:CGRectMake((WIN_WIDTH-addCoverButtonWidth)/2, (coverHeight-addCoverButtonWidth)/2-10, addCoverButtonWidth, addCoverButtonWidth)];
    addCoverButton.backgroundColor=RED_COLOR;
    addCoverButton.layer.masksToBounds=NO;
    addCoverButton.layer.cornerRadius=addCoverButtonWidth/2;
    addCoverButton.tag=photoTypeCover;
    addCoverButton.alpha=0.8;
    [addCoverButton addTarget:self action:@selector(photoButParss:) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:addCoverButton];
    float addCoverIconWidth=35;
    UIImageView *addCoverIcon=[[UIImageView alloc] initWithFrame:CGRectMake((addCoverButtonWidth-addCoverIconWidth)/2, (addCoverButtonWidth-addCoverIconWidth)/2, addCoverIconWidth, addCoverIconWidth)];
    addCoverIcon.image=[UIImage imageNamed:@"icon-add"];
    [addCoverButton addSubview:addCoverIcon];
    UILabel *addCoverText=[[UILabel alloc] initWithFrame:CGRectMake(0, (coverHeight-addCoverButtonWidth)/2+addCoverButtonWidth, WIN_WIDTH, 20)];
    addCoverText.text=@"上传封面图片";
    addCoverText.textColor=[UIColor whiteColor];
    addCoverText.font=FONT_14;
    addCoverText.textAlignment=NSTextAlignmentCenter;
    [coverView addSubview:addCoverText];
    
    
    float inputViewTop=coverHeight+20;
    float inputViewHeight=0;
    UIView *inputView=[[UIView alloc] init];
    inputView.backgroundColor=[UIColor whiteColor];
    [mainView addSubview:inputView];
    
    inputViewHeight=0;
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    line1.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line1];
    inputViewHeight+=1;
    
    float tabLeft=10;
    float tabWidth=70;
    float inputLeft=tabLeft+tabWidth;
    float inputWidth=WIN_WIDTH-inputLeft-10;
    float tabHeight=40;
    
    //电台名称
    UILabel *titleTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    
    titleTab.text=@"电台名称";
    titleTab.textColor=TEXT_COLOR_SHALLOW;
    titleTab.font=FONT_14;
    [inputView addSubview:titleTab];
    titleField=[[UITextField alloc] initWithFrame:CGRectMake(inputLeft, inputViewHeight, inputWidth, tabHeight)];
    titleField.delegate=self;
    titleField.returnKeyType=UIReturnKeyDone;
    titleField.keyboardType=UIKeyboardAppearanceDefault;
    titleField.clearButtonMode = YES;
    titleField.font=FONT_14;
    titleField.textColor=TEXT_COLOR;
    titleField.placeholder = @"请输入";
    if(_broadcasting.title){
        titleField.text=_broadcasting.title;
    }
    [inputView addSubview:titleField];
    inputViewHeight+=tabHeight;
    
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line2.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line2];
    inputViewHeight+=1;
    
    //类别
    UILabel *columnTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    columnTab.text=@"类别";
    columnTab.textColor=TEXT_COLOR_SHALLOW;
    columnTab.font=FONT_14;
    [inputView addSubview:columnTab];
    UIButton *columnButton=[[UIButton alloc] initWithFrame:CGRectMake(inputLeft,inputViewHeight, inputWidth, tabHeight)];
    [columnButton addTarget:self action:@selector(columnButtonParss) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:columnButton];
    columnLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, inputWidth-30, tabHeight)];
    columnLabel.font=FONT_14;
    columnLabel.textColor=TEXT_COLOR;
    [columnButton addSubview:columnLabel];
    float columnButtonIconWidth=12.0;
    UIImageView *columnButtonIcon=[[UIImageView alloc] initWithFrame:CGRectMake(inputWidth-20, (tabHeight-columnButtonIconWidth)/2, columnButtonIconWidth, columnButtonIconWidth)];
    columnButtonIcon.image=[UIImage imageNamed:@"icon-arrows-right25"];
    [columnButton addSubview:columnButtonIcon];
    inputViewHeight+=tabHeight;
    UIView *line3=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line3.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line3];
    
    //icon
    float iconWidth=80;
    UILabel *iconLabel=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    iconLabel.text=@"图标";
    iconLabel.textColor=TEXT_COLOR_SHALLOW;
    iconLabel.font=FONT_14;
    [inputView addSubview:iconLabel];
    iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(inputLeft, inputViewHeight+10, iconWidth, iconWidth)];
    if(_broadcasting.icon){
        iconImage.image=[UIImage imageWithContentsOfFile:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",_broadcasting.icon]];
        
    }else{
        iconImage.image=DEFAULT_IMAGE;
    }
    [inputView addSubview:iconImage];
    float iconAddButtonWidth=30;

    UIButton *iconAddButton=[[UIButton alloc] initWithFrame:CGRectMake(inputLeft+iconWidth-20, inputViewHeight+iconWidth-10, iconAddButtonWidth, iconAddButtonWidth)];
    iconAddButton.layer.cornerRadius=iconAddButtonWidth/2;
    iconAddButton.backgroundColor=RED_COLOR;
    iconAddButton.tag=photoTypeIcon;
    iconAddButton.alpha=0.8;
    [iconAddButton addTarget:self action:@selector(photoButParss:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:iconAddButton];
    UIImageView *iconAddImage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, iconAddButtonWidth-10, iconAddButtonWidth-10)];
    iconAddImage.image=[UIImage imageNamed:@"icon-add"];
    [iconAddButton addSubview:iconAddImage];
    inputViewHeight+=iconWidth+30;
    UIView *line4=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line4.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line4];
    
    //标签
    UILabel *tagTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    
    tagTab.text=@"标签";
    tagTab.textColor=TEXT_COLOR_SHALLOW;
    tagTab.font=FONT_14;
    [inputView addSubview:tagTab];
    tagField=[[UITextField alloc] initWithFrame:CGRectMake(inputLeft, inputViewHeight, inputWidth, tabHeight)];
    tagField.delegate=self;
    tagField.returnKeyType=UIReturnKeyDone;
    tagField.keyboardType=UIKeyboardAppearanceDefault;
    tagField.clearButtonMode = YES;
    tagField.font=FONT_14;
    tagField.textColor=TEXT_COLOR;
    tagField.placeholder = @"请输入";
    if(_broadcasting.mediaTag){
        tagField.text=_broadcasting.mediaTag;
    }
    [inputView addSubview:tagField];
    inputViewHeight+=tabHeight;
    
    UIView *line5=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line5.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line5];
    inputViewHeight+=1;
    
    //简介
    float textHeight=100;
    UILabel *introductionTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    
    introductionTab.text=@"简介";
    introductionTab.textColor=TEXT_COLOR_SHALLOW;
    introductionTab.font=FONT_14;
    [inputView addSubview:introductionTab];
    introductionField=[[UITextView alloc] initWithFrame:CGRectMake(inputLeft, inputViewHeight, inputWidth, textHeight)];
    introductionField.delegate=self;
    introductionField.returnKeyType=UIReturnKeyDone;
    introductionField.keyboardType=UIKeyboardAppearanceDefault;
    introductionField.font=FONT_14;
    introductionField.textColor=TEXT_COLOR;
    if(_broadcasting.introduction){
        introductionField.text=_broadcasting.introduction;
    }
    [inputView addSubview:introductionField];
    inputViewHeight+=textHeight;
    
    UIView *line6=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line6.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line6];
    inputViewHeight+=1;
    
    //公告
    UILabel *noticeTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    
    noticeTab.text=@"公告";
    noticeTab.textColor=TEXT_COLOR_SHALLOW;
    noticeTab.font=FONT_14;
    [inputView addSubview:noticeTab];
    noticeField=[[UITextView alloc] initWithFrame:CGRectMake(inputLeft, inputViewHeight, inputWidth, textHeight)];
    noticeField.delegate=self;
    noticeField.returnKeyType=UIReturnKeyDone;
    noticeField.keyboardType=UIKeyboardAppearanceDefault;
    noticeField.font=FONT_14;
    noticeField.textColor=TEXT_COLOR;
    if(_broadcasting.notice){
        noticeField.text=_broadcasting.notice;
    }
    [inputView addSubview:noticeField];
    inputViewHeight+=textHeight;
    
    UIView *line7=[[UIView alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, WIN_WIDTH-tabLeft, 1)];
    line7.backgroundColor=TEXT_BORDER_COLOR;
    [inputView addSubview:line7];
    inputViewHeight+=1;
    
    //语种
    UILabel *languagesTab=[[UILabel alloc] initWithFrame:CGRectMake(tabLeft, inputViewHeight, tabWidth, tabHeight)];
    languagesTab.text=@"语种";
    languagesTab.textColor=TEXT_COLOR_SHALLOW;
    languagesTab.font=FONT_14;
    [inputView addSubview:languagesTab];
    UIButton *languagesButton=[[UIButton alloc] initWithFrame:CGRectMake(inputLeft,inputViewHeight, inputWidth, tabHeight)];
    [languagesButton addTarget:self action:@selector(languagesButtonParss) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:languagesButton];
    languagesLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, inputWidth-30, tabHeight)];
    languagesLabel.font=FONT_14;
    languagesLabel.textColor=TEXT_COLOR;
    
    [languagesButton addSubview:languagesLabel];
    UIImageView *languagesButtonIcon=[[UIImageView alloc] initWithFrame:CGRectMake(inputWidth-20, (tabHeight-columnButtonIconWidth)/2, columnButtonIconWidth, columnButtonIconWidth)];
    languagesButtonIcon.image=[UIImage imageNamed:@"icon-arrows-right25"];
    [languagesButton addSubview:languagesButtonIcon];
    inputViewHeight+=tabHeight;

    
    [inputView setFrame:CGRectMake(0, inputViewTop, WIN_WIDTH, inputViewHeight)];
    mainContentHeight=inputViewTop+inputViewHeight;
    mainView.contentSize=CGSizeMake(WIN_WIDTH, mainContentHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self setColumnChecked];
    [self setLanguagesChecked];
}


//完成
-(void)finishAction{
    NSString *titleText=titleField.text;
    if([titleText isEmpty]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"要输入一个标题哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        _broadcasting.title=titleText;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"编辑完成" message:@"是否同步更新到服务器？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的，同步到服务器",@"不了，先保存在手机", nil];
        alert.tag=9001;
        [alert show];
    }
    
    
}
-(void)loadColumnArray{

    NSString *url=[UrlAPI getColumnList];
    columnArray=[NSMutableArray arrayWithCapacity:0];
    NSDictionary *parameters = @{@"top":[NSNumber numberWithInt:0]};
    [UPHTTPTools post:url params:parameters success:^(id responseObj) {
        NSNumber *code=[responseObj objectForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSArray *tempArray=[responseObj objectForKey:@"content"];
            for(NSDictionary *dict in tempArray){
                NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"column_name"],@"value",[dict objectForKey:@"column_id"],@"key", nil];
                [columnArray addObject:d];
            }
            
            if(_broadcasting.column){
                columnCheckedArray=[NSMutableArray arrayWithCapacity:0];
                [columnCheckedArray addObjectsFromArray:_broadcasting.column];
                [self setColumnChecked];
            }
            
        }
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"数据加载失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}
//设置栏目信息
-(void)setColumnChecked{
    if(!columnArray){
        [self loadColumnArray];
    }else{
        NSMutableArray *columnStringArray=[NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dict in columnArray){
            for(NSNumber *cid in columnCheckedArray){
                if([[dict objectForKey:@"key"] isEqualToNumber:cid]){
                    [columnStringArray addObject:[dict objectForKey:@"value"]];
                }
            }
            
        }
        columnLabel.text=[columnStringArray componentsJoinedByString:@","];
    }
    
}
//选择类别
-(void)columnButtonParss{
    if(!columnCheckedArray){
        columnCheckedArray=[NSMutableArray arrayWithCapacity:0];
    }
    if(!columnArray){
        [SVProgressHUD showWithStatus:@"加载数据中..."];
        NSString *url=[UrlAPI getColumnList];
        columnArray=[NSMutableArray arrayWithCapacity:0];
        NSDictionary *parameters = @{@"top":[NSNumber numberWithInt:0]};
        [UPHTTPTools post:url params:parameters success:^(id responseObj) {
            NSNumber *code=[responseObj objectForKey:@"code"];
            [SVProgressHUD dismiss];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]]){
                NSArray *tempArray=[responseObj objectForKey:@"content"];
                for(NSDictionary *dict in tempArray){
                    NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"column_name"],@"value",[dict objectForKey:@"column_id"],@"key", nil];
                    [columnArray addObject:d];
                }
                
                if(_broadcasting.column){
                    columnCheckedArray=[NSMutableArray arrayWithCapacity:0];
                    [columnCheckedArray addObjectsFromArray:_broadcasting.column];
                    [self setColumnChecked];
                }
                TableCheckboxViewController *_viewController=[[TableCheckboxViewController alloc] init];
                _viewController.checkboxArray=columnArray;
                _viewController.currentArray=columnCheckedArray;
                _viewController.signal=101;
                [self pushViewRight:_viewController];
            }else{
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"数据加载失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"数据加载失败，请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
        TableCheckboxViewController *_viewController=[[TableCheckboxViewController alloc] init];
        _viewController.checkboxArray=columnArray;
        _viewController.currentArray=columnCheckedArray;
        _viewController.signal=101;
        [self pushViewRight:_viewController];
    }
    
}

//加载语种信息
-(void)loadLanguagesArray{
    languagesArray=[NSMutableArray arrayWithCapacity:0];
    NSArray *tempArray=LANGUAGES_ARR;
    NSInteger len=tempArray.count;
    for(NSInteger i=0;i<len;i++){
        NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys:[tempArray objectAtIndex:i],@"value",[NSNumber numberWithInteger:i],@"key", nil];
        [languagesArray addObject:d];
    }
    languagesCheckedArray=[NSMutableArray arrayWithCapacity:0];
    [languagesCheckedArray addObjectsFromArray:_broadcasting.languages];

    [self setLanguagesChecked];
    
    
}
//设语种目信息
-(void)setLanguagesChecked{
    if(!languagesArray){
        [self loadLanguagesArray];
    }else{
        NSMutableArray *languagesStringArray=[NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dict in languagesArray){
            for(NSNumber *cid in languagesCheckedArray                           ){
                if([[dict objectForKey:@"key"] isEqualToNumber:cid]){
                    [languagesStringArray addObject:[dict objectForKey:@"value"]];
                }
            }
            
        }
        languagesLabel.text=[languagesStringArray componentsJoinedByString:@","];
    }
    
}
-(void)languagesButtonParss{
    TableCheckboxViewController *_viewController=[[TableCheckboxViewController alloc] init];
    _viewController.checkboxArray=languagesArray;
    _viewController.currentArray=languagesCheckedArray;
    _viewController.signal=102;
    [self pushViewRight:_viewController];
}
//复选返回协议
-(void)tableCheckboxGoBack:(NSArray *)checkedArray signal:(NSInteger) signal{
    switch (signal) {
        case 101:{  //栏目选择
            columnCheckedArray=[NSMutableArray arrayWithCapacity:0];
            [columnCheckedArray addObjectsFromArray:checkedArray];
            break;
        }
        case 102:{  //语种选择
            languagesCheckedArray=[NSMutableArray arrayWithCapacity:0];
            [languagesCheckedArray addObjectsFromArray:checkedArray];
            break;
        }
        default:
            break;
    }
    
    
}

//返回事件
- (void)backAction:(id)sender{
    
    if(_broadcasting.open){
        [self goToBack];
    }else{
        [self goToBack:2];
    }
}
//alert协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 9001: { //完成
            _broadcasting.column=[NSArray arrayWithArray:columnCheckedArray];
            _broadcasting.mediaTag=tagField.text;
            _broadcasting.introduction=introductionField.text;
            _broadcasting.notice=noticeField.text;
            _broadcasting.languages=languagesCheckedArray;
            switch (buttonIndex) {
                case 1:{    //同步到服务器
                    _broadcasting.open=YES;
                    [_broadcasting save];
                    [self goToBack];
                    break;
                }
                case 2:{    //保存在手机
                    _broadcasting.open=YES;
                    [_broadcasting save];
                    [self goToBack];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}






/**
 * 图片处理 start
 */
-(void)photoButParss:(UIButton *) paramSender{
    #pragma mark - 照片
    _photoType=(int)paramSender.tag;
    [self updateIcon];
}
- (void)updateIcon{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从相册选择", @"拍照", nil];
    [actionSheet showInView:self.view];
}
#pragma mark 选择
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //从相册选择
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     
                                 }];
            }else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                   message:@"这台设备没有可选择的图库"
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                [alert show];
            }
            break;
            
        case 1:
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                   message:@"这台设备没有摄像头."
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                [alert show];
            }
            break;
            
        default:
            break;
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self saveImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
        float imgWidth=0;
        float imgHeight=0;
        switch (_photoType) {
            case photoTypeIcon:{
                imgWidth=ICON_WIDTH;
                imgHeight=ICON_HEIGHT;
                break;
            }
            case photoTypeCover:{
                imgWidth=COVER_WIDTH;
                imgHeight=COVER_HEIGHT;
                break;
            }
            default:
                break;
        }

    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake((WIN_WIDTH-imgWidth)/2, (WIN_HEIGHT-imgHeight)/2, imgWidth, imgHeight) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            
        }];
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < WIN_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = WIN_WIDTH;
        btWidth = sourceImage.size.width * (WIN_WIDTH / sourceImage.size.height);
    } else {
        btWidth = WIN_WIDTH;
        btHeight = sourceImage.size.height * (WIN_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)saveImage:(UIImage *)image {
    NSString *fileName;
    UIImageView *imgview;
    switch (_photoType) {
        case photoTypeIcon:{
            fileName=[NSString stringWithFormat:@"%@_icon.jpg",_currentUser.uId];
            imgview=iconImage;
            
            break;
        }
        case photoTypeCover:{
            fileName=[NSString stringWithFormat:@"%@_cover.jpg",_currentUser.uId];
            imgview=coverImage;
            
            break;
        }
        default:
            break;
    }
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //保存到目录
    NSString *imageFilePath = [DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",fileName];
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //写入文件
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    switch (_photoType) {
        case photoTypeIcon:{
            iconImage.image=selfPhoto;
            _broadcasting.icon=fileName;
            [_broadcasting save];
            break;
        }
        case photoTypeCover:{
            coverImage.image=selfPhoto;
            _broadcasting.cover=fileName;
            [_broadcasting save];
            break;
        }
        default:
            break;
    }
    
}
/**
 * 图片处理 end
 */
@end
