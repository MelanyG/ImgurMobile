//
//  ImgurPosting.m
//  ImgurMobile
//
//  Created by Melany on 2/21/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurPosting.h"
#import "UserAlbum.h"
#import "UserImage.h"
#import "UsersImagesTableViewController.h"

@interface ImgurPosting ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) ImgurAccessToken* token;
@property (weak, nonatomic) IBOutlet UIPickerView *selectedTopic;
@property (strong, nonatomic) NSArray* array;
@property (strong, nonatomic) NSString* topic;
@property (weak, nonatomic) IBOutlet UIButton *sharedButton;
@property (weak, nonatomic) NSString* imageID;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) NSArray* albumObjects;
@property (strong, nonatomic) NSArray* allUserImages;

@end

@implementation ImgurPosting

- (void)viewDidLoad
{
    [super viewDidLoad];
[GiFHUD setGifWithImageName:@"dog.gif"];
    self.token = [ImgurAccessToken sharedToken];
    self.navigationItem.title = @"Post";
   self.currentImage.image = self.image;
    
    self.allSavedImages = [[NSMutableDictionary alloc]init];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    [self.view addSubview:self.spinner]; // spinner is not visible until started
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    //[self.navigationItem.title setTintColor:[UIColor whiteColor]];
    
    
    self.sharedButton.enabled = NO;
    self.deleteImageSelected.enabled = NO;
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
    //[self.spinner startAnimating];
    [GiFHUD show];
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
            //[self.spinner stopAnimating];
            [GiFHUD dismiss];
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
//[self.spinner stopAnimating];
            [GiFHUD dismiss];
       });
   }];
    

}

