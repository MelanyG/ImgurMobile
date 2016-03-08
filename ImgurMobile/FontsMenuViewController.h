//
//  FontsMenuViewController.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProtocolHeader.h"

UIColor * RGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

@interface FontsMenuViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) double imageWidth;

@property (weak, nonatomic) id<fontDelegate> delegate;

@property (assign, nonatomic) BOOL shouldRespondOnSlideEvents;

- (void)updateYourself;

@end
