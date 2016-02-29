//
//  UIButton+highlighter.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/28/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "UIButton+highlighter.h"

@implementation UIButton (highlighter)

- (void)highlightOfButton
{
    UIColor *highlighted = [UIColor colorWithRed:0.39 green:0.89 blue:0.91 alpha:0.55];
    self.backgroundColor = highlighted;
}

- (void)unHighlightOfButton
{
    UIColor *unHighlighted = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.backgroundColor = unHighlighted;
}

@end
