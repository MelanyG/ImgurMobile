//
//  SocialViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
@property (strong, nonatomic) NSString* imageID;
@property (weak, nonatomic) IBOutlet UITextView *socialImageDescription;
@property (weak, nonatomic) IBOutlet UINavigationItem *imageTitel;
@property (strong, nonatomic) NSString* albumID;

@end
