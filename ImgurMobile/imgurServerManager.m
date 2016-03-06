
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
#import "imgurAlbum.h"
#import "imgurPost.h"
#import "ImgurPagedConversation.h"
#import "imgurServerManager.h"
#import "ImgurLoginViewController.h"
#import "imgurUser.h"
#import "UserAlbum.h"

NSString * const IMGUR_SERVER_MANAGER_STATUS_KEY = @"error_status";
NSString * const IMGUR_SERVER_MANAGER_ERROR_KEY = @"error";

static NSString* imageID;

@interface imgurServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@property (strong, nonatomic) NSString *URLString;
@property (strong, nonatomic) URLGen *URLgenerator;
@property (strong, nonatomic) ImgurLoader *synchLoader;
@property (strong, nonatomic) ImgurJSONParser *parcer;
@property (strong, nonatomic) ImgurAccessToken* token;
//@property (strong, nonatomic) NSString* imageID;

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
         
         if (token)
         {
             
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
             
         }
         else if (completion) {
             completion(nil);
         }
         
     }];
//self.accessToken = token;
}


- (void) updateAccessToken: (NSString*) refresh_token
              access_token: (NSString*) access_token
           completionBlock:(void(^)(NSString* result))completion
              failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
    
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    _params[@"refresh_token"] = refresh_token;
    _params[@"client_id"] = @"b765b2f66708b7a";
    _params[@"client_secret"] = @"42569080cc7a7274a15a24d9074162b399959af1";
    _params[@"grant_type"] = @"refresh_token";

    self.token = [ImgurAccessToken sharedToken];
    NSLog(@"Refresh Token: %@", refresh_token);
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/oauth2/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    NSString* client_id = @"b765b2f66708b7a";
    NSString* client_secret = @"42569080cc7a7274a15a24d9074162b399959af1";
    NSString* grant_type = @"refresh_token";
   // [request setValue:[NSString stringWithFormat:@"Bearer %@", refresh_token] forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    // add params (all params are strings)
    for (NSString *param in _params)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (self.token.refresh_token)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"refresh_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[refresh_token dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    if (client_id)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[client_id dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (client_secret)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"client_secret\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[client_secret dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (grant_type)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"grant_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[grant_type dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
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
            if (completion)
            {
                
                completion([responseDictionary valueForKeyPath:@"data.link"]);
                self.token.token = [[responseDictionary objectForKey:@"data"]objectForKey:@"access_token"];
                self.token.refresh_token = [[responseDictionary objectForKey:@"data"]objectForKey:@"refresh_token"];
                self.token.expirationDate = [[responseDictionary objectForKey:@"data"]objectForKey:@"expires_in"];
                NSLog(@"Id is: %@", imageID);
            }
            
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

- (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
       access_token:(NSString*)token
              topic:(NSString*) topic
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
    NSAssert(imageData, @"Image data is required");
    //NSAssert(self.  , @"Access token is required");
    
//    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
//    _params[@"type"] = @"base64";
//    _params[@"name"] = @"myImage";
    NSLog(@"Token in Server: %@", token);
    NSString *urlString = @"https://api.imgur.com/3/image.json";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];

    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    //[request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";
    
   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
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
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: attachment; name=\"image\"; filename=\".tiff\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
        if (title) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    
    
        if (description) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        if (topic) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"topic\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([responseDictionary valueForKeyPath:@"data.error"]) {
            if (failureBlock)
            {
                if (!error)
                {
                   
                    error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
                }
                failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
            }
        }
        else
        {
            if (completion)
            {
                
                completion([responseDictionary valueForKeyPath:@"data.link"]);
                imageID = [[responseDictionary objectForKey:@"data"]objectForKey:@"id"];
                NSLog(@"Id is: %@", imageID);
            }
            
        }
        
    }];
}

-(NSDictionary*) loadImagesFromUserGallery:(NSString*) access_token
                                  username: (NSString*) name
                           completionBlock:(void(^)(NSString* result))completion
                              failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock

{
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/account/%@/albums/",name];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    //[request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
          NSURLResponse *res = nil;
      NSError *error = nil;

    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:
                                        [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error]
                                                                       options:NSJSONReadingMutableContainers error:nil];
    if (!error)
    {
        if ([[responseDictionary objectForKey:@"success"] boolValue])
        {
            return responseDictionary;
        }
        else
        {
            NSDictionary *data = [responseDictionary objectForKey:@"data"];
            
            
            return [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"error"],@"error_status", nil];
        }
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription,@"error", nil];
    }
    
