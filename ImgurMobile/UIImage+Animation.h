//
//  UIImage+Animation.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/5/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#ifndef UIImage_Animation_h
#define UIImage_Animation_h
#import <UIKit/UIKit.h>

@interface UIImage (gifAnimation)

+ (UIImage * )animatedImageWithAnimatedGIFData:(NSData * )data;
+ (UIImage * )animatedImageWithAnimatedGIFData:(NSData * )data toSize:(CGSize) size;


@end
#endif /* UIImage_Animation_h */
