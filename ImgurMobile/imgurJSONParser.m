//
//  imgurJSONParser.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurJSONParser.h"
#import "imgurPost.h"
#import "imgurAlbum.h"
#import "ImgurPagedConversation.h"
#import "ImgurConversationPreview.h"

@implementation ImgurJSONParser

+ (instancetype)sharedJSONParser
{
    static ImgurJSONParser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImgurJSONParser alloc] init];
    });
    return instance;
}

- (NSDictionary *)getPostsFromresponceDictionary:(NSDictionary *)dict
{
    NSMutableArray *postArray = [NSMutableArray array];
    NSMutableArray *albumIdArray = [NSMutableArray array];
    
    NSArray *data = [dict objectForKey:@"data"];
    if (data)
    {
        for (int i = 0; i < data.count; i++)
        {
            NSDictionary *postDict = [data objectAtIndex:i];
            if ([[postDict objectForKey:@"is_album"] boolValue])
            {
                NSString *albumID = [postDict objectForKey:@"id"];
                [albumIdArray addObject:albumID];
            }
            else
            {
                imgurPost *post = [imgurPost initWithDictionaryResponce:postDict IsAlbum:NO];
                [postArray addObject:post];
            }
        }
        
        NSMutableDictionary *outDict = [[NSMutableDictionary alloc] init];
        [outDict setObject:postArray forKey:@"posts"];
        [outDict setObject:albumIdArray forKey:@"albumIds"];
        
        return outDict;
    }
    else
    {
        return dict;
    }
}

- (imgurAlbum *)getAlbumFromResponceDict:(NSDictionary *)responce
{
    NSDictionary *data = [responce objectForKey:@"data"];
    NSArray *images = [NSArray arrayWithArray:[data objectForKey:@"images"]];
    
    imgurAlbum *album = [[imgurAlbum alloc] init];
    
    album.albumTitle = [data objectForKey:@"title"];
    album.albumDescription = [data objectForKey:@"description"];
    album.points = [data objectForKey:@"points"];
    album.downs = [data objectForKey:@"downs"];
    album.score = [data objectForKey:@"score"];
    album.favorite = [[data objectForKey:@"favorite"] boolValue];
    album.albumID = [data objectForKey:@"id"];
    album.ownerID = [data objectForKey:@"account_id"];
    album.topic = [data objectForKey:@"topic"];
    if (!album.posts)
        album.posts = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i++)
    {
        imgurPost *post = [imgurPost initWithDictionaryResponce:[images objectAtIndex:i] IsAlbum:YES];
        [album.posts addObject:post];
    }
    
    return album;
}

- (NSArray *)getCommetsArrayFromResponceDict:(NSDictionary *)dict
{
    NSArray *array = [dict objectForKey:@"data"];
    return array;
}

- (NSArray *)getConversationPreviewsArrayFromResponceDict:(NSDictionary *)dict
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *data = [dict objectForKey:@"data"];
    
    for (NSDictionary *dict in data)
    {
        ImgurConversationPreview *conversation = [ImgurConversationPreview initWithDictionaryResponce:dict];
        [array addObject:conversation];
    }
    
    return array;
}

- (ImgurPagedConversation *)getConversationFromResponceDict:(NSDictionary *)dict
{
    ImgurPagedConversation *pagedConversation = [ImgurPagedConversation initWithResponceDictionary:dict];
    return pagedConversation;
}



/*
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
 }*/

@end
