//
//  PageSelectViewController.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/1/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageInfoDelegate.h"

@interface PageSelectViewController : UIViewController

@property (weak,nonatomic) id<PageInfoDelegate> delegate;

@end
