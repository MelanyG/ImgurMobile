//
//  SocialViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "SocialViewController.h"
#import "RESTAPI.h"
#import "ImgurAccessToken.h"
#import "buttonsVC.h"
#import "Comment.h"
#import "ImageTableViewController.h"
#import "imgurPost.h"
#import "imgurAlbum.h"

@interface SocialViewController () <RESTAPIDelegate>

@property (strong, nonatomic) RESTAPI *restApi;
@property (strong, nonatomic) NSCharacterSet* set;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) buttonsVC* bvc;
@property (strong, nonatomic) NSDictionary *receivedData;
@property (strong, nonatomic) ImageTableViewController* imageTableVC;

@end

@implementation SocialViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buttonsSegue"])
    {
        self.bvc = (buttonsVC*)segue.destinationViewController;
        self.bvc.socialVC = self;
    }
    else if ([segue.identifier isEqualToString:@"socialContainerViewSegue"])
    {
        self.imageTableVC = (ImageTableViewController*)segue.destinationViewController;
        self.imageTableVC.socialVC = self;
    }
    
}

-(RESTAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RESTAPI alloc] init];
    }
    return _restApi;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.postObject isKindOfClass:[imgurAlbum class]])
    {
        self.album = self.postObject;
        self.albumID = self.album.albumID;
        if ([self.album.albumDescription isKindOfClass:[NSString class]]) {
            self.socialImageDescription.text = self.album.albumDescription;
        }
        else{
            self.socialImageDescription.text = @"NO DESCRIPTION";
        }
        
    }
    else if ([self.postObject isKindOfClass:[imgurPost class]])
    {
        self.post = self.postObject;
        self.imageID = self.post.postID;
        if ([self.post.postDescription isKindOfClass:[NSString class]]) {
            self.socialImageDescription.text = self.post.postDescription;
        }
        else{
            self.socialImageDescription.text = @"NO DESCRIPTION";
            
        }
        self.imageToEdit = self.image;
    }
    
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.accessToken = [ImgurAccessToken sharedToken].token;
   
    self.commentsArray = [[NSMutableArray alloc] init];

}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)commentsRequest
{
    NSString* urlString;
    if (self.imageID) {
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/comments", self.imageID];
    }
    else if (self.albumID){
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/album/%@/comments", self.albumID];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(returnData)
    {
        self.receivedData =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&error];
        [self createCommentsArray];
        
    }

}

- (NSString*)getAutherAvatarIDWithID:(NSString*) avatarID
{
    
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/image/%@", avatarID];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* data;
    if(returnData)
    {
        self.receivedData =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&error];
        data = [[self.receivedData objectForKey:@"data"] objectForKey:@"link"];
    }
    return data;
}


-(void) postComment
{
    NSString* urlString;
    if (self.imageID) {
        urlString =[NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/comment",self.imageID];
    }
    else if (self.albumID){
        urlString =[NSString stringWithFormat:@"https://api.imgur.com/3/gallery/album/%@/comment",self.albumID];
    }
    NSString* params = [NSString stringWithFormat:@"comment=%@",self.commentToPost];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    
}
-(void) likeCommentRequestByID:(NSString*) commentID
{
    
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/comment/%@/vote/up", commentID];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    
}
-(void) dislikeCommentRequestByID:(NSString*) commentID
{
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/comment/%@/vote/down", commentID];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    
}

-(void) favoritesRequest
{
    NSString* urlString;
    if (self.imageID) {
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/image/%@/favorite", self.imageID];
    }
    else if (self.albumID){
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/album/%@/favorite", self.albumID];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];

}

-(void) likeRequest
{
    NSString* urlString;
    if (self.imageID) {
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/vote/up", self.imageID];
    }
    else if (self.albumID){
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/album/%@/vote/up", self.albumID];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    
}

-(void) dislikeRequest
{
    NSString* urlString;
    if (self.imageID) {
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/vote/down", self.imageID];
    }
    else if (self.albumID){
        urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/album/%@/vote/down", self.albumID];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    
}

- (void)getReceivedData:(NSMutableData *)data sender:(RESTAPI *)sender
{
    NSError *error = nil;
    self.receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
}
- (void)createCommentsArray
{
    NSArray* parsedData = [self.receivedData objectForKey:@"data"];
    self.commentsCount = [parsedData count];
    
    for (int i = 0; i < self.commentsCount; i++)
    {
        Comment* comment = [[Comment alloc] initWithAuthorID:[[parsedData objectAtIndex:i] objectForKey:@"author_id"]
                                              withAuthorName:[[parsedData objectAtIndex:i] objectForKey:@"author"]
                                                 withComment:[[parsedData objectAtIndex:i] objectForKey:@"comment"]
                                            withAuthorAvatarID:[[parsedData objectAtIndex:i] objectForKey:@"image_id"]
                                           withCommentPoints:[[parsedData objectAtIndex:i] objectForKey:@"points"]
                                               withCommentID:[[parsedData objectAtIndex:i] objectForKey:@"id"]];
        [self.commentsArray addObject:comment];
        
    }
    
}



@end
