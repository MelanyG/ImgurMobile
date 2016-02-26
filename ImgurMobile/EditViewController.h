//
//  EditViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProtocolHeader.h"

@interface EditViewController : UIViewController <topMenuDelegate, rightMenuDelegate, filteringDelegate>

@property (nonatomic, strong) UIImage *image;

@end
