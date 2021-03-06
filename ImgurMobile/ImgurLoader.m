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
    self.token = [ImgurAccessToken sharedToken].token;

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

- (NSDictionary *)createMessageWithURL:(NSString *)urlString Message:(NSString *)message
{
    self.token = [ImgurAccessToken sharedToken].token;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *boundary = @"---------------------------0983745982375409872438752038475287";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"body\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];

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

- (NSDictionary *)deleteConversationWithURL:(NSString *)urlString
{
    self.token = [ImgurAccessToken sharedToken].token;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"DELETE"];
    
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

@end
