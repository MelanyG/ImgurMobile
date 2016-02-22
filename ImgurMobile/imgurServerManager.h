//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "URLGen.h"
@class imgurUser;

@interface imgurServerManager : NSObject


- (void) authorizeUser:(void(^)(imgurUser* user)) completion ;
+ (instancetype)sharedManager;

@property (nonatomic, strong) imgurUser *currentUser;

- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
              Completion:(void(^)(NSDictionary *resp))completion;

@end
