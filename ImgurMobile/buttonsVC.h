//
//  buttonsVC.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 29.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocialViewController;

@interface buttonsVC : UIViewController

@property (strong, nonatomic) SocialViewController* socialVC;

- (IBAction)favoritesAction;
- (IBAction)commentsAction;
- (IBAction)likeAction;
- (IBAction)dislikeAction;
- (IBAction)shareAction;


@end