- (IBAction)deleteImage:(id)sender
{
    self.sharedButton.enabled = NO;
    imgurServerManager*x = [[imgurServerManager alloc]init];
    [x deleteImage:self.token.token
            completionBlock:^(NSString *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            UIAlertView *av = [[UIAlertView alloc]
                                               initWithTitle:@"Sucessfully deleted!"
                                               message:@""
                                               delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
                            [av show];
                            NSLog(@"%@",result);
                            self.sharedButton.enabled = YES;
                        });
                    }
      failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            [[[UIAlertView alloc] initWithTitle:@"Deletion Failed"
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

- (IBAction)loadImagesFromGallery:(id)sender
{
    [GiFHUD show];

    NSDictionary* temp;
    temp = [[NSDictionary alloc]initWithDictionary:[self receiveDataOfAlbums]];
    //[self.spinner startAnimating];
    self.albumObjects = [NSArray arrayWithArray:[self parsingOfReceivedDataFromAlbums:temp]];
    NSInteger qtyOfAlbums = [self.albumObjects count];
    imgurServerManager*x = [[imgurServerManager alloc]init];
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(int i=0; i<qtyOfAlbums; i++)
    {
        NSDictionary* tmp;
        UserAlbum*us = self.albumObjects[i];
        tmp = [[NSDictionary alloc]initWithDictionary:[x loadExistingImages:self.token.token
                                                                   idOfAlbun:us.idOfAlbum]];
        [array addObject:tmp];
    }
    self.allUserImages = [NSArray arrayWithArray:[self parsingImageData:array
                                                  albumData:self.albumObjects]];

 
}


-(NSDictionary*) receiveDataOfAlbums
{
    //[GiFHUD show];
imgurServerManager*x = [[imgurServerManager alloc]init];
    NSDictionary* temp;
   temp = [[NSDictionary alloc]initWithDictionary:[x loadImagesFromUserGallery:self.token.token
                                                                       username:self.token.userName
                                                                completionBlock:^(NSString *result)
                                                    {
                                                        dispatch_async(dispatch_get_main_queue(),
                                                                       ^{
                                                                           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                                                       });
                                                    }
                                                                   failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status)
                                                    {
                                                        dispatch_async(dispatch_get_main_queue(),
                                                                       ^{
                                                                           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                                                           
                                                                           [[[UIAlertView alloc] initWithTitle:@"Load Failed"
                                                                                                       message:[NSString stringWithFormat:@"%@ (Status code %ld)", [error localizedDescription], (long)status]
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:nil
                                                                                             otherButtonTitles:@"OK", nil] show];
                                                                           
                                                                       });
                                                        // return nil;
                                                    }]];
    
    
    return temp;
}

- (NSArray*) parsingImageData:(NSArray*)arrayWithDic
                    albumData:(NSArray*) albums
{
    NSMutableArray* tmp = [[NSMutableArray alloc]init];
    
    NSInteger qtyOfDicInArray = [arrayWithDic count];
    for(int i=0; i<qtyOfDicInArray; i++)
    {
        UserAlbum* us = [[UserAlbum alloc]init];
        
        us.albumName = [albums[i] albumName];
        NSInteger qtyOfImages = [[arrayWithDic[i]objectForKey:@"data"] count];
        for (int j=0; j< qtyOfImages; j++)
        {
            UserImage* image = [[UserImage alloc]init];
            image.title = [[arrayWithDic[i]objectForKey:@"data"][j]objectForKey:@"title"];
            image.descriptionImage = [[arrayWithDic[i]objectForKey:@"data"][j]objectForKey:@"description"];
            image.link = [[arrayWithDic[i]objectForKey:@"data"][j]objectForKey:@"link"];
            image.albumName = us.albumName;
            UIImage * imageFromURL = [self getImageFromURL:image.link];
            [self.allSavedImages setObject:imageFromURL forKey:image.link];
            //[self saveImagesToDisc:image.link];
            [tmp addObject:image];
        }
    }
    
    return tmp;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

//- (void)saveImageWithData:(NSData *)imageData withName:(NSString *)name {
//    NSData *data = imageData;
//    //DLog(@"*** SIZE *** : Saving file of size %lu", (unsigned long)[data length]);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
//    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
//}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        NSLog(@"Written to %@",directoryPath);
    }
    else
    {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}


-(void) saveImagesToDisc:(NSString*)url
{
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //Get Image From URL
    UIImage * imageFromURL = [self getImageFromURL:url];
    //NSData *data = UIImagePNGRepresentation(myImageView.image);
    //or
    NSData *data = UIImageJPEGRepresentation(imageFromURL, 0.8);    //Save Image to Directory
   //[self saveImage:imageFromURL withFileName:url ofType:@"jpg" inDirectory:documentsDirectoryPath];
    //[self saveImageWithData:data
    //               withName:url];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURL *urlLink = [NSURL URLWithString:url];
    //NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlLink
    //                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    //                          {
    //                              if (!error)
    //                              {
                                      static int finishedLoads = 0;
                                      finishedLoads ++;
                                      UIImage *image;
                                      if ([urlRequest.URL.pathExtension isEqualToString:@"jpg"] )
                                      {
                                          NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                          image = [UIImage imageWithData:data];
                                          [UIImageJPEGRepresentation(image, 0) writeToFile:[libraryPath stringByAppendingPathComponent:[[url pathComponents] lastObject]]
                                                                                 atomically:YES];
                                      }
    //                              }
    //                              else
    //                              {
                                      //[self.imageCache removeObjectForKey:[urlRequest.URL absoluteString]];
                                      //startedLoads--;
                                      
     //                                 NSLog(@"Image error:");
    //                              }
                                  
    //                          }];
    
    
    
    
}


- (NSArray*) parsingOfReceivedDataFromAlbums:(NSDictionary*)dict
{
    NSMutableArray* pars = [[NSMutableArray alloc]init];
    
    for(int i=0; i<[[dict objectForKey:@"data"]count]; i++)
    {
        UserAlbum* us = [[UserAlbum alloc]init];
        
        us.idOfAlbum = [[dict objectForKey:@"data"][i]objectForKey:@"id"];
        us.albumName = [[dict objectForKey:@"data"][i]objectForKey:@"title"];
        [pars addObject:us];
    }
    return pars;
}


- (IBAction)postActionSelected:(UIButton *)sender
{
    //[self.spinner startAnimating];
    [GiFHUD show];
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
                   self.deleteImageSelected.enabled = YES;
                  NSLog(@"%@",result);
                   //[self.spinner stopAnimating];
                   [GiFHUD dismiss];
               });
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
                   //[self.spinner stopAnimating];
                   [GiFHUD dismiss];
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
    else if ([segue.identifier isEqualToString:@"UsersImagesSegue"])
    {
        UsersImagesTableViewController * ipvc = (UsersImagesTableViewController *)segue.destinationViewController;
        ipvc.allImagesInDictionary = self.allSavedImages;
        ipvc.imagesList =  self.allUserImages;
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
//[self.spinner stopAnimating];
    [GiFHUD dismiss];
}
@end
