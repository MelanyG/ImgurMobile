//
//  imgurJSONParser.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "imgurJSONParser.h"
#import "imgurServerManager.h"
#import "imgurPost.h"

@interface imgurJSONParser ()

@property (nonatomic, strong) imgurServerManager *manager;

@end

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

- (imgurServerManager *)manager
{
    if (!_manager)
    {
        _manager = [imgurServerManager sharedManager];
    }
    return _manager;
}

- (NSArray *)getPostsFromResponceDict:(NSDictionary *)dict
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *data = [dict objectForKey:@"data"];
    for (int i = 0; i < data.count; i++)
    {
        NSDictionary *postDict = [data objectAtIndex:i];
        if ([[postDict objectForKey:@"is_album"] isEqualToString:@"1"])
        {
            NSString *albumID = [postDict objectForKey:@"id"];
            [self.manager getPhotosFromAlbumWithID:albumID
                                        Completion:^(NSDictionary *resp, NSError *error) {
                                            
                                        }];
        }
        else
        {
            imgurPost *post = [imgurPost initWithDictionaryResponce:postDict IsAlbum:NO];
            [array addObject:post];
        }
    }
    
    return array;
}

@end
