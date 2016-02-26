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

@class imgurUser;

@interface imgurServerManager : NSObject


- (void) authorizeUser:(void(^)(imgurUser* user)) completion ;
+ (instancetype)sharedManager;

@property (nonatomic, strong) imgurUser *currentUser;
@property (strong, nonatomic) ImgurAccessToken* accessToken;

- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
              Completion:(void(^)(NSDictionary *resp))completion;

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
                                topic:(NSString*) topic
                      completionBlock:(void(^)(NSString* result))completion
                         failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

@end
