//
//  FiltersMenuViewController.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProtocolHeader.h"

@interface FiltersMenuViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic)id <rightMenuDelegate> delegate;
@property (weak, nonatomic)id <filteringDelegate> filterDelegate;
@property (strong, nonatomic) UIImage *currentImage;

- (void)updateYourself;

@end
