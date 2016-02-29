//
//  UIImageView+imageRectGetter.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/28/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "UIImageView+imageRectGetter.h"

@implementation UIImageView (imageRectGetter)

-(CGRect )calculateClientRectOfImage
{
    CGSize imgViewSize=self.frame.size;                  // Size of UIImageView
    CGSize imgSize=self.image.size;                      // Size of the image, currently displayed
    
    // Calculate the aspect, assuming imgView.contentMode==UIViewContentModeScaleAspectFit
    
    CGFloat scaleW = imgViewSize.width / imgSize.width;
    CGFloat scaleH = imgViewSize.height / imgSize.height;
    CGFloat aspect=fmin(scaleW, scaleH);
    
    CGRect imageRect={ {0,0} , { imgSize.width*=aspect, imgSize.height*=aspect } };
    
    // Note: the above is the same as :
    // CGRect imageRect=CGRectMake(0,0,imgSize.width*=aspect,imgSize.height*=aspect) I just like this notation better
    
    // Center image
    
    imageRect.origin.x=(imgViewSize.width-imageRect.size.width)/2;
    imageRect.origin.y=(imgViewSize.height-imageRect.size.height)/2;
    
    // Add imageView offset
    
    imageRect.origin.x+=self.frame.origin.x;
    imageRect.origin.y+=self.frame.origin.y;
    
    return(imageRect);
}

@end
