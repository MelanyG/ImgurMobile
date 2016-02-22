//
//  imgurJSONParser.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImgurAlbum;

@interface ImgurJSONParser : NSObject

+ (instancetype)sharedJSONParser;

- (NSDictionary *)getPostsFromresponceDictionary:(NSDictionary *)dict;

- (ImgurAlbum *)getAlbumFromResponceDict:(NSDictionary *)responce;

@end
