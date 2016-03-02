//
//  buttonsVC.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 29.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "buttonsVC.h"
#import "SocialViewController.h"
@interface buttonsVC ()

@end

@implementation buttonsVC


-(void) viewDidLoad{
    [super viewDidLoad];
}
- (IBAction)favoritesAction
{
    [self.socialVC favoritesRequest];
}

- (IBAction)commentsAction {
}

- (IBAction)likeAction
{
    [self.socialVC likeRequest];
}

- (IBAction)dislikeAction
{
    [self.socialVC dislikeRequest];
}

- (IBAction)shareAction {
}

- (IBAction)saveAction {
}
@end
