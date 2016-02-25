//
//  ImgurPosting.m
//  ImgurMobile
//
//  Created by Melany on 2/21/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurPosting.h"

@interface ImgurPosting ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;

@end

@implementation ImgurPosting

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Login";
    
    UIBarButtonItem* plus =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(postActionSelected)];
    
    self.navigationItem.rightBarButtonItem = plus;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) postActionSelected
{

        NSString *title = [[self titleTextField] text];
    NSString *description = [[self commentTextField] text];
    
    NSData *imageData = UIImageJPEGRepresentation(self.currentImage.image, 0.5);
       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
        //__weak ImgurPosting *weakSelf = self;
        [imgurServerManager uploadPhoto:imageData
                               title:title
                         description:description
                     completionBlock:^(NSString *result) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            NSLog(@"%@",result);                         });
                     } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                             
                             [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                                         message:[NSString stringWithFormat:@"%@ (Status code %ld)", [error localizedDescription], (long)status]
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] show];
                             NSLog(@"%@", error);
                         });
                     }];
        
    });
}
@end
