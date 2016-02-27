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
#import "UIActivityIndicatorView+manager.h"

@interface FiltersMenuViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeighConstraint;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSMutableArray *processedSampleImages;
@property (assign, nonatomic) CGSize sampleImageSize;
@property (strong, nonatomic) UIImage *sampleImage;

@property (strong, nonatomic) ImageFilterProcessor *processor;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation FiltersMenuViewController

- (void)updateYourself
{
    self.view.tag = 3333;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:self.tapGesture];
    
    [self configureScrollView];
    
    [self fillImagesArrayWithPlaceHolders];
    
    [self getSampleImages];
}

- (void)fillImagesArrayWithPlaceHolders
{
    self.processedSampleImages = [NSMutableArray array];
    double yCoordinate = self.scrollView.frame.size.height / 2 - self.sampleImageSize.height;
    
    for (int i = 0; i < FILTERS_COUNT; i++)
    {
        CGRect frame = CGRectMake(0, yCoordinate + (self.sampleImageSize.height + 10) * i,
                                  self.sampleImageSize.width,
                                  self.sampleImageSize.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        [UIActivityIndicatorView addActivityIndicatorToView:imageView];
        
        [self.contentView addSubview:imageView];
        [self.processedSampleImages addObject:imageView];
    }
}

- (void)prepareSampleImage
{
    double coef = self.currentImage.size.width / self.contentView.frame.size.width;
    self.sampleImageSize = CGSizeMake((NSInteger)self.currentImage.size.width / coef,
                                      (NSInteger)self.currentImage.size.height / coef);
    self.sampleImage = [UIImage imageWithImage:self.currentImage scaledToSize:CGSizeMake(self.sampleImageSize.width / 2, self.sampleImageSize.height / 2)];
}

- (void)configureScrollView
{
    [self prepareSampleImage];
    double scrollViewOffset = self.scrollView.frame.size.height / 2;
    
    self.containerViewHeighConstraint.constant =  (10 + self.sampleImageSize.height) * FILTERS_COUNT + scrollViewOffset;
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width,
                                             (self.scrollView.frame.size.height / 2 + self.sampleImageSize.height / 2) * self.processedSampleImages.count);
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.contentView];
    UIView *view = [self.contentView hitTest:location withEvent:nil];
    
    if ([view isKindOfClass:[UIImageView class]])
    {
        [self.delegate changeStateOfRightMenu:FilteringMenu];
        [self.filterDelegate startLoadIndicating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            
            [self.processor getFilteredImage:self.currentImage WithFilter:(FilterName)view.tag Completion:^(NSDictionary *imageAndTag)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [self.filterDelegate stopLoadIndicating];
                    [self.filterDelegate updateUIWithImage:[imageAndTag objectForKey:KEY_FOR_IMAGE]];
                });
            }];
        });
        
    }
}

- (ImageFilterProcessor *)processor
{
    if (!_processor)
    {
        _processor = [ImageFilterProcessor sharedProcessor];
    }
    return _processor;
}

- (void)getSampleImages
{
    self.processor.sliderValue = self.slider.value;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        for (int i = 0; i < FILTERS_COUNT; i++)
        {
            [self.processor getFilteredImage:self.sampleImage WithFilter:(FilterName)i Completion:^(NSDictionary *imageAndTag)
            {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [self setImageIntoContentView:imageAndTag];
                                });
             }];
        }
    });
    
}

- (void)setImageIntoContentView:(NSDictionary *)imageAndTag
{
    for (UIImageView *view in self.contentView.subviews)
    {
        if (!view.image)
        {
            view.image = [imageAndTag objectForKey:KEY_FOR_IMAGE];
            view.tag = [[imageAndTag objectForKey:KEY_FOR_TAG] intValue];
            [UIActivityIndicatorView removeActivityIndicatorFromView:view];
            view.userInteractionEnabled = YES;
            break;
        }
    }
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePage];
}



- (void)loadVisiblePage
{
    NSInteger page = (NSInteger)self.scrollView.contentOffset.y / (self.scrollView.frame.size.height / 2 - self.sampleImageSize.height / 2) + self.sampleImageSize.height + 1;
    
    self.pageControl.currentPage = page;
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
