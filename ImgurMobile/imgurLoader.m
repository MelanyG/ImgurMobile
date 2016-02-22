//
//  imgurLoader.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurLoader.h"
#import "AFNetworking.h"

@implementation ImgurLoader

+ (ImgurLoader *)sharedLoader
{
    static ImgurLoader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImgurLoader alloc] init];
    });
    return instance;
}

- (NSDictionary *)loadJSONFromURL:(NSString *)urlString
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    __block NSDictionary *responceDict;
    __block NSError *respError = nil;

    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         responceDict = responseObject;
         dispatch_semaphore_signal(sem);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         respError = error;
         dispatch_semaphore_signal(sem);
     }];

    while (dispatch_semaphore_wait(sem, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    
    if (!respError)
    {
        return responceDict;
    }
    else
    {
        return nil;
    }
}

@end
