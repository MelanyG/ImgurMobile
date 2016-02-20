//
//  ImguaAccessToken.h
//  ImgurMobile
//
//  Created by Melany on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImguaAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* accountID;
@property (strong, nonatomic) NSString* userName;


@end
