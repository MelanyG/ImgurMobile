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

/*- (void)createBaseUrlString
{
    self.URLString = @"https://api.imgur.com/3/";
}*/

/*
- (void) authorizeUser:(void(^)(VKUser* user)) completion
{
    __typeof(self) __weak weakSelf = self;
    VKLoginViewController* VKlvc = [[VKLoginViewController alloc] initWithCompletionBlock:^(VKAccessToken *token)
                                    {
                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                                       {
                                                           weakSelf.accessToken = token;
                                                           
                                                           if (token)
                                                           {
                                                               [weakSelf getUser:weakSelf.accessToken.userID
                                                                   onSuccess:^(VKUser *user)
                                                                {
                                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                                                    {
                                                                    [weakSelf getFriendsOfCurrentUserOnSuccess:^(VKUser *user)
                                                                     {
                                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                                                         {
                                                                         if (completion)
                                                                         {
                                                                             completion(user);
                                                                         }
                                                                         });
                                                                         
                                                                     } onFailure:^(NSError *error, NSInteger statusCode)
                                                                     {
                                                                         
                                                                     }];
                                                                     });
                                                                    
                                                                }
                                                                   onFailure:^(NSError *error, NSInteger statusCode)
                                                                {
                                                                    if (completion)
                                                                    {
                                                                        completion(nil);
                                                                    }
                                                                }];
                                                               
                                                               
                                                               
                                                           }
                                                           else if (completion)
                                                           {
                                                               completion(nil);
                                                           }
                                                       });
        
    }];
    
    UINavigationController* nav = (CustomNavigationController *)[AppDelegate singleton].window.rootViewController;
    
    [nav pushViewController:VKlvc animated:YES];
}



- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(VKUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50",   @"fields",
     @"nom",        @"name_case",
     @"en",         @"lang", nil];
    
    __typeof(self) __weak weakSelf = self;
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
         {
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0)
         {
             VKUser* user = [[VKUser alloc] initWithServerDictionary:[dictsArray firstObject]];
             
             weakSelf.currentUser = user;
             [weakSelf getPostedGoalsOfUserWithID:userID OnSuccess:^(NSDictionary *responce)
              {
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                  {
                  weakSelf.currentUser.postedImages = [responce objectForKey:@"imagesArray"];
                  success (weakSelf.currentUser);
                  });
              }
                                              onFailure:^(NSError *error, NSInteger statusCode)
              {
                  failure(nil, operation.response.statusCode);
              }];
         }
         else
         {
             if (failure)
             {
                 failure(nil, operation.response.statusCode);
             }
         }
     });
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         if (failure)
         {
             failure(error, operation.response.statusCode);
         }
     }];
}

- (void)getPostedGoalsOfUserWithID:(NSString *)ID OnSuccess:(void(^)(NSDictionary *responce)) success
                                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     ID, @"owner_id",
     @"owner",  @"filter",
     @"50",        @"count"    ,nil];
    
    [self.requestOperationManager
     GET:@"wall.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
         {
             if (![[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"response"] firstObject]] isEqualToString:@"0"] && [responseObject objectForKey:@"response"])
             {
                 NSArray* dictsArray = [responseObject objectForKey:@"response"];
                 
                 NSMutableDictionary *responce = [[NSMutableDictionary alloc] init];
                 
                 NSMutableArray *imagesArray = [NSMutableArray array];
                 
                 NSString *UID;
                 
                 if ([dictsArray count] > 0)
                 {
                     for (int i = 1; i < dictsArray.count; i++)
                     {
                         NSDictionary *post = [dictsArray objectAtIndex:i];
                         
                         UID = [post objectForKey:@"from_id"];
                         NSString *text = [post objectForKey:@"text"];
                         if ([text rangeOfString:@"#Earn#IOS#"].location != NSNotFound)
                         {
                             NSArray *wrapper = [post objectForKey:@"attachments"];
                             NSDictionary *attachments = [wrapper firstObject];
                             
                             
                             if (attachments)
                             {
                                 NSDictionary *photo = [attachments objectForKey:@"photo"];
                                 NSDictionary *responceDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [photo objectForKey:@"src_big"], @"src_big",
                                                               [photo objectForKey:@"src_xbig"],  @"src_xbig", nil];
                                 
                                 [imagesArray addObject:responceDict];
                                 
                             }
                         }
                         
                         
                     }
                     
                     if (success)
                     {
                         [responce setValue:imagesArray forKey:@"imagesArray"];
                         [responce setValue:UID forKey:@"UID"];
                         success(responce);
                     }
                 }
             }
             else
             {
                 if (failure)
                 {
                     failure(nil, operation.response.statusCode);
                 }
             }
             
         });
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             
             if (failure)
             {
                 failure(error, operation.response.statusCode);
             }
         }];
}


- (void) getFriendsOfCurrentUserOnSuccess:(void(^)(VKUser* user)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.accessToken.userID,        @"user_id",
     @"photo_50",   @"fields",
     @"nom",        @"name_case",
     @"en",         @"lang",      nil];
    
    __typeof(self) __weak weakSelf = self;
    [self.requestOperationManager
     GET:@"friends.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
         {
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0)
         {
             for (NSDictionary *dict in dictsArray)
             {
                 VKFriend *friend = [[VKFriend alloc] initWithServerDictionary:dict];
                 
                 if (!weakSelf.currentUser.friendsArray)
                     weakSelf.currentUser.friendsArray = [NSMutableArray array];
                 [weakSelf.currentUser.friendsArray addObject:friend];
                 
             }
             
             if (success)
             {
                 success(weakSelf.currentUser);
             }
         }
         else
         {
             if (failure)
             {
                 failure(nil, operation.response.statusCode);
             }
         }
     });
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         if (failure)
         {
             failure(error, operation.response.statusCode);
         }
     }];

}
*/


- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
                Completion:(void(^)(NSDictionary *resp, NSError *error))completion
{
    NSString *sectionStr;
    switch (section)
    {
        case hot:
            sectionStr = @"hot";
            break;
            
        case top:
            sectionStr = @"top";
            break;
            
        case user:
            sectionStr = @"user";
            break;
            
        default:
            break;
    }
    
    NSString *sortStr;
    switch (sort)
    {
        case viral:
            sortStr = @"viral";
            break;
            
        case topest:
            sortStr = @"topest";
            break;
            
        case latest:
            sortStr = @"latest";
            break;
            
        case rising:
            sortStr = @"rising";
            break;
            
        default:
            break;
    }
    
    NSString *windowStr;
    switch (window)
    {
        case day:
            windowStr = @"day";
            break;
            
        case week:
            windowStr = @"week";
            break;
            
        case month:
            windowStr = @"month";
            break;
            
        case year:
            windowStr = @"year";
            break;
            
        case all:
            windowStr = @"all";
            break;
            
        default:
            break;
    }
    
    NSString *url;
    if (section == top)
    {
        url = [NSString stringWithFormat:@"gallery/%@/%@/%@/%ld.json",sectionStr,sortStr,windowStr,page];
    }
    else
    {
        url = [NSString stringWithFormat:@"gallery/%@/%@/%ld.json",sectionStr,sortStr,page];
    }
    
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
