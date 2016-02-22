//
//  Node.h
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/22/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject
@property (strong, nonatomic) id data;
@property (strong, nonatomic) Node* next;

@end
