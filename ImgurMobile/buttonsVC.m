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
#import "GeneralCommentsTableViewController.h"

@interface buttonsVC ()

@property (strong, nonatomic) EditViewController* editVC;
@property (strong, nonatomic) GeneralCommentsTableViewController* commentsVC;


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
        UINavigationController* navVC = (UINavigationController*)segue.destinationViewController;
        self.commentsVC = (GeneralCommentsTableViewController*)[navVC topViewController];
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
    [self.socialVC commentsRequest];
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
    NSArray *postItems = @[self.socialVC.image];
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController* popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

    
}


@end
