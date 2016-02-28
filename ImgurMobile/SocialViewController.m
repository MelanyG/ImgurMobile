//
//  SocialViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "SocialViewController.h"
#import "RESTAPI.h"
@interface SocialViewController () <RESTAPIDelegate>

@property (strong, nonatomic) RESTAPI *restApi;
@property (strong, nonatomic) NSCharacterSet* set;

@end

@implementation SocialViewController


-(RESTAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RESTAPI alloc] init];
    }
    return _restApi;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    [self httpGetRequest];
}

- (void)httpGetRequest
{
    NSString *str = @"https://api.imgur.com/3/image.json";
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:GET];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
}

- (void)httpPostRequest
{
    NSString *postBody = @"";
    NSString *str = @"";
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:POST];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
}

- (void)getReceivedData:(NSMutableData *)data sender:(RESTAPI *)sender
{
    NSError *error = nil;
    NSDictionary *receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
}




@end
