
//
//  VKServerManager.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ImgurJSONParser.h"
#import "ImgurLoader.h"
#import "ImgurAlbum.h"
#import "imgurServerManager.h"
#import "ImgurLoginViewController.h"
#import "imgurUser.h"
#import "ImgurAccessToken.h"

@interface imgurServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) ImgurAccessToken* accessToken;
@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) URLGen *URLgenerator;
@property (strong, nonatomic) ImgurLoader *synchLoader;
@property (strong, nonatomic) ImgurJSONParser *parcer;

@end

@implementation imgurServerManager

+ (instancetype)sharedManager
{
    static imgurServerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[imgurServerManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.imgur.com/3/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return self;
}

- (URLGen *)URLgenerator
{
    if (!_URLgenerator)
    {
        _URLgenerator = [URLGen sharedInstance];
        _URLgenerator.baseURL = @"https://api.imgur.com/3/";
    }
    return _URLgenerator;
}

- (ImgurLoader *)synchLoader
{
    if (!_synchLoader)
    {
        _synchLoader = [ImgurLoader sharedLoader];
    }
    return _synchLoader;
}

- (ImgurJSONParser *)parcer
{
    if (!_parcer)
    {
        _parcer = [ImgurJSONParser sharedJSONParser];
    }
    return _parcer;
}


- (void) authorizeUser:(void(^)(imgurUser* user)) completion {
    
    ImgurLoginViewController* vc =
    [[ImgurLoginViewController alloc] initWithCompletionBlock:^(ImgurAccessToken *token)
     {
         
         self.accessToken = token;
         
         if (token) {
             
             [self getUser:self.accessToken.accountID
                 onSuccess:^(imgurUser *user) {
                     if (completion) {
                         completion(user);
                     }
                 }
                 onFailure:^(NSError *error, NSInteger statusCode) {
                     if (completion) {
                         completion(nil);
                     }
                 }];
             
         } else if (completion) {
             completion(nil);
         }
         
     }];

}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(imgurUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0) {
             imgurUser* user = [[imgurUser alloc] initWithServerResponse:[dictsArray firstObject]];
             if (success) {
                 success(user);
             }
         } else {
             if (failure) {
                 failure(nil, operation.response.statusCode);
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.response.statusCode);
         }
     }];
}

- (void) postImage:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
         if (![groupID hasPrefix:@"-"]) {
            groupID = [@"-" stringByAppendingString:groupID];
        }
        
        NSDictionary* params =
        [NSDictionary dictionaryWithObjectsAndKeys:
         groupID,       @"owner_id",
         text,          @"message",
         self.accessToken.token, @"access_token", nil];
        
        [self.requestOperationManager
         POST:@"wall.post"
         parameters:params
         success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
             NSLog(@"JSON: %@", responseObject);
             
             if (success) {
                 success(responseObject);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             if (failure) {
                 failure(error, operation.response.statusCode);
             }
         }];
        
 
}

- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
              Completion:(void(^)(NSDictionary *resp))completion
{
    NSString *url = [self.URLgenerator GetGalleryURLForPage:page Section:section Sort:sort Window:window];
    
    /*__block NSDictionary *loadedDict;
     
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
     {
     loadedDict = [self.synchLoader loadJSONFromURL:url];
     });*/
    
    NSDictionary *loadedDict = [self.synchLoader loadJSONFromURL:url];
    
    NSDictionary *parcedDict = [self.parcer getPostsFromresponceDictionary:loadedDict];
    
    NSArray *posts = [parcedDict objectForKey:@"posts"];
    NSMutableArray *albums = [NSMutableArray array];
    
    NSArray *albumIds = [parcedDict objectForKey:@"albumIds"];
    for (NSString *albumID in albumIds)
    {
        NSString *albumUrl = [self.URLgenerator GetAlbumURLForAlbumWithID:albumID];
        
        NSDictionary *loadedAlbumDict = [self.synchLoader loadJSONFromURL:albumUrl];
        
        ImgurAlbum *album = [self.parcer getAlbumFromResponceDict:loadedAlbumDict];
        [albums addObject:album];
    }
    
    NSMutableDictionary *albumsAndPosts = [[NSMutableDictionary alloc] init];
    [albumsAndPosts setObject:posts forKey:@"posts"];
    [albumsAndPosts setObject:albums forKey:@"albums"];
    
    completion(albumsAndPosts);
}










/*
 - (void)getPhotosFromAlbumWithID:(NSString *)albumID Completion:(void(^)(NSDictionary *resp, NSError *error))completion
 {
 NSString *url = [self.URLgenerator GetAlbumURLForAlbumWithID:albumID];
 
 [self.requestOperationManager
 GET:url
 parameters:nil
 success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
 {
 dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 completion(responseObject, nil);
 });
 }
 failure:^(AFHTTPRequestOperation *operation, NSError *error)
 {
 dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 completion(nil, error);
 });
 }];
 }*/

@end

