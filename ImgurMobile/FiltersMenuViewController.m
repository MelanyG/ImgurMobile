//
//  FiltersMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FiltersMenuViewController.h"
#import "UIImage+Resize.h"

typedef enum{
    CISepiaTone,
    CIBoxBlur,
    CIGammaAdjust,
    CIVibrance,
    CIColorCube,
    CIColorMonochrome,
    CIDepthOfField
}FilterName;

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

@interface FiltersMenuViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeighConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSMutableArray *processedSampleImages;
@property (assign, nonatomic) CGSize sampleImageSize;
@property (strong, nonatomic) UIImage *sampleImage;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 3333;
    [self prepareSampleImage];
    [self processAndSetSampleImages];
    [self configure];
}

- (void)prepareSampleImage
{
    double coef = self.currentImage.size.width / self.contentView.frame.size.width;
    self.sampleImageSize = CGSizeMake(self.currentImage.size.width / coef,
                                      self.currentImage.size.height / coef);
    self.sampleImage = [UIImage imageWithImage:self.currentImage scaledToSize:self.sampleImageSize];
}

- (void)configure
{
    self.containerViewHeighConstraint.constant =  self.sampleImageSize.height * self.processedSampleImages.count;
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width,
                                             self.sampleImageSize.height * self.processedSampleImages.count);
    [self setImagesIntoContentView];
}

- (void)setImagesIntoContentView
{
    double yCoordinate = 0;
    for (int i = 0; i < self.processedSampleImages.count; i++)
    {
        CGRect frame = CGRectMake(0,yCoordinate + self.sampleImageSize.height*i,
                                  self.sampleImageSize.width,
                                  self.sampleImageSize.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [self.processedSampleImages objectAtIndex:i];
        [self.contentView addSubview:imageView];
    }
}

- (void)processAndSetSampleImages
{
    self.ctx = [CIContext contextWithOptions:nil];
    
    self.beginImage = [CIImage imageWithCGImage:self.sampleImage.CGImage];
    
    self.processedSampleImages = [NSMutableArray array];
    [self.processedSampleImages addObject:[self CISepiaToneFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIBoxBlurFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIGammaAdjustFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIVibranceFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIColorCubeFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIColorMonochromeFromCurrentImage]];
    [self.processedSampleImages addObject:[self CIDepthOfFieldFromCurrentImage]];
}

- (UIImage *)CISepiaToneFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CISepiaTone)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputIntensityKey, [NSNumber numberWithFloat:self.slider.value], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIBoxBlurFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIBoxBlur)
                                    keysAndValues:
                          kCIInputImageKey, self.beginImage,
                          kCIInputRadiusKey, [NSNumber numberWithFloat:self.slider.value * 10], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIGammaAdjustFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIGammaAdjust)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputPower", [NSNumber numberWithFloat:self.slider.value], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIVibranceFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIVibrance)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:self.slider.value], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorCubeFromCurrentImage
{
#warning non
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIVibrance)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputAmount", [NSNumber numberWithFloat:self.slider.value], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIColorMonochromeFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIColorMonochrome)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputColorKey, [CIColor colorWithRed:0.67 green:0.13 blue:0.83 alpha:0.74],
                        @"inputIntensity", [NSNumber numberWithFloat:self.slider.value], nil];
    
    return [self getFilteredImageWithFilter:filter];
}

- (UIImage *)CIDepthOfFieldFromCurrentImage
{
    CIFilter *filter = [CIFilter filterWithName:NSStringFromFilterName(CIDepthOfField)
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        kCIInputRadiusKey, [NSNumber numberWithFloat:self.slider.value * 10], nil];
    
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

/* - (void)viewDidLoad
 {
 [super viewDidLoad];
 self.image = [UIImage imageNamed:@"sea"];
 
 
 self.ctx = [CIContext contextWithOptions:nil];
 
 self.beginImage = [CIImage imageWithCGImage:self.image.CGImage];
 
 self.filter = [CIFilter filterWithName:@"CISepiaTone"
 keysAndValues:
 kCIInputImageKey, self.beginImage,
 @"inputIntensity", @0.8, nil];
 
 CIImage *outImage = [self.filter outputImage];
 
 CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
 
 self.imageView.image = [UIImage imageWithCGImage:cgImg];
 
 CGImageRelease(cgImg);
 }
 */
 - (IBAction)sliderValueBeenChanged:(UISlider *)sender
 {
 /*float slideValue = sender.value;
 
 [self.filter setValue:@(slideValue)
 forKey:@"inputIntensity"];
 CIImage *outImage = [self.filter outputImage];
 
 CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
 
 self.imageView.image = [UIImage imageWithCGImage:cgImg];
 
 CGImageRelease(cgImg);*/
 }
@end
