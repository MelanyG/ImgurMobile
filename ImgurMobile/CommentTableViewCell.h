//
//  CommentTableViewCell.h
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *autherName;
@property (weak, nonatomic) IBOutlet UITextView *autherComment;

- (IBAction)likeCommentAction;

- (IBAction)dislikeCommentAction;

@end
