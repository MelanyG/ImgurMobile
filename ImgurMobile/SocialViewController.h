//
//  SocialViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class imgurAlbum;
@class imgurPost;
@class buttonsVC;

@interface SocialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *socialImageDescription;
@property (weak, nonatomic) IBOutlet UINavigationItem *imageTitel;
@property (strong, nonatomic) NSString* albumID;
@property (assign, nonatomic) NSInteger commentsCount;
@property (strong, nonatomic) NSMutableArray* commentsArray;
@property (strong, nonatomic) NSString* commentToPost;
@property (strong, nonatomic) buttonsVC* buttonsVC;

@property (strong, nonatomic) imgurPost * post;
@property (strong, nonatomic) imgurAlbum* album;

@property (strong, nonatomic) NSString* imageID;
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) UIImage* imageToEdit;

@property (strong, nonatomic) id postObject;



- (void)commentsRequest;
- (void) favoritesRequest;
- (void) likeRequest;
- (void) dislikeRequest;
- (NSString*)getAutherAvatarIDWithID:(NSString*) avatarID;
- (void) likeCommentRequestByID:(NSString*) commentID;
- (void) dislikeCommentRequestByID:(NSString*) commentID;
- (void) postComment;

@end
