//
//  PreviewTableViewCell.m
//  ImgurMobile
//
//  Created by alex4eetah on 3/4/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "PreviewTableViewCell.h"

@implementation PreviewTableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing)
    {
        self.backgroundColor = [UIColor blackColor];
    }
    else
    {
        
    }
}

@end
