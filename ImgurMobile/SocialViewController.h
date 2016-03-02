//
//  SocialViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgurPost.h"

@class buttonsVC;

@interface SocialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
@property (strong, nonatomic) NSString* imageID;
@property (weak, nonatomic) IBOutlet UITextView *socialImageDescription;
@property (weak, nonatomic) IBOutlet UINavigationItem *imageTitel;
@property (strong, nonatomic) NSString* albumID;

@property (strong, nonatomic) buttonsVC* buttonsVC;

@property (strong, nonatomic) imgurPost * post;
@property (strong, nonatomic) UIImage * image;

@property (strong, nonatomic) SocialViewController * socialVCDelegate;


-(void) favoritesRequest;
-(void) likeRequest;
-(void) dislikeRequest;

@end
