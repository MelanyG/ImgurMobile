//
//  buttonsVC.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 29.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "buttonsVC.h"
#import "SocialViewController.h"
#import "EditViewController.h"
#import "commentsVC.h"

@interface buttonsVC ()

@property (strong, nonatomic) EditViewController* editVC;
@property (strong, nonatomic) commentsVC* commentsVC;

@end

@implementation buttonsVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editSegue"])
    {
        self.editVC = (EditViewController*)segue.destinationViewController;
        self.editVC.image = self.socialVC.image;
    }
    else if ([segue.identifier isEqualToString:@"commentsSegue"])
    {
        self.commentsVC = (commentsVC*)segue.destinationViewController;
        self.commentsVC.socialVC = self.socialVC;
    }
    
}
-(void) viewDidLoad{
    [super viewDidLoad];
}
- (IBAction)favoritesAction
{
    [self.socialVC favoritesRequest];
}

- (IBAction)commentsAction
{
    
}

- (IBAction)likeAction
{
    [self.socialVC likeRequest];
}

- (IBAction)dislikeAction
{
    [self.socialVC dislikeRequest];
}

- (IBAction)shareAction
{
    
}


@end
