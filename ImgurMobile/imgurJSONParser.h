//
//  imgurJSONParser.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImgurAlbum;
@class ImgurPagedConversation;

@interface ImgurJSONParser : NSObject

+ (instancetype)sharedJSONParser;

- (NSDictionary *)getPostsFromresponceDictionary:(NSDictionary *)dict;

- (ImgurAlbum *)getAlbumFromResponceDict:(NSDictionary *)responce;

- (NSArray *)getCommetsArrayFromResponceDict:(NSDictionary *)dict;

- (NSArray *)getConversationPreviewsArrayFromResponceDict:(NSDictionary *)dict;

- (ImgurPagedConversation *)getConversationFromResponceDict:(NSDictionary *)dict;

@end
