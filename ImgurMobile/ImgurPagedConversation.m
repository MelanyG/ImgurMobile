//
//  ImgurConversation.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImgurPagedConversation.h"

@implementation ImgurPagedConversation

+ (ImgurPagedConversation *)initWithResponceDictionary:(NSDictionary *)dictionary
{
    ImgurPagedConversation *conversation = [[ImgurPagedConversation alloc] init];
    
    if (conversation)
    {
        NSDictionary *data = [dictionary objectForKey:@"data"];
        
        conversation.ConversationId = [[data objectForKey:@"id"] integerValue];
        conversation.messagesCount = [[data objectForKey:@"message_count"] integerValue];
        conversation.receiverId = [[data objectForKey:@"with_account_id"] integerValue];
        conversation.receiverName = [data objectForKey:@"with_account"];
        conversation.lastMessage = [data objectForKey:@"last_message_preview"];
        conversation.page = [[data objectForKey:@"page"] integerValue];
        conversation.done = [[data objectForKey:@"page"] boolValue];
        
        NSMutableArray *messages = [NSMutableArray array];
        NSArray *messagesData = [data objectForKey:@"messages"];
        for (NSDictionary *dict in messagesData)
        {
            double getDate = [[dict objectForKey:@"datetime"] doubleValue];
            NSTimeInterval seconds = getDate / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"dd-MM HH:mm"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            
            NSDictionary *mesageDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [dict objectForKey:@"from"], @"FromUserName",
                                        [dict objectForKey:@"sender_id"], @"FromUserID",
                                        [dict objectForKey:@"id"], @"messageId",
                                        [dict objectForKey:@"body"], @"message",
                                        dateString, @"date", nil];
            [messages addObject:mesageDict];
        }
        conversation.messages = messages;
    }
    
    return conversation;
}

@end
