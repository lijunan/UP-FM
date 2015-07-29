//
//  Functions.h
//  UP FM
//
//  Created by liubin on 15-1-22.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UPFMBase.h"

@interface Functions : NSObject

#pragma mark - 返回UILabel高度
+(CGFloat)getTextHeight:(NSString *)text :(CGSize)size :(UIFont *)font;


#pragma mark - 将UIColor变换为UIImage

+(UIImage *)createImageWithColor:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 旋转图片
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

#pragma mark - 返回字符串长度 汉字为2个字节
+(int)stringLeng:(NSString *)string;

#pragma mark - 返回样式button
+(UIButton *)initBarRightButton:(BarButtonType)type;

//获取沙盒路径
+(NSString *)documentPath;
@end
