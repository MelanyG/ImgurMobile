//
//  MainViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "MainViewController.h"
#import "imgurServerManager.h"
#import "imgurJSONParser.h"
#import "NotChalengingQueue.h"
#import "imgurCell.h"
#import "UIImageView+AFNetworking.h"
#import "imgurPost.h"
#import "AFNetworking.h"
#import "PageInfoViewController.h"
#import "imgurAlbum.h"
#import "SocialViewController.h"
#import "PageSelectViewController.h"

#import "UIImage+animatedGIF.h"

@interface MainViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableDictionary *photosData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSCache* imageCache;
@property (strong, nonatomic) ImgurAccessToken* token;
@property (strong, nonatomic) NSMutableDictionary* pageInfo;
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) ImgurLoginViewController* loginVC;
@property (strong, nonatomic) imgurServerManager *manager;

@property (strong, nonatomic) NSIndexPath *selectedCell;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) imgurPost * selectedPost;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    self.token = [ImgurAccessToken sharedToken];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(reloadPage)
               name:LoginNotification
             object:nil];
    
    
     if ([[NSDate date] compare:self.token.expirationDate] == NSOrderedAscending)
 {
     NSLog(@"Access token is valid!");
     
     
 }
     else
     {
         imgurServerManager*x = [imgurServerManager sharedManager];

     [x updateAccessToken:self.token.refresh_token
             access_token: self.token.token
          completionBlock:^(NSString *result)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
              UIAlertView *av = [[UIAlertView alloc]
                                 initWithTitle:@"Sucessfully received access_token!"
                                 message:@"Go ahead!!!"
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
              [av show];
              //self.sharedButton.enabled = YES;
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
          });
      }];

     }

        [super viewDidLoad];
     // self.navigationItem.title = self.token.userName;
    

    
    
}

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.imageCache = [[NSCache alloc] init];
    
    if (!self.pageInfo)
    {
        NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
        
        [info setObject:[NSNumber numberWithInt:0] forKey:@"section"];
        [info setObject:[NSNumber numberWithInt:0] forKey:@"sort"];
        [info setObject:[NSNumber numberWithInt:0] forKey:@"window"];
        self.navigationItem.title = self.token.userName;
        self.pageInfo = info;
        self.pageNumber = 0;
        [self reloadPage];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callingLoginVC
{
    self.loginVC = [[ImgurLoginViewController alloc]init];
    [self.navigationController pushViewController:self.loginVC animated:YES];
    //[self reloadPage];
}

-(void) reloadPage
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center = self.collectionView.center;
    [self.activityIndicator startAnimating];
    
    
    NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    
    if (!self.manager)
        self.manager = [[imgurServerManager alloc] init];
    
    [self.manager getPhotosForPage:self.pageNumber
                           Section:[[self.pageInfo objectForKey:@"section"] intValue]
                              Sort:[[self.pageInfo objectForKey:@"sort"] intValue]
                            Window:[[self.pageInfo objectForKey:@"window"] intValue] Completion:^(NSDictionary *resp)
     {
         if ([resp objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
         {
             NSLog(@"%@", [resp objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY]);
         }
         else if ([resp objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
         {
             // self.loginVC = [[ImgurLoginViewController alloc]init];
             //[self.navigationController pushViewController:self.loginVC animated:YES];
            
             
//             [[[UIAlertView alloc] initWithTitle:@"Failed to enter into account"
//                                         message:@"PLEASE LOG IN"
//                                        delegate:nil
//                               cancelButtonTitle:nil
//                               otherButtonTitles:@"OK", nil] show];
             NSLog(@"%@", [resp objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY]);
             [self performSelectorOnMainThread:@selector(callingLoginVC) withObject:nil waitUntilDone:YES];
             
         }
         else
         {
             [self.activityIndicator stopAnimating];
             self.activityIndicator = nil;
             [queue addObject:resp];
             
             self.photosData = [queue getObject];
             NSLog(@"%@", self.photosData);
             
             
             [self.collectionView reloadData];
             if (([[self.photosData objectForKey:@"posts"] count] + [[self.photosData objectForKey:@"albums"] count]) != 0)
                 [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                             atScrollPosition:UICollectionViewScrollPositionTop
                                                     animated:YES];
         }
     }];
}

#pragma mark- UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imgurCell *tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgurCell" forIndexPath:indexPath];
    imgurPost * post;// = [[self.photosData objectForKey:@"posts"] objectAtIndex:indexPath.row];
    if (indexPath.row < [[self.photosData objectForKey:@"albums"] count])
    {
        NSArray *albums = [self.photosData objectForKey:@"albums"]  ;
        post = [[(imgurAlbum *)[albums objectAtIndex:indexPath.row] posts] firstObject];
        tempCell.ownerLabel.text = @"album";
        tempCell.titleLabel.text = [[albums objectAtIndex:indexPath.row] albumTitle];
        tempCell.pointsLabel.text = [[[albums objectAtIndex:indexPath.row] points] stringValue];
    }
    else
    {
        post = [[self.photosData objectForKey:@"posts"] objectAtIndex:(indexPath.row - [[self.photosData objectForKey:@"albums"] count])];
        if ([post.imageURL hasSuffix:@"gif"])
            tempCell.ownerLabel.text = @"animated";
        else
            tempCell.ownerLabel.text = @"image";
        
        tempCell.titleLabel.text = post.title;
        tempCell.pointsLabel.text = [post.points stringValue];
    }
    

    
    if ([self.imageCache objectForKey:post.imageURL])
    {//if there is image in cache setImage
        static int i = 0;
        i++;
        NSLog(@"images cache used %d", i);
        [tempCell.imageView setImage: [self.imageCache objectForKey:post.imageURL]];

    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[[post.imageURL pathComponents] lastObject]]])
    {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[[post.imageURL pathComponents]lastObject]];
        [tempCell.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            UIImage *image;
            if ([[path pathExtension] isEqualToString:@"gif"])
                image = [UIImage animatedImageWithAnimatedGIFData:imageData];
            else
                image = [UIImage imageWithData:imageData];
            [self.imageCache setObject:image forKey:post.imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tempCell.imageView setImage: image];
            });
        });

        static int a = 0;
        a++;
        NSLog(@"images loaded from disk %d", a);
    }
    else
    {// if no such image in cache fill cell with default image and start load
        static int startedLoads = 0;
        startedLoads++;
        [self.imageCache setObject:[UIImage imageNamed:@"placeholder"] forKey:post.imageURL];
        [tempCell.imageView setImage:[UIImage imageNamed:@"placeholder"]];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post.imageURL]];
        
        NSURL *url = [NSURL URLWithString:post.imageURL];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (!error)
                                      {
                                          static int finishedLoads = 0;
                                          finishedLoads ++;
                                          NSLog(@"loads started: %d ------- loads finished: %d", startedLoads, finishedLoads);
                                          UIImage *image;
                                          if ([urlRequest.URL.pathExtension isEqualToString:@"gif"] )
                                          {
                                              NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                              [data writeToFile:[libraryPath stringByAppendingPathComponent:[[post.imageURL pathComponents] lastObject]]
                                                     atomically:YES];
                                              image = [UIImage animatedImageWithAnimatedGIFData:data];
                                              
                                          }
                                          else
                                          {
                                              NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                              image = [UIImage imageWithData:data];
                                              [UIImageJPEGRepresentation(image, 0)  writeToFile:[libraryPath stringByAppendingPathComponent:[[post.imageURL pathComponents] lastObject]]
                                                                                     atomically:YES];
                                          }
                                          [self.imageCache setObject:image forKey:[urlRequest.URL absoluteString]];
                                          dispatch_async(dispatch_get_main_queue(),
                                                         ^{
                                                             imgurCell *tempCellForIndexPath = (imgurCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                                                             [tempCellForIndexPath.imageView setImage:image];
                                                         });
                                      }
                                      else
                                      {
                                          [self.imageCache removeObjectForKey:[urlRequest.URL absoluteString]];
                                          startedLoads--;
                                          
                                          NSLog(@"Image error:");
                                      }
                                  }];
        [task resume];
    }
    //[tempCell.imageView setImageWithURL:[NSURL URLWithString:post.imageURL]]; //:[self.photos objectAtIndex:indexPath.row]];
    
    return tempCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.photosData objectForKey:@"posts"] count] + [[self.photosData objectForKey:@"albums"] count];
}

