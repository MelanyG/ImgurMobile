//
//  RESTAPI.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 28.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POST @"POST"
#define GET @"GET"

@class RESTAPI;

@protocol RESTAPIDelegate
- (void)getReceivedData:(NSMutableData *)data sender:(RESTAPI *)sender;
@end

@interface RESTAPI : NSObject

@property (weak, nonatomic) id  <RESTAPIDelegate> delegate;

- (void)httpRequest:(NSMutableURLRequest *)request;

@end
