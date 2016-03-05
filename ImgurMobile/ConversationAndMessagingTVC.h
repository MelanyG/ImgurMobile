//
//  ConversationAndMessagingTVC.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationAndMessagingTVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) NSInteger currentConversationID;

@property (strong, nonatomic) NSString *currentConversationUserName;

@end
