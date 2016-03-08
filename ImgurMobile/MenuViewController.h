//
//  ViewController.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/8/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuDelegate <NSObject>

@required
-(void) didSelectMenuItem: (NSUInteger) num;
@end


@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak,nonatomic) id<MenuDelegate> delegate;
@property (weak, nonatomic) NSLayoutConstraint *MenuVCConstraint;

@end


