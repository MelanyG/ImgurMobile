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

#import "UIImage+animatedGIF.h"

@interface MainViewController ()

@property (strong, nonatomic) NSMutableDictionary *photosData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSCache* imageCache;
@property (strong, nonatomic) ImgurAccessToken* token;
@property (strong, nonatomic) NSMutableDictionary* pageInfo;
@property (assign, nonatomic) NSUInteger pageNumber;

@property (strong, nonatomic) imgurServerManager *manager;

@property (strong, nonatomic) NSIndexPath *selectedCell;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) imgurPost * selectedPost;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    self.token = [ImgurAccessToken sharedToken];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.imageCache = [[NSCache alloc] init];
    

    NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
    
    [info setObject:[NSNumber numberWithInt:0] forKey:@"section"];
    [info setObject:[NSNumber numberWithInt:0] forKey:@"sort"];
    [info setObject:[NSNumber numberWithInt:0] forKey:@"window"];
     self.navigationItem.title = self.token.userName;
    self.pageInfo = info;
    self.pageNumber = 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadPage
{
    NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    
    if (!self.manager)
        self.manager = [[imgurServerManager alloc] init];
    
    [self.manager getPhotosForPage:self.pageNumber
                      Section:[[self.pageInfo objectForKey:@"section"] intValue]
                         Sort:[[self.pageInfo objectForKey:@"sort"] intValue]
                       Window:[[self.pageInfo objectForKey:@"window"] intValue] Completion:^(NSDictionary *resp)
     {
         [queue addObject:resp];
         
         self.photosData = [queue getObject];
         NSLog(@"%@", self.photosData);
         [self.collectionView reloadData];
     }];
}


-(void)preparePhotos
{
    self.photos = [NSMutableArray array];
    NSArray *posts = [self.photosData objectForKey:@"posts"];
    for (imgurPost *post in posts)
    {
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.imageURL]]];
        

        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post.imageURL]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            //operation.request.URL
            NSLog(@"Response: %@", responseObject);
            UIImage *image = responseObject;
            [self.photos addObject:image];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
    }
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
        if (![post.title isKindOfClass:[NSNull class]])
        {
            tempCell.titleLabel.text = post.title;
        }
    }
    else
    {
        post = [[self.photosData objectForKey:@"posts"] objectAtIndex:(indexPath.row - [[self.photosData objectForKey:@"albums"] count])];
        if ([post.imageURL hasSuffix:@"gif"])
            tempCell.ownerLabel.text = @"animated";
        else
            tempCell.ownerLabel.text = @"image";
        
        tempCell.titleLabel.text = post.title;
    }
    


    tempCell.pointsLabel.text = @"nope";
    


    
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
        
        if ([[path pathExtension] isEqualToString:@"gif"])
        {
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage animatedImageWithAnimatedGIFData:imageData];
            [tempCell.imageView setImage: image];
            [self.imageCache setObject:image forKey:post.imageURL];
        }
        else
        {
            NSData *imageData = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage imageWithData:imageData];
            [tempCell.imageView setImage: image];
            [self.imageCache setObject:image forKey:post.imageURL];
        }
        
        NSLog(@"ura");
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
        self.selectedPost  = [[(imgurAlbum *)[albums objectAtIndex:self.selectedCell.row] posts] firstObject];
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
    if ([info isKindOfClass:[NSDictionary class]])
        self.pageInfo = info;
    [self reloadPage];
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
}
//@property (weak, nonatomic) IBOutlet UIImageView *socialImage;
//@property (strong, nonatomic) NSString* imageID;
//@property (weak, nonatomic) IBOutlet UITextView *socialImageDescription;
//@property (weak, nonatomic) IBOutlet UINavigationItem *imageTitel;
//@property (strong, nonatomic) NSString* albumID;

@end
