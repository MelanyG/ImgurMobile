//
//  UIView+SuperClassChecker.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "UIView+SuperClassChecker.h"

@implementation UIView (SuperClassChecker)

- (BOOL)superHierarchyIsKindOfClass:(Class)classToCompare
{
    if ([self isKindOfClass:classToCompare])
        return YES;
    else
        return [self.superview superHierarchyIsKindOfClass:classToCompare];
}

- (BOOL)superTag:(NSInteger)tag
{
    if (self.tag == tag)
        return YES;
    else
        return [self.superview superTag:tag];
}

@end
