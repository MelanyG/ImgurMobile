//
//  ImgurPosting.h
//  ImgurMobile
//
//  Created by Melany on 2/21/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgurServerManager.h"
#import "ImgurAccessToken.h"
#import "GiFHUD.h"


@interface ImgurPosting : UIViewController <UIPickerViewDelegate>

@property (strong, nonatomic) UIImage* image;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (strong, nonatomic) NSMutableDictionary* allSavedImages;

- (IBAction)postActionSelected:(UIButton *)sender;
- (IBAction)ShareWithCommunity:(UIButton *)sender;
- (IBAction)deleteImage:(id)sender;
- (IBAction)loadImagesFromGallery:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteImageSelected;


@end
