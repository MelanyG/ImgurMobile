//
//  imgurLoader.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurLoader : NSObject

+ (ImgurLoader *)sharedLoader;

- (NSDictionary *)loadJSONFromURL:(NSString *)urlString;

- (NSDictionary *)loadAllNotificationsWithURLString:(NSString *)urlString;

@end
