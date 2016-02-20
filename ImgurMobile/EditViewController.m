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
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CIContext *ctx = [CIContext contextWithOptions:nil];
    
    UIImage *image = [UIImage imageNamed:@"sea"];
    
    CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:
                        kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    
    CIImage *outImage = [filter outputImage];
    
    CGImageRef cgImg = [ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}




@end
