
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
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
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
//self.accessToken = token;
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

- (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
       access_token:(NSString*)token
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
    NSAssert(imageData, @"Image data is required");
    //NSAssert(self.  , @"Access token is required");
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    _params[@"type"] = @"base64";
    _params[@"name"] = @"myImage";
    NSLog(@"Token: %@", token);
    NSString *urlString = @"https://api.imgur.com/3/image.json";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];

    [request setURL:[NSURL URLWithString:urlString]];
    //[request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //[request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *BoundaryConstant = @"---------------------------0983745982375409872438752038475287";
    
   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    // add params (all params are strings)
//    for (NSString *param in _params) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageData, 1.0);
    if (imageData) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:imageData];
//        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
 //   NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
 //   [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
 //   [request setHTTPBody:body];    //[request addValue:[NSString stringWithFormat:@"access_token %@", access_token] forHTTPHeaderField:@"access_token"];
 
//    [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestBody appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [requestBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [requestBody appendData:[NSData dataWithData:imageData]];
//    [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//
//    if (title) {
//        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//
//    if (description) {
//        [requestBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
//        [requestBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [requestBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:requestBody];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([responseDictionary valueForKeyPath:@"data.error"]) {
            if (failureBlock) {
                if (!error) {
                   
                    error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
                }
                failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
            }
        } else {
            if (completion) {
                completion([responseDictionary valueForKeyPath:@"data.link"]);
            }
            
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

