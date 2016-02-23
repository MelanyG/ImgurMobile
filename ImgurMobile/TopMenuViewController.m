//
//  TopMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "TopMenuViewController.h"

@implementation TopMenuViewController
- (IBAction)workModeDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            [self.delegate changeWorkingModeTo:imageFiltering];
            break;
            
        case 2:
            [self.delegate changeWorkingModeTo:textEditing];
            break;
            
        default:
            break;
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{
    
}
@end
