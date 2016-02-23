//
//  TopMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "TopMenuViewController.h"

@implementation TopMenuViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 1111;
}
- (IBAction)workModeDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            [self.delegate changeWorkingModeTo:imageFiltering];
            [self.delegate changeStateOfTopMenu];
            break;
            
        case 2:
            [self.delegate changeWorkingModeTo:textEditing];
            [self.delegate changeStateOfTopMenu];
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
