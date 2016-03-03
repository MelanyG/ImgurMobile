//
//  imgurLoader.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurLoader.h"
#import "AFNetworking.h"
#import "ImgurAccessToken.h"

@interface ImgurLoader ()

@property (strong, nonatomic) NSString *token;

@end

@implementation ImgurLoader

+ (ImgurLoader *)sharedLoader
{
    static ImgurLoader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImgurLoader alloc] init];
        instance.token = [ImgurAccessToken sharedToken].token;
    });
    return instance;
}



- (NSDictionary *)loadJSONFromURL:(NSString *)urlString
{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"GET"];

    NSURLResponse *res = nil;
    NSError *error = nil;
    
    NSDictionary *responceDict = [NSJSONSerialization JSONObjectWithData:
                                        [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error]
                                                                       options:NSJSONReadingMutableContainers error:nil];
    if (!error)
    {
        if ([[responceDict objectForKey:@"success"] boolValue])
        {
            return responceDict;
        }
        else
        {
            NSDictionary *data = [responceDict objectForKey:@"data"];
            
            
            return [NSDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"error"],@"error_status", nil];
        }
    }
    else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription,@"error", nil];
    }
}








/*- (NSDictionary *)loadJSONFromURL:(NSString *)urlString
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
}*/

@end
