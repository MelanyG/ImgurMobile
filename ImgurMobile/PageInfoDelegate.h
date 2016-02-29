//
//  PageInfoDelegate.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/25/16.
//  Copyright © 2016 Melany. All rights reserved.
//


@protocol PageInfoDelegate <NSObject>

@required

-(void) pageInfoDidChange: (NSMutableDictionary *)info;
@end



