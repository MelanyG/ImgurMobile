//
//  TopMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "SettingsMenuViewController.h"
#import "EditViewController.h"

@implementation SettingsMenuViewController

- (void)updateYourself
{
    self.view.tag = 1111;
    self.shouldRespondToTouchEvents = YES;
}
- (IBAction)workModeDidChanged:(UIButton *)sender
{
    if (self.shouldRespondToTouchEvents)
    {
        switch (sender.tag)
        {
            case 1:
                [self.delegate changeWorkingModeTo:imageFiltering];
                [self hideMenus];
                break;
                
            case 2:
                [self.delegate changeWorkingModeTo:textEditing];
                [self hideMenus];
                break;
                
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

- (void)hideMenus
{
    [self.delegate changeStateOfLeftMenu];
    if (((EditViewController *)self.delegate).isRightFilteringMenuOpened)
        [self.delegate changeStateOfRightMenu:FilteringMenu];
    if (((EditViewController *)self.delegate).isRightTextMenuOpened)
        [self.delegate changeStateOfRightMenu:TextEditingMenu];
}

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    [self.delegate closeAllMenus];
    [self.delegate saveImageToGallery];
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{
    [self.delegate closeAllMenus];
    [self.delegate giveImageToShareVC];
}
@end
