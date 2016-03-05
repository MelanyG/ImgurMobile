//
//  UIImage+Animation.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/5/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Animation.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (gifAnimation)

+ (UIImage * )animatedImageWithAnimatedGIFData:(NSData * )data
{
    if (data)
    {
        CGImageSourceRef source = CGImageSourceCreateWithData((CFTypeRef)data, NULL);
        if (source)
        {
            return animatedImageFromCGImageSource(CGImageSourceCreateWithData((CFTypeRef)data, NULL), 0, 0);
        }
    }
    return nil;
}

+ (UIImage * )animatedImageWithAnimatedGIFData:(NSData * )data toSize:(CGSize) size
{
    if (data)
    {
        CGImageSourceRef source = CGImageSourceCreateWithData((CFTypeRef)data, NULL);
        if (source)
        {
            return animatedImageFromCGImageSource(CGImageSourceCreateWithData((CFTypeRef)data, NULL), size.width , size.height);
        }
    }
    return nil;
}

static UIImage * animatedImageFromCGImageSource(CGImageSourceRef source, int width, int height)
{
    unsigned long count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delays[count];
    imagesAndDelays(source, count, images, delays);
    
    NSArray * frames = imageFrames(count, images);
    
    if (height != 0 && width != 0)
    {
        UIImage *images[count];
        for (int i =0; i < count; i++)
        {
            images[i] = imageToSize([frames objectAtIndex:i], width, height);
        }
        frames = [NSArray arrayWithObjects:images count:count];
    }
    
    UIImage *animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDuration(count, delays) / 100.0];
    return animation;
}

static UIImage * imageToSize(UIImage *image, int width, int height )
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
static void imagesAndDelays(CGImageSourceRef source, unsigned long count, CGImageRef images[count], int delays[count])
{
    for (int i = 0; i < count; i ++)
    {
        images[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        if (properties) {
            CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
            if (gifProperties)
            {
                NSNumber *number = (id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
                if (number == NULL || [number doubleValue] == 0)
                {
                    number = (id) CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
                }
                if ([number doubleValue] > 0)
                {
                    delays[i] = (int)lrint([number doubleValue] * 100);
                }
            }
            CFRelease(properties);
        }
    }
}

static NSArray * imageFrames(unsigned long count, CGImageRef images[count])
{
    UIImage * frames[count];
    for (int i = 0; i < count; i ++)
    {
        frames[i] = [UIImage imageWithCGImage:images[i]];
    }
    return [NSArray arrayWithObjects:frames count:count];
}

static int totalDuration(unsigned long count, int delays[count])
{
    int sum = 0;
    for(int i = 0; i < count; i ++)
        sum += delays[i];
    return sum;
}
@end