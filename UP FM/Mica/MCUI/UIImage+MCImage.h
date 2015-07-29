//
//  UIImage+MCImage.h
//  iDouKou
//
//  Created by hiseh yin on 13-7-29.
//  Copyright (c) 2013年 vividomedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    iImageToGray = 0,
    iImageToPink,
    iImageToGreen,
    iImageToReVersal,
    iImageToWhite
} ImageType;

@interface UIImage (MCImage)

- (UIImage *)resizeWithSize:(CGSize)size;
- (UIImage *)changeColorWithColor:(UIColor *)newColor;
- (UIImage *)maskWithImage:(UIImage *)theMaskImage;

- (UIImage *)imageScale:(ImageType)imageType;

+ (UIImage *)imageWithView:(UIView *)view;

- (UIImage*)cutImageWithRadius:(int)radius;
@end
