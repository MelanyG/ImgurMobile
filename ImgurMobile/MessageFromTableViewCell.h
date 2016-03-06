//
//  MessageFromTableViewCell.h
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageFromTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
