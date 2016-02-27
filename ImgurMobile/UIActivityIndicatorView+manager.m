//
//  UIActivityIndicatorView+manager.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/26/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "UIActivityIndicatorView+manager.h"

@implementation UIActivityIndicatorView (manager)

+ (void)addActivityIndicatorToView:(UIView *)view
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [view addSubview:activity];
    [activity startAnimating];
}

+ (void)removeActivityIndicatorFromView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView *)subview) stopAnimating];
            [((UIActivityIndicatorView *)subview) removeFromSuperview];
        }
    }
}

@end
