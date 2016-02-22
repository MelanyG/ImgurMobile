//
//  imgurPost.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurPost.h"

@implementation ImgurPost

+ (ImgurPost *)initWithDictionaryResponce:(NSDictionary *)dictionary IsAlbum:(BOOL)flag
{
    ImgurPost *post = [[ImgurPost alloc] init];
    
    if (flag)
    {
        post.imageURL = [dictionary objectForKey:@"link"];
        post.title = [dictionary objectForKey:@"title"];
        post.postDescription = [dictionary objectForKey:@"description"];
    }
    else
    {
        post.owner = [dictionary objectForKey:@"account_id"];
        post.imageURL = [dictionary objectForKey:@"link"];
        post.title = [dictionary objectForKey:@"title"];
        post.postDescription = [dictionary objectForKey:@"description"];
        post.topic = [dictionary objectForKey:@"topic"];
        
    }
    
    return post;
}

@end