//    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/account/%@/albums/",name];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    
//    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
//    [request setHTTPMethod:@"GET"];
//    NSMutableArray* currentAlbums = [[NSMutableArray alloc]init];
//        NSURLResponse *res = nil;
//    NSError *error = nil;
//    
//    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:
//                                        [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error]
//                                                                       options:NSJSONReadingMutableContainers error:nil];
//    
//    if ([responseDictionary valueForKeyPath:@"data.error"])
//    {
//        if (!error)
//        {
////            for(int i=0; i<[[responseDictionary objectForKey:@"data"]count]; i++)
////            {
////                UserAlbum* us = [[UserAlbum alloc]init];
////
////            us.idOfAlbum = [[responseDictionary objectForKey:@"data"][i]objectForKey:@"id"];
////            us.albumName = [[responseDictionary objectForKey:@"data"][i]objectForKey:@"title"];
////                [currentAlbums addObject:us];
////            }
//            return [responseDictionary objectForKey:@"data"];
//         }
//    }
//    else
//    {
//        error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
//
//        
//    }
//    
//    
//    //    if (!error)
//    //    {
//    //        if ([[responceDict objectForKey:@"success"] boolValue])
//    //        {
//    //            return responceDict;
//    //        }
//    //        else
//    //        {
//    //            NSDictionary *data = [responceDict objectForKey:@"data"];
//    //
//    //
//    //            return [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"error"],@"error_status", nil];
//    //        }
//    //    }
//    //    else
//    //    {
//  //return [NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription,@"error", nil];
//    //    }
//return nil;
}

-(NSDictionary*) loadExistingImages:(NSString*) access_token
                          idOfAlbun:(NSString*) albumId
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/album/%@/images",albumId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *res = nil;
    NSError *error = nil;
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:
                                        [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error]
                                                                       options:NSJSONReadingMutableContainers error:nil];
    if (!error)
    {
        if ([[responseDictionary objectForKey:@"success"] boolValue])
        {
            return responseDictionary;
        }
        else
        {
            NSDictionary *data = [responseDictionary objectForKey:@"data"];
            
            
            return [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"error"],@"error_status", nil];
        }
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription,@"error", nil];
    }
  
}


- (void) shareImageWithImgurCommunity:(NSString*)title
                           description:(NSString*)description
            access_token: (NSString*)token
                                topic:(NSString*) section
                      completionBlock:(void(^)(NSString* result))completion
                         failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
       NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    _params[@"id"] = @"imageID";
     NSLog(@"Token: %@", token);
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/image/%@", imageID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    // add params (all params are strings)
        for (NSString *param in _params)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    if (title)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (imageID)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[description dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (section)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"section\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![responseDictionary valueForKeyPath:@"success"] )
        {
            if (failureBlock)
            {
                if (!error)
                {
                    
                    error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
                }
                failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
            }
        } else
        {
            if (completion)
            {
                completion([responseDictionary valueForKeyPath:@"data"]);
                //self.imageID = [[responseDictionary objectForKey:@"data"]objectForKey:@"id"];
                //NSLog(@"Id is: %@", self.imageID);
            }
            
        }
        
    }];


}


- (void) deleteImage:(NSString*) access_token
     completionBlock:(void(^)(NSString* result))completion
        failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock
{
// https://api.imgur.com/3/image/{id}
    
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    _params[@"id"] = @"imageID";
    NSLog(@"Token: %@", access_token);
    NSString *urlString = [NSString stringWithFormat:@"https://api.imgur.com/3/image/%@", imageID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"DELETE"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    // add params (all params are strings)
    for (NSString *param in _params)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (imageID)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[imageID dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![responseDictionary valueForKeyPath:@"success"] )
        {
            if (failureBlock)
            {
                if (!error)
                {
                    
                    error = [NSError errorWithDomain:@"imguruploader" code:10000 userInfo:@{NSLocalizedFailureReasonErrorKey : [responseDictionary valueForKeyPath:@"data.error"]}];
                }
                failureBlock(response, error, [[responseDictionary valueForKey:@"status"] intValue]);
            }
        } else
        {
            if (completion)
            {
                completion([responseDictionary valueForKeyPath:@"data"]);
                //self.imageID = [[responseDictionary objectForKey:@"data"]objectForKey:@"id"];
                //NSLog(@"Id is: %@", self.imageID);
            }
            
        }
        
    }];
    
}

