//
//  FiltersMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FiltersMenuViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSArray *processedSampleImages;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 3333;
}

- (void)processAndSetSampleImages
{
    
}/*

- (UIImage *)CISepiaToneFromCurrentImage
{
    self.ctx = [CIContext contextWithOptions:nil];
    
    self.beginImage = [CIImage imageWithCGImage:self.currentImage.CGImage];
    
    self.filter = [CIFilter filterWithName:NSStringFromFilterName(CISepiaTone)
                             keysAndValues:
                   kCIInputImageKey, self.beginImage,
                   @"inputIntensity", @0.8, nil];
    
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}

- (UIImage *)CIBoxBlurFromCurrentImage
{
    self.ctx = [CIContext contextWithOptions:nil];
    
    self.beginImage = [CIImage imageWithCGImage:self.currentImage.CGImage];
    
    self.filter = [CIFilter filterWithName:NSStringFromFilterName(CISepiaTone)
                             keysAndValues:
                   kCIInputImageKey, self.beginImage,
                   @"inputIntensity", @0.8, nil];
    
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}

- (UIImage *)CIGammaAdjustFromCurrentImage
{
    
}

- (UIImage *)CIVibranceFromCurrentImage
{
    
}

- (UIImage *)CIColorCubeFromCurrentImage
{
    
}

- (UIImage *)CIColorMonochromeFromCurrentImage
{
    
}

- (UIImage *)CIDepthOfFieldFromCurrentImage
{
    
}*/

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
