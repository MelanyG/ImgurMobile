//
//  UIView+SuperClassChecker.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SuperClassChecker)

- (BOOL)superHierarchyIsKindOfClass:(Class)classToCompare;
- (BOOL)superTag:(NSInteger)tag;

@end
