//
//  Comment.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Comment : NSObject

@property (strong, nonatomic) NSString* authorID;
@property (strong, nonatomic) NSString* authorName;
@property (strong, nonatomic) NSString* comment;
@property (strong, nonatomic) NSString* authorAvatarID;
@property (strong, nonatomic) NSString* commentPoints;
@property (strong, nonatomic) NSString* commentID;


-(instancetype) initWithAuthorID:(NSString*) authorID
                  withAuthorName:(NSString*) authorName
                     withComment:(NSString*) comment
                withAuthorAvatarID:(NSString*) avatar
               withCommentPoints:(NSString*) commentPoints
                   withCommentID:(NSString*) commentID;

@end
