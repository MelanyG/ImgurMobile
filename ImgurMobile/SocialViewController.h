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
@property (assign, nonatomic) NSInteger commentsCount;
@property (strong, nonatomic) NSMutableArray* commentsArray;

@property (strong, nonatomic) buttonsVC* buttonsVC;

@property (strong, nonatomic) imgurPost * post;
@property (strong, nonatomic) UIImage * image;

@property (strong, nonatomic) SocialViewController * socialVCDelegate;

- (void)commentsRequest;
-(void) favoritesRequest;
-(void) likeRequest;
-(void) dislikeRequest;
- (NSString*)getAutherAvatarIDWithID:(NSString*) avatarID;
-(void) likeCommentRequestByID:(NSString*) commentID;
-(void) dislikeCommentRequestByID:(NSString*) commentID;

@end
