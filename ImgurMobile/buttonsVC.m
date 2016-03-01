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

@property (strong, nonatomic) SocialViewController* socialVC;

@end

@implementation buttonsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.socialVC = [[SocialViewController alloc] init];
}



- (IBAction)favoritesAction
{
    
}

- (IBAction)commentsAction {
}

- (IBAction)likeAction {
}

- (IBAction)dislikeAction {
}

- (IBAction)shareAction {
}

- (IBAction)saveAction {
}
@end
