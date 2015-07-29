//
//  ViewStyle.h
//  UP FM
//
//  Created by liubin on 15-1-25.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#ifndef UP_FM_ViewStyle_h
#define UP_FM_ViewStyle_h

//评论类型
typedef enum {
    music = 0,
    album
} CommentType;

//时间类型
typedef enum {
    ttWeek = 0,
    ttMonth,
    ttQuarter,
    ttYear,
    ttAll
} TimeType;

//删除
typedef enum{
    delOrder=0
}DelMediaType;


//媒体类型
typedef enum{
    mediaTypeMusic = 0, //音乐
    mediaTypeDownloadMusic, //已下载的音乐
    mediaTypeRecord,    //我的录音
    mediaTypeAlbum,     //专辑
    mediaBroadcasting   //我的专辑
}MediaType;

//导航右按钮类型
typedef enum{
    BarButtonTypeFinish=0,
    BarButtonTypeFinishWhite
}BarButtonType;

//选择上传图片类型
typedef enum{
    photoTypeIcon=1001,
    photoTypeCover=1002
}PhotoUpdateType;
/*
 * 尺寸
 */

//屏幕宽
#pragma mark 屏幕宽
#define WIN_WIDTH self.view.frame.size.width
//屏幕高
#define WIN_HEIGHT self.view.frame.size.height
//设计高
#define DESING_WIDTH 750.0

//设置列表高
#define SETTING_HEIGHT 45.0

//icon尺寸
#define ICON_WIDTH 256.0
#define ICON_HEIGHT 256.0
//封面图尺寸
#define COVER_WIDTH WIN_WIDTH
#define COVER_HEIGHT WIN_WIDTH


/*
 * 颜色
 */
//粉红色
#define RED_COLOR [UIColor colorWithRed:213/255.0 green:26/255.0 blue:125/255.0 alpha:1]
//背景色
#define BACK_COLOR [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1]

//底部边框色
#define FOOT_BORDER_COLOR [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1]

//文字色深
#define TEXT_COLOR [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1]
//文字色浅
#define TEXT_COLOR_SHALLOW [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1]
//输入框颜色
#define TEXT_BORDER_COLOR [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]

//设置列表文字
#define SETTING_FONT [UIFont systemFontOfSize:14.0f]

//10px文字
#define FONT_10 [UIFont systemFontOfSize:10.0f]
#define FONT_10B [UIFont boldSystemFontOfSize:10.0f]
//12px文字
#define FONT_12 [UIFont systemFontOfSize:12.0f]
#define FONT_12B [UIFont boldSystemFontOfSize:12.0f]
//14px文字
#define FONT_14 [UIFont systemFontOfSize:14.0f]
#define FONT_14B [UIFont boldSystemFontOfSize:14.0f]
//16px文字
#define FONT_16 [UIFont systemFontOfSize:16.0f]
#define FONT_16B [UIFont boldSystemFontOfSize:16.0f]
//18px文字
#define FONT_18 [UIFont systemFontOfSize:18.0f]
#define FONT_18B [UIFont boldSystemFontOfSize:18.0f]


/**
 * 页码设置
 **/
// 每页显示数量
#define PAGE_SUM 10


/**
 * 类型数组
 **/
//节目语言 0国语1粤语2英语3日语4韩语5小语种
#define LANGUAGES_ARR [NSArray arrayWithObjects:@"国语",@"粤语",@"英语",@"日语",@"韩语",@"小语种", nil]

//个人状态
#define CONDITION_ARR [NSArray arrayWithObjects:@"未知",@"单身",@"女王",@"韦小宝",nil]

//性别
#define SEX_ARR [NSArray arrayWithObjects:@"保密",@"男",@"女",nil]

//广告
#define AVD_TYPE [NSArray arrayWithObjects:@"节目",@"节目+主题",@"用户",nil]


//默认图片
#define DEFAULT_IMAGE [UIImage imageNamed:@"default100"]
#define DEFAULT_IMAGE_472 [UIImage imageNamed:@"default472"]
//默认头像
#define DEFAULT_PHOTO [UIImage imageNamed:@"default-photo"]
//我的电台默认图片
#define DEFAULT_COVER [UIImage imageNamed:@"default-broadcasting-cover"]

//完成按钮图标
#define ICON_FINISH [UIImage imageNamed:@"icon-finish"]
//完成按钮图标-白色
#define ICON_FINISH_WHITE [UIImage imageNamed:@"icon-finish-white"]


//tag
#define PHOTO_LIST_TAG 2300
#define DOWNLOAD_LIST_TAG 1000


/*
 *  录音设置
 */
//录音最大时间长度（秒）
#define RECORD_TIME_MAX 3600



/**
 * 通知
 */
//播放
#define MCPlayerDidPlayingNotification @"UPFM_播放中"
#define MCPlayerDidEndNotification @"UPFM_播放结束"
//download
#define MCResumeDownloadDidDownloadSuccessNotification @"UPFM_Download_Success"
#define MCResumeDownloadDidDownloadErrorNotification @"UPFM_Download_Error"
#define MCResumeDownloadDidDownloadingNotification @"UPFM_Downloading"
#define MCResumeDownloadDidDeleteFileNotification @"UPFM_Download_Delete_File"
#define MCResumeDownloadDidPauseNotification @"UPFM_Download_Pause"
//CoreData
#define CoreDataDidSaveSucess @"本地数据保存成功"

#define OtherComplaxNotification @"其它异常"

/**
 * 路径
 **/
//沙盒路径
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

//下载路径
#define LOCAL_MUSIC_DIRECTORY [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingString:@"/musics"]
//我的电台路径
#define DROADASTING_FILE_BATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject] stringByAppendingString:@"/droadcasting"]

#endif
