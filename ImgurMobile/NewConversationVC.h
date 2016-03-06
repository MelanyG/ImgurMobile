//
//  NewConversationVC.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/6/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewConversationDelegate <NSObject>

- (void)reloadData;

@end


@interface NewConversationVC : UIViewController

@property (weak, nonatomic) id<NewConversationDelegate> delegate;

@end
