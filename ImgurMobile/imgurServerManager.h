//
//  VKServerManager.h
//  CurrencyExchange
//
//  Created by alex4eetah on 2/6/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

typedef enum{
    hot,
    top,
    user
}section;

typedef enum{
    viral,
    topest,
    latest,
    rising
}sort;

typedef enum{
    day,
    week,
    month,
    year,
    all
}window;

#import <Foundation/Foundation.h>
@class imgurUser;

@interface imgurServerManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) imgurUser *currentUser;

- (void)getPhotosForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
              Completion:(void(^)(NSDictionary *resp, NSError *error))completion;

@end
