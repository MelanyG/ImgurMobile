//
//  AddCommentViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "AddCommentViewController.h"
#import "SocialViewController.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentOutlet.text = @"";
}



- (IBAction)commentAction
{
    self.socialVC.commentToPost = self.commentOutlet.text;
    [self.socialVC postComment];
}



@end
