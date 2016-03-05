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

@interface SocialViewController () <RESTAPIDelegate>

@property (strong, nonatomic) RESTAPI *restApi;
@property (strong, nonatomic) NSCharacterSet* set;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) buttonsVC* bvc;
@property (strong, nonatomic) NSDictionary *receivedData;


@end

@implementation SocialViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buttonsSegue"])
    {
        self.bvc = (buttonsVC*)segue.destinationViewController;
        self.bvc.socialVC = self.socialVCDelegate;
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
    
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.accessToken = [ImgurAccessToken sharedToken].token;
    self.socialImage.image = self.image;
    if ([self.post.postDescription isKindOfClass:[NSString class]]) {
        self.socialImageDescription.text = self.post.postDescription;
    }
    else{
        self.socialImageDescription.text = @"NO DESCRIPTION";
    }
    self.commentsArray = [[NSMutableArray alloc] init];
    
    //[self httpGetRequest];
}

- (void)commentsRequest
{
    
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/comments", self.imageID];
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

/*- (void)commentsRequest
{
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/comments", self.imageID];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
    [self createCommentsArray];
}*/



-(void) favoritesRequest
{
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/image/%@/favorite", self.imageID];
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
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/vote/up", self.imageID];
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
    NSString* urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@/vote/down", self.imageID];
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
                                           withCommentPoints:[[parsedData objectAtIndex:i] objectForKey:@"points"]];
        [self.commentsArray addObject:comment];
        
    }
    
}



@end
