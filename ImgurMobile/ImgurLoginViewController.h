//
//  ImgurLoginViewController.h
//  ImgurMobile
//
//  Created by Melany on 2/20/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImgurAccessToken;

typedef void(^ASLoginCompletionBlock)(ImgurAccessToken* token);


@interface ImgurLoginViewController : UIViewController

@property (strong, nonatomic)ImgurAccessToken* token;

- (id) initWithCompletionBlock:(ASLoginCompletionBlock) completionBlock;


@end
