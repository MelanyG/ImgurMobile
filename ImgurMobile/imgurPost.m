//
//  imgurPost.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "imgurPost.h"

@implementation imgurPost

+ (imgurPost *)initWithDictionaryResponce:(NSDictionary *)dictionary IsAlbum:(BOOL)flag
{
    imgurPost *post = [[imgurPost alloc] init];
    
    if (flag)
    {
        post.imageURL = [dictionary objectForKey:@"link"];
        post.title = [dictionary objectForKey:@"title"];
        post.postDescription = [dictionary objectForKey:@"description"];
    }
    else
    {
        post.postID = [dictionary objectForKey:@"id"];
        post.points = [dictionary objectForKey:@"points"];
        post.downs = [dictionary objectForKey:@"downs"];
        post.score = [dictionary objectForKey:@"score"];
        post.favorite = [[dictionary objectForKey:@"favorite"] boolValue];
        post.owner = [dictionary objectForKey:@"account_id"];
        post.imageURL = [dictionary objectForKey:@"link"];
        post.title = [dictionary objectForKey:@"title"];
        post.postDescription = [dictionary objectForKey:@"description"];
        post.topic = [dictionary objectForKey:@"topic"];
        
    }
    
    return post;
}

@end
