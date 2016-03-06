//
//  NewMessageViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/6/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "NewMessageViewController.h"
#import "imgurServerManager.h"

@interface NewMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextField *receiverNameField;

@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property (strong, nonatomic) imgurServerManager *manager;

@end

@implementation NewMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"New mesage";
}

- (imgurServerManager *)manager
{
    if (!_manager)
    {
        _manager = [imgurServerManager sharedManager];
    }
    return _manager;
}

- (IBAction)sendMessage:(UIButton *)sender
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.1;
    anim.repeatCount = 4;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.fromValue = [NSNumber numberWithFloat:-5.f];
    anim.toValue = [NSNumber numberWithFloat:5.f];
    
    if ([self.receiverNameField.text length] == 0)
    {
        [self.receiverNameField.layer addAnimation:anim forKey:@"wrongMove"];
    }
    else if ([self.messageField.text length] == 0)
    {
        [self.messageField.layer addAnimation:anim forKey:@"wrongMove"];
    }
    else
    {
        [self.manager createMessageWithUser:self.receiverNameField.text
                                    Message:self.self.messageField.text
                                 Completion:^(NSDictionary *dict) 
         {
             if ([dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
             {
                 if ([[dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY] isEqualToString:@"unsupported URL"])
                     [self showAlertWithHeader:@"Wrong input" AndBody:@"Receiver name must consist of english laters and can't include white spaces"];
                 else
                     [self showAlertWithHeader:@"Error" AndBody:[dict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY]];
                  
             }
             else if ([dict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
             {
                 [self showAlertWithHeader:@"Wrong input" AndBody:[dict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY]];
             }
             else
             {
                 [self.delegate reloadData];
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
}

- (void)showAlertWithHeader:(NSString *)header AndBody:(NSString *)body
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header
                                                                             message:body
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
