//
//  ButtonsViewController.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/8/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageInfoDelegate.h"


@interface ButtonsViewController : UIViewController
@property (weak, nonatomic) id<PageInfoDelegate> delegate;
@end
