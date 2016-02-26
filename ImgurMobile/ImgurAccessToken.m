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

@end
