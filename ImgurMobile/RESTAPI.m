//
//  RESTAPI.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 28.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "RESTAPI.h"
@interface RESTAPI() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *requestConnection;

@end

@implementation RESTAPI

#pragma mark - Initialization

- (NSMutableData *)receivedData
{
    if (!_receivedData)
    {
        _receivedData = [[NSMutableData alloc] init];
    }
    return _receivedData;
}

- (NSURLConnection *)requestConnection
{
    if (!_requestConnection)
    {
        _requestConnection = [[NSURLConnection alloc] init];
    }
    return _requestConnection;
}

- (void)httpRequest:(NSMutableURLRequest *)request
{
    self.requestConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate getReceivedData:self.receivedData sender:self];
    self.delegate = nil;
    self.requestConnection = nil;
    self.receivedData = nil;
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData = nil;
    self.delegate = nil;
    self.requestConnection = nil;
    NSLog(@"%@", error.description);
}

@end
