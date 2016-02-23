//
//  EditProtocolHeader.h
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#ifndef EditProtocolHeader_h
#define EditProtocolHeader_h

typedef enum{
    imageFiltering,
    textEditing
}WorkingMode;

@protocol topMenuDelegate <NSObject>

- (void)changeWorkingModeTo:(WorkingMode) mode;

@end

#endif /* EditProtocolHeader_h */
