//
//  URLGen.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "URLGen.h"
#import "ImgurAccessToken.h"

@implementation URLGen

+ (URLGen *)sharedInstance
{
    static URLGen *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[URLGen alloc] init];
    });
    return instance;
}

- (NSString *)getGalleryURLForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
{
    NSString *sectionStr;
    switch (section)
    {
        case hot:
            sectionStr = @"hot";
            break;
            
        case top:
            sectionStr = @"top";
            break;
            
        case user:
            sectionStr = @"user";
            break;
            
        default:
            break;
    }
    
    NSString *sortStr;
    switch (sort)
    {
        case viral:
            sortStr = @"viral";
            break;
            
        case topest:
            sortStr = @"topest";
            break;
            
        case latest:
            sortStr = @"latest";
            break;
            
        case rising:
            sortStr = @"rising";
            break;
            
        default:
            break;
    }
    
    NSString *windowStr;
    switch (window)
    {
        case day:
            windowStr = @"day";
            break;
            
        case week:
            windowStr = @"week";
            break;
            
        case month:
            windowStr = @"month";
            break;
            
        case year:
            windowStr = @"year";
            break;
            
        case all:
            windowStr = @"all";
            break;
            
        default:
            break;
    }
    
    NSString *url;
    if (section == top)
    {
        url = [NSString stringWithFormat:@"%@gallery/%@/%@/%@/%ld.json",self.baseURL,sectionStr,sortStr,windowStr,(long)page];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@gallery/%@/%@/%ld.json",self.baseURL,sectionStr,sortStr,(long)page];
    }
    
    return url;
}

- (NSString *)getAlbumURLForAlbumWithID:(NSString *)albumID
{
    NSString *url = [NSString stringWithFormat:@"%@gallery/album/%@",self.baseURL,albumID];
    return url;
}

- (NSString *)getComentsIdsForID:(NSString *)identifier URLIsAlbum:(BOOL)isAlbum
{
    NSString *url;
    
    if (isAlbum)
    {
        url = [NSString stringWithFormat:@"%@gallery/album/%@/comments/ids",self.baseURL, identifier];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@gallery/image/%@/comments/ids",self.baseURL, identifier];
    }
    
    return url;
}

- (NSString *)getConversationsListURL
{
    NSString *url = [NSString stringWithFormat:@"%@conversations", self.baseURL];
    return url;
}

- (NSString *)getURLForConversationWithID:(NSInteger)identifier Page:(NSInteger)page
{
    NSString *url = [NSString stringWithFormat:@"%@conversations/%@/%@/0", self.baseURL, [NSString stringWithFormat:@"%ld",(long)identifier], [NSString stringWithFormat:@"%ld",(long)page]];
    return url;
}

- (NSString *)getURLForMessageCreationWithUser:(NSString *)userName
{
    NSString *url = [NSString stringWithFormat:@"%@conversations/%@", self.baseURL, userName];
    return url;
}

- (NSString *)getURLDeletionOfConversationWithID:(NSInteger)identifier
{
    NSString *url = [NSString stringWithFormat:@"%@conversations/%ld", self.baseURL, (long)identifier];
    return url;
}

@end
