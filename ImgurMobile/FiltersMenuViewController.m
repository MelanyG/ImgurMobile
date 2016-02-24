//
//  FiltersMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FiltersMenuViewController.h"
#import "ImageFilterProcessor.h"
#import "UIImage+Resize.h"

@interface FiltersMenuViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeighConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSArray *processedSampleImages;
@property (assign, nonatomic) CGSize sampleImageSize;
@property (strong, nonatomic) UIImage *sampleImage;

@property (strong, nonatomic) ImageFilterProcessor *processor;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 3333;
    [self getSampleImages];
}

- (ImageFilterProcessor *)processor
{
    if (!_processor)
    {
        _processor = [ImageFilterProcessor sharedProcessor];
    }
    return _processor;
}

- (void)prepareSampleImage
{
    double coef = self.currentImage.size.width / self.contentView.frame.size.width;
    self.sampleImageSize = CGSizeMake(self.currentImage.size.width / coef,
                                      self.currentImage.size.height / coef);
    self.sampleImage = [UIImage imageWithImage:self.currentImage scaledToSize:self.sampleImageSize];
}

- (void)getSampleImages
{
    [self prepareSampleImage];
    self.processor.currentImage = self.currentImage;
    self.processor.sampleImage = self.sampleImage;
    self.processor.sliderValue = self.slider.value;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        [self.processor getFilteredImages:^(NSArray *images)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.processedSampleImages = images;
                [self setImages];
            });
        }];
    });
    
}

- (void)setImages
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
