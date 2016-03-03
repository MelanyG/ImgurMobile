//
//  LocalGalleryViewController.h
//  ImgurMobile
//
//  Created by Melany on 3/3/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalGalleryViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UIImage* selectedImage;
- (IBAction)editSelected:(id)sender;
- (IBAction)postSelected:(id)sender;


@end
