//
//  LocalGalleryViewController.m
//  ImgurMobile
//
//  Created by Melany on 3/3/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "LocalGalleryViewController.h"

@interface LocalGalleryViewController ()

@property (strong, nonatomic) UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LocalGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    
    [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:self.picker animated:NO completion:nil];
    //self.tag = sender.tag;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[self.delegate didSelectImage:image :self.tag];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editSelected:(id)sender {
}

- (IBAction)postSelected:(id)sender {
}
@end