- (void)getPhotosForPage:(NSInteger)page
                 Section:(section)section
                    Sort:(sort)sort
                  Window:(window)window
              Completion:(void(^)(NSDictionary *resp))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       NSString *url = [weakSelf.URLgenerator getGalleryURLForPage:page Section:section Sort:sort Window:window];
                       
                       NSDictionary *loadedDict = [weakSelf.synchLoader loadJSONFromURL:url];
                       if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       else if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       else
                       {
                           NSDictionary *parcedDict = [weakSelf.parcer getPostsFromresponceDictionary:loadedDict];
                           
                           NSArray *posts = [parcedDict objectForKey:@"posts"];
                           NSMutableArray *albums = [NSMutableArray array];
                           
                           NSArray *albumIds = [parcedDict objectForKey:@"albumIds"];
                           for (NSString *albumID in albumIds)
                           {
                               NSString *albumUrl = [weakSelf.URLgenerator getAlbumURLForAlbumWithID:albumID];
                               
                               NSDictionary *loadedAlbumDict = [weakSelf.synchLoader loadJSONFromURL:albumUrl];
                               
                               ImgurAlbum *album = [weakSelf.parcer getAlbumFromResponceDict:loadedAlbumDict];
                               [albums addObject:album];
                           }
                           
                           NSMutableDictionary *albumsAndPosts = [[NSMutableDictionary alloc] init];
                           
                           if (posts)
                           {
                               [albumsAndPosts setObject:posts forKey:@"posts"];
                               /*for (imgurPost *post in posts)
                               {
                                   NSString *urlComentString = [self.URLgenerator getComentsIdsForID:post.postID URLIsAlbum:NO];
                                   NSDictionary *loadedComentDict = [self.synchLoader loadJSONFromURL:urlComentString];
                                   NSArray *comentsIDs = [self.parcer getCommetsArrayFromRsponceDict:loadedComentDict];
                                   post.commentsIds = comentsIDs;
                               }*/
                           }
                           if (albums)
                           {
                               [albumsAndPosts setObject:albums forKey:@"albums"];
                               /*for (imgurAlbum *album in albums)
                               {
                                   NSString *urlComentString = [self.URLgenerator getComentsIdsForID:album.albumID URLIsAlbum:YES];
                                   NSDictionary *loadedComentDict = [self.synchLoader loadJSONFromURL:urlComentString];
                                   NSArray *comentsIDs = [self.parcer getCommetsArrayFromRsponceDict:loadedComentDict];
                                   album.commentsIds = comentsIDs;
                               }*/
                           }
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(albumsAndPosts);
                                          });
                       }
                   });
}

- (void)getComentsForId:(NSString *)identifier IsAlbum:(BOOL) isAlbum
              Completion:(void(^)(NSArray *resp))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSArray *comentsIDs;
                       if (isAlbum)
                       {
                           NSString *urlComentString = [weakSelf.URLgenerator getComentsIdsForID:identifier URLIsAlbum:YES];
                           NSDictionary *loadedComentDict = [weakSelf.synchLoader loadJSONFromURL:urlComentString];
                           comentsIDs = [weakSelf.parcer getCommetsArrayFromResponceDict:loadedComentDict];
                       }
                       else
                       {
                           NSString *urlComentString = [weakSelf.URLgenerator getComentsIdsForID:identifier URLIsAlbum:NO];
                           NSDictionary *loadedComentDict = [weakSelf.synchLoader loadJSONFromURL:urlComentString];
                           comentsIDs = [weakSelf.parcer getCommetsArrayFromResponceDict:loadedComentDict];
                       }
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(comentsIDs);
                                          });
                   });
}


- (void)getAllConversationsPreviewForCurrentUserCompletion:(void(^)(NSArray *resp))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       NSString *url = [weakSelf.URLgenerator getConversationsListURL];
                       
                       NSDictionary *loadedDict = [weakSelf.synchLoader loadJSONFromURL:url];
                       
                       NSArray *parcedConversations = [weakSelf.parcer getConversationPreviewsArrayFromResponceDict:loadedDict];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          completion(parcedConversations);
                                      });
                   });
}

- (void)getConversationWithID:(NSInteger)identifier
                          ForPage:(NSInteger)page
                       Completion:(void(^)(ImgurPagedConversation *resp))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       NSString *url = [weakSelf.URLgenerator getURLForConversationWithID:identifier Page:page];
                       
                       NSDictionary *loadedDict = [weakSelf.synchLoader loadJSONFromURL:url];
                       
                       ImgurPagedConversation *conversation = [weakSelf.parcer getConversationFromResponceDict:loadedDict];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          completion(conversation);
                                      });
                   });
}

- (void)createMessageWithUser:(NSString *)userName
                      Message:(NSString *)message
                   Completion:(void(^)(NSDictionary *dict))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       NSString *url = [weakSelf.URLgenerator getURLForMessageCreationWithUser:userName];
                       
                       NSDictionary *loadedDict = [weakSelf.synchLoader createMessageWithURL:url Message:message];
                       
                       if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       else if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       
                       BOOL success = [weakSelf.parcer getMessageSendingResult:loadedDict];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          completion([NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:success], @"success", nil]);
                                      });
                   });
}

- (void)deleteConversationWithID:(NSInteger)identifier
                      Completion:(void(^)(NSDictionary *dict))completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       NSString *url = [weakSelf.URLgenerator getURLDeletionOfConversationWithID:identifier];
                       
                       NSDictionary *loadedDict = [weakSelf.synchLoader deleteConversationWithURL:url];
                       
                       if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_ERROR_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       else if ([loadedDict objectForKey:IMGUR_SERVER_MANAGER_STATUS_KEY])
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              completion(loadedDict);
                                          });
                       
                       BOOL success = [weakSelf.parcer getMessageSendingResult:loadedDict];
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          completion([NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:success], @"success", nil]);
                                      });
                   });
}

@end

