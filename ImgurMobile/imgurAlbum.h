//
//  imgurAlbum.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imgurAlbum : NSObject

@property (strong, nonatomic) NSString *albumTitle;
@property (strong, nonatomic) NSString *albumDescription;
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSNumber *downs;
@property (strong, nonatomic) NSNumber *score;
@property (assign, nonatomic) BOOL favorite;
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *topic;

@end
