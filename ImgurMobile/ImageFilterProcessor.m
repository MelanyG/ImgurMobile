//
//  imageProcessor.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/24/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImageFilterProcessor.h"

NSInteger const FILTERS_COUNT = 7;
NSString * const KEY_FOR_TAG = @"tag";
NSString * const KEY_FOR_IMAGE = @"image";

NSString * NSStringFromFilterName(FilterName name)
{
    switch (name)
    {
        case CIBoxBlur: return @"CIBoxBlur";
            
        case CIColorMonochrome: return @"CIColorMonochrome";
            
        case CICMYKHalftone: return @"CICMYKHalftone";
            
        case CIColorMatrix: return @"CIColorMatrix";
            
        case CIGammaAdjust: return @"CIGammaAdjust";
            
        case CISepiaTone: return @"CISepiaTone";
            
        case CIVibrance: return @"CIVibrance";
            
        default:
            break;
    }
}

@interface ImageFilterProcessor ()

@property (strong, nonatomic) UIImage *completeImage;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

@property (assign, nonatomic) CGSize imageSize;

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

- (void)getFilteredImage:(UIImage *)image WithFilter:(FilterName) filterName Completion:(void(^)(NSDictionary * imageAndTag)) completion
{
    self.imageSize = image.size;
    
    self.ctx = [CIContext contextWithOptions:nil];
    
    self.beginImage = [CIImage imageWithCGImage:image.CGImage];
    
    NSMutableDictionary *responce = [[NSMutableDictionary alloc] init];
    
    switch (filterName)
    {
        case CIBoxBlur:
            [responce setValue:[self CIBoxBlurFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CIColorMonochrome:
            [responce setValue:[self CIColorMonochromeFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CICMYKHalftone:
            [responce setValue:[self CICMYKHalftoneFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CIColorMatrix:
            [responce setValue:[self CIColorMatrixFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CIGammaAdjust:
            [responce setValue:[self CIGammaAdjustFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CISepiaTone:
            [responce setValue:[self CISepiaToneFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CIVibrance:
            [responce setValue:[self CIVibranceFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        default:
            break;
    }
    
    completion(responce);
}

- (UIImage *)CISepiaToneFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CISepiaTone)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputIntensityKey, [NSNumber numberWithFloat:0.8], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIBoxBlurFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIBoxBlur)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputRadiusKey, [NSNumber numberWithFloat:self.imageSize.width / 70], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIGammaAdjustFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIGammaAdjust)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputPower", [NSNumber numberWithFloat:1.3], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIVibranceFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIVibrance)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:1.0], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CICMYKHalftoneFromCurrentImage
{
    CIVector *vector = [CIVector vectorWithCGPoint:CGPointMake(self.imageSize.width, self.imageSize.height)];
    
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CICMYKHalftone)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputWidthKey, @2,
                        kCIInputCenterKey, vector, nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorMonochromeFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIColorMonochrome)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputColorKey, [CIColor colorWithRed:0.15 green:0.61 blue:0.81 alpha:0.5],
                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorMatrixFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputRVector", [CIVector vectorWithX:1 Y:0 Z:0 W:0],
                        @"inputGVector", [CIVector vectorWithX:0 Y:0.9 Z:0 W:0],
                        @"inputBVector", [CIVector vectorWithX:0 Y:0 Z:1.2 W:0],
                        @"inputAVector", [CIVector vectorWithX:0 Y:0 Z:0 W:1],
                        @"inputBiasVector", [CIVector vectorWithX:0.1 Y:0 Z:0.5 W:0], nil];
    
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
