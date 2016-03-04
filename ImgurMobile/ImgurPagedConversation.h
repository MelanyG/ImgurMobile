//
//  ImgurConversation.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurPagedConversation : NSObject

+ (ImgurPagedConversation *)initWithResponceDictionary:(NSDictionary *)dictionary;

@property (assign, nonatomic) NSInteger ConversationId;
@property (assign, nonatomic) NSInteger messagesCount;
@property (assign, nonatomic) NSInteger receiverId;
@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *lastMessage;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL done;
@property (strong, nonatomic) NSArray *messages;

@end
