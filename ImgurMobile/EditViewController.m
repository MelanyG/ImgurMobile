//
//  EditViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

//Top menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *topMenuContainerView;

//Right Filters Menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *filterMenuContainerView;

//Right Fonts Menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *fontsMenuContainerView;


@end

@implementation EditViewController

- (void)viewDidLoad
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

- (IBAction)intensityBeenChanged:(UISlider *)sender
{
    float slideValue = sender.value;
    
    [self.filter setValue:@(slideValue)
              forKey:@"inputIntensity"];
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}

- (void)addScrollView
{
    
}


@end
