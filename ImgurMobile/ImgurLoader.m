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
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    NSDictionary *responceDict;
    
    if (data)
        responceDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
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

- (NSDictionary *)loadAllNotificationsWithURLString:(NSString *)urlString
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:NO],@"new", nil];

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    request.HTTPBody = jsonData;
    
    
    
    
    /*
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO],@"new", nil];
    
    NSString *myJSONString = [NSString str];
    NSData *myJSONData =[myJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"myJSONString :%@", myJSONString);
    NSLog(@"myJSONData :%@", myJSONData);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:Your URL string]];
    [request setHTTPBody:myJSONData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];*/
    
    
    
    
    
    
    
    
    
    NSURLResponse *res = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    NSDictionary *responceDict;
    
    if (data)
    {
        responceDict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers error:nil];
    }
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

/*
 NSMutableData *body = [[NSMutableData alloc] init];
 
 NSString *boundary = @"---------------------------0983745982375409872438752038475287";
 
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
 [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
 // add params (all params are strings)
 for (NSString *param in dict)
 {
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
 }
 [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 [request setHTTPBody:body];*/





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
