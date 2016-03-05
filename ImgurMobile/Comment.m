//
//  Comment.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "Comment.h"

@implementation Comment



-(instancetype) initWithAuthorID:(NSString*) authorID
                 withAuthorName:(NSString*) authorName
                    withComment:(NSString*) comment
               withAuthorAvatarID:(NSString*) avatar
              withCommentPoints:(NSString*) commentPoints
{
    self = [super init];
    if (self) {
        self.authorID = authorID;
        self.authorName = authorName;
        self.comment = comment;
        self.authorAvatarID = avatar;
        self.commentPoints = commentPoints;
    }
    return self;
}

@end
