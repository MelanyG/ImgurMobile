//
//  MainViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageInfoDelegate.h"
#import "ImgurLoginViewController.h"


@interface MainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PageInfoDelegate>

@end
