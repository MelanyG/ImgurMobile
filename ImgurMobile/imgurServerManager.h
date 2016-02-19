//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imgurUser;

@interface imgurServerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) imgurUser *currentUser;

@end
