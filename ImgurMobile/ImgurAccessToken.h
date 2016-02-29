//
//  ImgurAccessToken.h
//  ImgurMobile
//
//  Created by Melany on 2/20/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString* refresh_token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* accountID;
@property (strong, nonatomic) NSString* userName;
+ (instancetype)sharedToken;
@end
