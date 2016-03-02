//
//  imgurPost.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imgurUser;

@interface imgurPost : NSObject

@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSNumber *downs;
@property (strong, nonatomic) NSNumber *score;
@property (assign, nonatomic) BOOL favorite;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *postDescription;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSArray *comments;

+ (imgurPost *)initWithDictionaryResponce:(NSDictionary *)dictionary IsAlbum:(BOOL)flag;

@end
