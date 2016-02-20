//
//  ImguaUser.h
//  ImgurMobile
//
//  Created by Melany on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurUser : NSObject

@property (strong, nonatomic) NSString* accountUserName;
@property (strong, nonatomic) NSString* accountID;
//@property (strong, nonatomic) NSURL* imageURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
