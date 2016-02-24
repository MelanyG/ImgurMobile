//
//  FiltersMenuViewController.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProtocolHeader.h"

@interface FiltersMenuViewController : UIViewController

@property (weak, nonatomic)id <rightMenuDelegate> delegate;
@property (strong, nonatomic) UIImage *currentImage;

@end
