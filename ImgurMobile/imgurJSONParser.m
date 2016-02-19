//
//  imgurJSONParser.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "imgurJSONParser.h"
#import "imgurPost.h"

@implementation imgurJSONParser

+ (instancetype)sharedJSONParser
{
    static imgurJSONParser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[imgurJSONParser alloc] init];
    });
    return instance;
}

- (NSArray *)getPostsFromResponceDict:(NSDictionary *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *data = [dict objectForKey:@"data"];
    for (int i = 0; i < data.count; i++)
    {
        NSDictionary *postDict = [data objectAtIndex:i];
        imgurPost *post = [imgurPost initWithDictionaryResponce:postDict];
        [array addObject:post];
    }
    
    return array;
}

@end
