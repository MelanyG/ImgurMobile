//
//  ImgurConversations.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurConversationPreview : NSObject

@property (assign, nonatomic) NSInteger conversationId;
@property (assign, nonatomic) NSInteger messagesCount;
@property (assign, nonatomic) NSInteger receiverId;
@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *lastMessage;

+ (ImgurConversationPreview *)initWithDictionaryResponce:(NSDictionary *)dictionary;

@end
