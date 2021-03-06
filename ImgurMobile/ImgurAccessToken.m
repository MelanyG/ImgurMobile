//
//  ImgurAccessToken.m
//  ImgurMobile
//
//  Created by Melany on 2/20/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurAccessToken.h"

@implementation ImgurAccessToken

+ (instancetype)sharedToken
{
    static ImgurAccessToken *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImgurAccessToken alloc] init];
       
    });
    
    return instance;
}

- (id) init
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userName = [defaults objectForKey:@"userName"];
        self.token = [defaults objectForKey:@"access_token"];
        self.refresh_token = [defaults objectForKey:@"refresh_token"];
        self.accountID = [defaults objectForKey:@"account_id"];
        self.expirationDate = [defaults objectForKey:@"expires_in"];
        self.dayOfLogin = [defaults objectForKey:@"dayOgLogin"];
    return self;
}

@end
