//
//  ImguaLoginViewController.h
//  ImgurMobile
//
//  Created by Melany on 2/19/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImguaAccessToken;

typedef void(^ASLoginCompletionBlock)(ImguaAccessToken* token);


@interface ImguaLoginViewController : UIViewController


- (id) initWithCompletionBlock:(ASLoginCompletionBlock) completionBlock;



@end
