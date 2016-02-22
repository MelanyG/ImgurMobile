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

- (void)getPostsFromResponceDict:(NSDictionary *)dict Completion:(void(^)(NSDictionary *dict, NSError *error)) completion
{
    NSMutableArray *postArray = [NSMutableArray array];
    
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

- (imgurAlbum *)getArrayOfImagesFromAlbumResponceDict:(NSDictionary *)responce
{
    NSArray *images = [NSArray arrayWithArray:[responce objectForKey:@"images"]];
    
    imgurAlbum *album = [[imgurAlbum alloc] init];
    album.ownerID = [responce objectForKey:@"account_id"];
    album.topic = [responce objectForKey:@"topic"];
    
    for (int i = 0; i < images.count; i++)
    {
        imgurPost *post = [imgurPost initWithDictionaryResponce:[images objectAtIndex:i] IsAlbum:YES];
        [album.posts addObject:post];
    }
    
    return album;
}

@end
