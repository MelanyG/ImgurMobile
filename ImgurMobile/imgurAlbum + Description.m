//
//  imgurAlbum + Description.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/29/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imgurAlbum + Description.h"

@implementation imgurAlbum (imgurAlbumDescriptionCategory)

- (NSString *)description
{
    return [NSString stringWithFormat:@"\rPosts: %@ \rownerID: %@ \rtopic: %@",
            self.posts, self.ownerID, self.topic];
}
@end