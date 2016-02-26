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

typedef enum{
    FilteringMenu,
    TextEditingMenu
}RightMenuType;

@protocol topMenuDelegate <NSObject>

- (void)changeWorkingModeTo:(WorkingMode) mode;
- (void)changeStateOfLeftMenu;

@end

@protocol rightMenuDelegate <NSObject>

- (void)changeStateOfRightMenu:(RightMenuType)type;

@end

@protocol filteringDelegate <NSObject>

- (void)updateUIWithImage:(UIImage *)image;

@end

#endif /* EditProtocolHeader_h */
