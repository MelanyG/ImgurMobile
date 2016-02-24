//
//  imageProcessor.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/24/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImageFilterProcessor.h"

NSString * NSStringFromFilterName(FilterName name)
{
    switch (name)
    {
        case CIBoxBlur: return @"CIBoxBlur";
            
        case CIColorMonochrome: return @"CIColorMonochrome";
            
        case CIColorCube: return @"CIColorCube";
            
        case CIDepthOfField: return @"CIDepthOfField";
            
        case CIGammaAdjust: return @"CIGammaAdjust";
            
        case CISepiaTone: return @"CISepiaTone";
            
        case CIVibrance: return @"CIVibrance";
            
        default:
            break;
    }
}

@interface ImageFilterProcessor ()

@property (strong, nonatomic) NSMutableArray *imagesArray;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

@end

@implementation ImageFilterProcessor

+ (ImageFilterProcessor *)sharedProcessor
{
    static ImageFilterProcessor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageFilterProcessor alloc] init];
    });
    return instance;
}

- (void)getFilteredImages:(void(^)(NSArray * images)) completion
{
    self.ctx = [CIContext contextWithOptions:nil];
    
    self.beginImage = [CIImage imageWithCGImage:self.sampleImage.CGImage];
    
    self.imagesArray = [NSMutableArray array];
    [self.imagesArray addObject:[self CISepiaToneFromCurrentImage]];
    [self.imagesArray addObject:[self CIBoxBlurFromCurrentImage]];
    [self.imagesArray addObject:[self CIGammaAdjustFromCurrentImage]];
    [self.imagesArray addObject:[self CIVibranceFromCurrentImage]];
    [self.imagesArray addObject:[self CIColorCubeFromCurrentImage]];
    [self.imagesArray addObject:[self CIColorMonochromeFromCurrentImage]];
    [self.imagesArray addObject:[self CIDepthOfFieldFromCurrentImage]];
    
    completion(self.imagesArray);
}

- (UIImage *)CISepiaToneFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CISepiaTone)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputIntensityKey, [NSNumber numberWithFloat:self.sliderValue], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIBoxBlurFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIBoxBlur)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputRadiusKey, [NSNumber numberWithFloat:self.sliderValue * 10], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIGammaAdjustFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIGammaAdjust)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputPower", [NSNumber numberWithFloat:self.sliderValue], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIVibranceFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIVibrance)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:self.sliderValue], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorCubeFromCurrentImage
{
#warning non
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIVibrance)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:self.sliderValue], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorMonochromeFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIColorMonochrome)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputColorKey, [CIColor colorWithRed:0.67 green:0.13 blue:0.83 alpha:0.74],
                        @"inputIntensity", [NSNumber numberWithFloat:self.sliderValue], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIDepthOfFieldFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIDepthOfField)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputRadiusKey, [NSNumber numberWithFloat:self.sliderValue * 10], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)getFilteredImageWithFilter:(CIFilter *)filter
{
    self.filter = filter;
    
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
    
    return image;
}


@end
