//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImgurUser;

@interface imgurServerManager : NSObject

+ (instancetype)sharedManager;
- (void) authorizeUser:(void(^)(ImgurUser* user)) completion;

@property (nonatomic, strong) ImgurUser *currentUser;

@end
