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
    CICMYKHalftone,
    CIColorMonochrome,
    CIColorMatrix
}FilterName;

extern NSInteger const FILTERS_COUNT;
extern NSString * const KEY_FOR_TAG;
extern NSString * const KEY_FOR_IMAGE;

NSString * NSStringFromFilterName(FilterName name);

@interface ImageFilterProcessor : UIViewController

+ (ImageFilterProcessor *)sharedProcessor;

- (void)getFilteredImage:(UIImage *)image WithFilter:(FilterName) filterName Completion:(void(^)(NSDictionary * imageAndTag)) completion;

@end
