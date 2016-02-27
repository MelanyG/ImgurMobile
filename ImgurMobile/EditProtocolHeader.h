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

typedef enum{
    RightTop,
    LeftTop,
    RightBottom,
    LeftBottom,
    Center
}PositionType;

@protocol settingsMenuDelegate <NSObject>

- (void)changeWorkingModeTo:(WorkingMode) mode;
- (void)changeStateOfLeftMenu;
- (void)saveImageAndShowPostVC;

@end

@protocol rightMenuDelegate <NSObject>

- (void)changeStateOfRightMenu:(RightMenuType)type;

@end

@protocol filteringDelegate <NSObject>

- (void)updateUIWithImage:(UIImage *)image;
- (void)startLoadIndicating;
- (void)stopLoadIndicating;

@end

@protocol fontDelegate <NSObject>

- (void)setLabel:(UILabel *)label withPosition:(PositionType)position;

@end

#endif /* EditProtocolHeader_h */
