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

@property (strong, nonatomic) ImgurAccessToken* token;
@property (weak, nonatomic) IBOutlet UIPickerView *selectedTopic;
@property (strong, nonatomic) NSArray* array;
@property (strong, nonatomic) NSString* topic;
@property (weak, nonatomic) IBOutlet UIButton *sharedButton;
@property (weak, nonatomic) NSString* imageID;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

@implementation ImgurPosting

- (void)viewDidLoad {
    [super viewDidLoad];
    self.token = [ImgurAccessToken sharedToken];
    self.navigationItem.title = @"Post";
   self.currentImage.image = self.image;
 //    UIBarButtonItem* plus =
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                  target:self
//                                                  action:@selector(postActionSelected)];
    // Two buttons at the right side of nav bar
//    UIBarButtonItem *addAttachButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postActionSelected)];
//    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(ShareWithCommunity:)];
//    self.navigationItem.rightBarButtonItems = @[addAttachButton,sendButton];
    
    
    self.sharedButton.enabled = NO;
    
    //self.navigationItem.rightBarButtonItem = plus;
    self.selectedTopic.delegate = self;
    self.array = [[NSArray alloc]initWithObjects:@"Funny", @"Aww", @"Storytime", @"Design & Art", @"No topic", @"Awesome", @"The More You Know", @"Current Events", @"Reaction", @"Inspiring", nil];
    
    
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.array count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
self.topic = [self.array objectAtIndex:row];
    //NSLog(@"Topic selected: %@",self.topic );
    return [self.array objectAtIndex:row];
}
//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    //NSString *title = @"sample title";
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    return attString;
//    
//}
- (void)didReceiveMemoryWarning
{
         [super didReceiveMemoryWarning];
         // Dispose of any resources that can be recreated.
}
     

- (IBAction)ShareWithCommunity:(UIButton *)sender
{
    imgurServerManager*x = [[imgurServerManager alloc]init];
    NSString *title = [[self titleTextField] text];
    NSString *description = [[self commentTextField] text];
    self.sharedButton.enabled = NO;

         [x shareImageWithImgurCommunity:title
                             description:description
                      access_token: self.token.token
                                   topic:self.topic
                         completionBlock:^(NSString *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            UIAlertView *av = [[UIAlertView alloc]
                               initWithTitle:@"Sucessfully posted to wall!"
                               message:@"Check out your Imgur Wall to see!"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
            [av show];
                        NSLog(@"%@",result);
            self.sharedButton.enabled = YES;
});
    } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
           
           [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                       message:[NSString stringWithFormat:@"%@ (Status code %ld)", [error localizedDescription], (long)status]
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil] show];
           NSLog(@"%@", [error localizedDescription]);
           NSLog(@"Err details: %@", [error description]);
            self.sharedButton.enabled = YES;

       });
   }];
    

}

- (IBAction)postActionSelected:(UIButton *)sender
{
  NSString *title = [[self titleTextField] text];
  NSString *description = [[self commentTextField] text];
    self.postButton.enabled = NO;
    NSData *imageData = UIImageJPEGRepresentation(self.currentImage.image, 0.5);
       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imgurServerManager*x = [[imgurServerManager alloc]init];
            NSLog(@"token in Post view Controler is: %@",self.token.token);
             [x uploadPhoto:imageData
                     title:title
               description:description
              access_token: self.token.token
                     topic: self.topic
           completionBlock:^(NSString *result)
            {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                   UIAlertView *av = [[UIAlertView alloc]
                                       initWithTitle:@"Sucessfully posted to photos & wall!"
                                       message:@"Check out your Imgur Gallery to see!"
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                   [av show];
                  self.sharedButton.enabled = YES;
                    self.postButton.enabled = YES;
                  NSLog(@"%@",result);                         });
           }
               failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status)
            {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                   
                   [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                               message:[NSString stringWithFormat:@"%@ (Status code %ld)", [error localizedDescription], (long)status]
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK", nil] show];
                   NSLog(@"%@", [error localizedDescription]);
                   NSLog(@"Err details: %@", [error description]);
                   self.postButton.enabled = YES;
               });
           }];
            
        });
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ItemsPosted"])
    {
        ImgurPosting * ipvc = (ImgurPosting *)segue.destinationViewController;
        ipvc.image = self.image;
    }
}


@end
