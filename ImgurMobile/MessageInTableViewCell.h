//
//  MessageInTableViewCell.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *thisContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offsetConstraint;

@end
