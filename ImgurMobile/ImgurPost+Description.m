//
//  ImgurPost+Description.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/24/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgurPost+Description.h"
@implementation imgurPost (imgurPostDescriptionCategory)

-(NSString *)description
{
    return [NSString stringWithFormat:@"\rPost owner: %@ \rPost title: %@ \rPost description: %@ \rPost image URL: %@\r",
            self.owner, self.title, self.postDescription, self.imageURL ];
}

@end