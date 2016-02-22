//
//  imgurPost.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
@class imgurUser;

@interface ImgurPost : NSObject

@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *postDescription;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSArray *comments;

+ (ImgurPost *)initWithDictionaryResponce:(NSDictionary *)dictionary IsAlbum:(BOOL)flag;

@end
