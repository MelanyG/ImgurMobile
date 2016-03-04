//
//  ImgurConversations.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurConversationPreview.h"

@implementation ImgurConversationPreview

+ (ImgurConversationPreview *)initWithDictionaryResponce:(NSDictionary *)dictionary
{
    ImgurConversationPreview *conversation = [[ImgurConversationPreview alloc] init];
    
    if (conversation)
    {
        conversation.conversationId = [[dictionary objectForKey:@"id"] integerValue];
        conversation.messagesCount = [[dictionary objectForKey:@"message_count"] integerValue];
        conversation.receiverId = [[dictionary objectForKey:@"with_account_id"] integerValue];
        conversation.receiverName = [dictionary objectForKey:@"with_account"];
        conversation.lastMessage = [dictionary objectForKey:@"last_message_preview"];
    }
    
    return conversation;
}

@end
