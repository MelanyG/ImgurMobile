//
//  PageInfoViewController.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/25/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageInfoDelegate.h"


@interface PageInfoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id<PageInfoDelegate> delegate;

@end
