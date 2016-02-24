//
//  imageProcessor.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/24/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum{
    CISepiaTone,
    CIBoxBlur,
    CIGammaAdjust,
    CIVibrance,
    CIColorCube,
    CIColorMonochrome,
    CIDepthOfField
}FilterName;

NSString * NSStringFromFilterName(FilterName name);

@interface ImageFilterProcessor : UIViewController

@property (strong, nonatomic) UIImage *currentImage;
@property (strong, nonatomic) UIImage *sampleImage;
@property (assign, nonatomic) double sliderValue;

+ (ImageFilterProcessor *)sharedProcessor;

- (void)getFilteredImages:(void(^)(NSArray * images)) completion;

@end
