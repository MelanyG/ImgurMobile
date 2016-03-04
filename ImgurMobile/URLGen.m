//
//  URLGen.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "URLGen.h"

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

- (NSString *)GetGalleryURLForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window
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
        url = [NSString stringWithFormat:@"%@gallery/%@/%@/%@/%d.json",self.baseURL,sectionStr,sortStr,windowStr,page];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@gallery/%@/%@/%d.json",self.baseURL,sectionStr,sortStr,page];
    }
    
    return url;
}

- (NSString *)GetAlbumURLForAlbumWithID:(NSString *)albumID
{
    NSString *url = [NSString stringWithFormat:@"%@gallery/album/%@",self.baseURL,albumID];
    return url;
}

- (NSString *)GetAllNotificationsURL
{
    NSString *url = [NSString stringWithFormat:@"%@notification",self.baseURL];
    return url;
}

@end
