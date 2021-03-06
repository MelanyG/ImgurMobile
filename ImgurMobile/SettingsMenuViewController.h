//
//  TopMenuViewController.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProtocolHeader.h"

@interface SettingsMenuViewController : UIViewController

@property (weak, nonatomic) id <settingsMenuDelegate> delegate;

@property (assign, nonatomic) BOOL shouldRespondToTouchEvents;

- (void)updateYourself;
- (void)disableButton;
- (void)enableButton;

@end
