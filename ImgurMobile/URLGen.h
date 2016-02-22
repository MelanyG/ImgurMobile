//
//  URLGen.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    hot,
    top,
    user
}section;

typedef enum{
    viral,
    topest,
    latest,
    rising
}sort;

typedef enum{
    day,
    week,
    month,
    year,
    all
}window;

@interface URLGen : NSObject

@property (strong, nonatomic) NSString *baseURL;

+ (URLGen *)sharedInstance;

- (NSString *)GetGalleryURLForPage:(NSInteger)page Section:(section)section Sort:(sort)sort Window:(window)window;

@end
