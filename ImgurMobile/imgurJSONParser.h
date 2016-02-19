//
//  imgurJSONParser.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imgurJSONParser : NSObject

+ (instancetype)sharedJSONParser;

- (NSArray *)getPostsFromResponceDict:(NSDictionary *)dict;

@end
