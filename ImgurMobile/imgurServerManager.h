//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLGen.h"
#import "ImgurAccessToken.h"

extern NSString * const IMGUR_SERVER_MANAGER_STATUS_KEY;
extern NSString * const IMGUR_SERVER_MANAGER_ERROR_KEY;

@class imgurUser;
@class ImgurPagedConversation;

@interface imgurServerManager : NSObject

- (void) authorizeUser:(void(^)(imgurUser* user)) completion ;
+ (instancetype)sharedManager;

@property (nonatomic, strong) imgurUser *currentUser;
@property (strong, nonatomic) ImgurAccessToken* accessToken;

- (void)getPhotosForPage:(NSInteger)page
                 Section:(section)section
                    Sort:(sort)sort
                  Window:(window)window
              Completion:(void(^)(NSDictionary *resp))completion;

- (void)getComentsForId:(NSString *)identifier
                IsAlbum:(BOOL) isAlbum
             Completion:(void(^)(NSArray *resp))completion;

- (void)getAllConversationsPreviewForCurrentUserCompletion:(void(^)(NSArray *resp))completion;

- (void)getConversationWithID:(NSInteger)identifier
                      ForPage:(NSInteger)page
                   Completion:(void(^)(ImgurPagedConversation *resp))completion;

- (void)createMessageWithUser:(NSString *)userName
                      Message:(NSString *)message
                   Completion:(void(^)(NSDictionary *dict))completion;

- (void)deleteConversationWithID:(NSInteger)identifier
                      Completion:(void(^)(NSDictionary *dict))completion;

- (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
       access_token:(NSString*)token
              topic:(NSString*) topic
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;


- (void) shareImageWithImgurCommunity:(NSString*)title
                          description:(NSString*)description
                         access_token:(NSString*)token
                                topic:(NSString*) section
                      completionBlock:(void(^)(NSString* result))completion
                         failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;


- (void) updateAccessToken: (NSString*) refresh_token
              access_token: (NSString*) access_token
           completionBlock:(void(^)(NSString* result))completion
              failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

- (void) deleteImage:(NSString*) access_token
     completionBlock:(void(^)(NSString* result))completion
        failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

-(NSDictionary*) loadImagesFromUserGallery:(NSString*) access_token
                                  username: (NSString*) name
                           completionBlock:(void(^)(NSString* result))completion
                              failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

-(NSDictionary*) loadExistingImages:(NSString*) access_token
                          idOfAlbun:(NSString*) albumId;

@end