#pragma mark- UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 200);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = indexPath;

    
    if (self.selectedCell.row < [[self.photosData objectForKey:@"albums"] count])
    {
        NSArray *albums = [self.photosData objectForKey:@"albums"]  ;
        self.selectedPost  = (imgurAlbum *)[albums objectAtIndex:self.selectedCell.row] ;//jedi mind trick
    }
    else
    {
        self.selectedPost = [[self.photosData objectForKey:@"posts"] objectAtIndex:(self.selectedCell.row - [[self.photosData objectForKey:@"albums"] count])];
    }
    
    imgurCell *selectedCell = (imgurCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    self.selectedImage = [[selectedCell imageView] image];
    
    [self performSegueWithIdentifier:@"SocialVC" sender:self];
}


#pragma mark- PageInfoDelegate

-(void)pageInfoDidChange:(NSMutableDictionary *) info
{
    if (!self.activityIndicator)
    {
        if ([info isKindOfClass:[NSDictionary class]])
            self.pageInfo = info;
        [self reloadPage];
    }
}

-(void) pageNumDidChange: (NSInteger) param
{
    if (!self.activityIndicator)
    {
        self.pageNumber = ((param + self.pageNumber) < 0)?0:(self.pageNumber + param);
        [self reloadPage];
    }
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
 {
     if ([segue.identifier isEqualToString:@"PageInfoEmbed"])
     {
         PageInfoViewController * pivc = segue.destinationViewController;
         pivc.delegate = self;
     }
     if ([segue.identifier isEqualToString:@"SocialVC"])
     {
         SocialViewController * svc = segue.destinationViewController;
         //self.bvc = [[buttonsVC alloc] init];
         svc.socialVCDelegate = svc;
         //[svc.socialImage setImage:self.selectedImage];
         
         svc.imageID = self.selectedPost.postID;
         //svc.socialImageDescription.text = (![self.selectedPost.postDescription isKindOfClass:[NSNull class]])?self.selectedPost.postDescription:@"null description";
         svc.imageTitel.title = (![self.selectedPost.title isKindOfClass:[NSNull class]])?self.selectedPost.title:@"null title";
         
         svc.image = self.selectedImage;
         svc.post = self.selectedPost;
     }
     if ([segue.identifier isEqualToString:@"pageSelectVC"])
     {
         PageSelectViewController * psvc = segue.destinationViewController;
         psvc.delegate = self;
     }
}
//@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
//@property (strong, nonatomic) NSString* imageID;
//@property (weak, nonatomic) IBOutlet UITextView *socialImageDescription;
//@property (weak, nonatomic) IBOutlet UINavigationItem *imageTitel;
//@property (strong, nonatomic) NSString* albumID;

@end
