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

@property (strong, nonatomic) UIImage *completeImage;

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

- (void)getFilteredImage:(UIImage *)image WithFilter:(FilterName) filterName Completion:(void(^)(NSDictionary * imageAndTag)) completion
{
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
            
        case CIColorCube:
            [responce setValue:[self CIColorCubeFromCurrentImage] forKey:KEY_FOR_IMAGE];
            [responce setValue:[NSNumber numberWithInteger:(NSInteger)filterName] forKey:KEY_FOR_TAG];
            break;
            
        case CIDepthOfField:
            [responce setValue:[self CIDepthOfFieldFromCurrentImage] forKey:KEY_FOR_IMAGE];
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
                        kCIInputRadiusKey, [NSNumber numberWithFloat:5], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIGammaAdjustFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIGammaAdjust)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputPower", [NSNumber numberWithFloat:10], nil];
    
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

- (UIImage *)CIColorCubeFromCurrentImage
{
    uint8_t color_cube_data[8*4] =
    {
        0, 0, 0, 1,
        1, 0, 0, 1,
        0, 1, 0, 1,
        1, 1, 0, 1,
        0, 0, 1, 1,
        1, 0, 1, 1,
        0, 1, 1, 1,
        1, 1, 1, 1
    };
    NSData * cube_data =[NSData dataWithBytes:color_cube_data length:8*4*sizeof(uint8_t)];
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIColorCube)];
    [filter setValue:self.beginImage forKey:kCIInputImageKey];
    [filter setValue:@2 forKey:@"inputCubeDimension"];
    [filter setValue:cube_data forKey:@"inputCubeData"];
    
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

- (UIImage *)CIDepthOfFieldFromCurrentImage
{
   /* CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIDepthOfField)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputRadiusKey, [NSNumber numberWithFloat:10], nil];*/
    
    CIFilter *filter = [CIFilter filterWithName:@"CIDepthOfField"];
    [filter setDefaults];
    
    [filter setValue:self.beginImage forKey:@"inputImage"];
    
    [filter setValue:[CIVector vectorWithCGPoint:CGPointMake(50, 50)]
              forKey:@"inputPoint0"];
    
    [filter setValue:[CIVector vectorWithCGPoint:CGPointMake(100, 100)]
              forKey:@"inputPoint1"];
    
    [filter setValue:[NSNumber numberWithFloat:15.00]
              forKey:@"inputUnsharpMaskRadius"];
    
    [filter setValue:[NSNumber numberWithFloat:15.70]
              forKey:@"inputRadius"];
    
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
