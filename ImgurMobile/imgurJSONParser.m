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
#import "imgurAlbum.h"

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

- (void)getPostsFromResponceDict:(NSDictionary *)dict Completion:(void(^)(NSArray *array, NSError *error)) completion
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *data = [dict objectForKey:@"data"];
    for (int i = 0; i < data.count; i++)
    {
        NSDictionary *postDict = [data objectAtIndex:i];
        if ([[postDict objectForKey:@"is_album"] boolValue])
        {
            NSString *albumID = [postDict objectForKey:@"id"];
            dispatch_queue_t download_queue = dispatch_queue_create("download_queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
            dispatch_async(download_queue, ^{
                [self.manager getPhotosFromAlbumWithID:albumID
                                            Completion:^(NSDictionary *resp, NSError *error)
                 {
                     NSDictionary *parsedDict =[self getArrayOfImagesFromAlbumResponceDict:[resp objectForKey:@"data"]];
                     
                     NSArray *imagesArray = [parsedDict objectForKey:@"images"];
                     NSString *ownerID = [parsedDict objectForKey:@"ownerID"];
                     NSString *topic = [parsedDict objectForKey:@"topic"];
                     
                     imgurAlbum *album = [[imgurAlbum alloc] init];
                     album.ownerID = ownerID;
                     album.topic = topic;
                     
                     for (int i = 0; i < imagesArray.count; i++)
                     {
                         imgurPost *post = [imgurPost initWithDictionaryResponce:[imagesArray objectAtIndex:i] IsAlbum:YES];
                         [album.posts addObject:post];
                     }
                     
                 }];
                
            });
        }
        else
        {
            imgurPost *post = [imgurPost initWithDictionaryResponce:postDict IsAlbum:NO];
            [array addObject:post];
        }
    }
        completion(array, nil);
}

- (NSDictionary *)getArrayOfImagesFromAlbumResponceDict:(NSDictionary *)responce
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *images = [NSArray arrayWithArray:[responce objectForKey:@"images"]];
    
    [dict setObject:[responce objectForKey:@"account_id"] forKey:@"ownerID"];
    [dict setObject:[responce objectForKey:@"topic"] forKey:@"topic"];
    [dict setObject:images forKey:@"images"];
    
    return dict;
}

@end
