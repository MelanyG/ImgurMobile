//
//  imgurAlbum.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imgurAlbum : NSObject

@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) NSString *ownerID;
@property (strong, nonatomic) NSString *topic;

@end
