//
//  MessageInTableViewCell.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "MessageInTableViewCell.h"

@implementation MessageInTableViewCell

- (void)layoutSubviews
{
    self.thisContainerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.thisContainerView.layer.borderWidth = 0.5;
}

@end
