//
//  VKServerManager.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "imgurJSONParser.h"
#import "imgurServerManager.h"
#import "ImgurLoginViewController.h"
#import "imgurUser.h"
#import "ImgurAccessToken.h"

@interface imgurServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) ImgurAccessToken* accessToken;
@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) URLGen *generator;

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

- (URLGen *)generator
{
    if (!_generator)
    {
        _generator = [URLGen sharedInstance];
        _generator.baseURL = @"https://api.imgur.com/3/";
    }
    return _generator;
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

- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
                Completion:(void(^)(NSDictionary *resp, NSError *error))completion
{
    
    NSString *url = [self.generator GetGalleryURLForPage:page Section:section Sort:sort Window:window];
    
    [self.requestOperationManager
     GET:url
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             imgurJSONParser *parser = [[imgurJSONParser alloc] init];
             [parser getPostsFromResponceDict:responseObject Completion:^(NSArray *array, NSError *error) {
                 NSLog(@"%lu,%@",array.count,array);
             }];
         });
         
         completion(responseObject, nil);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             completion(nil, error);
         });
     }];

}

- (void)getPhotosFromAlbumWithID:(NSString *)albumID Completion:(void(^)(NSDictionary *resp, NSError *error))completion
{
    NSString *url = [NSString stringWithFormat:@"gallery/album/%@",albumID];
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
}

@end
