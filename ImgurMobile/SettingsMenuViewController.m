//
//  TopMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "SettingsMenuViewController.h"
#import "EditViewController.h"

@interface SettingsMenuViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fontMenuButton;

@end

@implementation SettingsMenuViewController

- (void)disableButton
{
    self.fontMenuButton.enabled = NO;
}

- (void)enableButton
{
    self.fontMenuButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glas_texture"]];
    
    // border radius
    self.view.layer.cornerRadius = 5;
    
    // drop shadow
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.8];
    [self.view.layer setShadowRadius:5.0];
    [self.view.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
}

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
