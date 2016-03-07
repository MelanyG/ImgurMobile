//
//  AddCommentViewController.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialViewController;

@interface AddCommentViewController : UIViewController

@property (strong, nonatomic) SocialViewController* socialVC;
@property (weak, nonatomic) IBOutlet UITextView *commentOutlet;
- (IBAction)commentAction;

@end
