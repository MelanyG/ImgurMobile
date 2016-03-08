//
//  ButtonsViewController.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/8/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ButtonsViewController.h"
#import "PageInfoViewController.h"

@interface ButtonsViewController ()

@end

@implementation ButtonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showPageInfo:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PageInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"pageInfo"];
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    controller.delegate = self.delegate;
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
