//
//  TopMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "SettingsMenuViewController.h"

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
                
                [self.delegate changeStateOfLeftMenu];
                break;
                
            case 2:
                [self.delegate changeWorkingModeTo:textEditing];
                [self.delegate changeStateOfLeftMenu];
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

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    [self.delegate saveImageAndShowPostVC];
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{
    
}
@end
