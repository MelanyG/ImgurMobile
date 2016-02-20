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

- (void)getPostsFromResponceDict:(NSDictionary *)dict Completion:(void(^)(NSArray *array, NSError *error)) completion;

@end
