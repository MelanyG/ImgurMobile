//
//  LocalGalleryViewController.m
//  ImgurMobile
//
//  Created by Melany on 3/3/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "LocalGalleryViewController.h"
#import "EditViewController.h"
#import "ImgurPosting.h"

@interface LocalGalleryViewController ()

@property (strong, nonatomic) UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) EditViewController* editController;
@property (strong, nonatomic) ImgurPosting* postViewController;

@end

@implementation LocalGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkGrayColor]];
    [self.navigationController.navigationBar  setTintColor:[UIColor whiteColor]];
    [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:self.picker animated:NO completion:nil];
    //self.tag = sender.tag;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editLocalImage"])
    {
        self.editController = (EditViewController*)segue.destinationViewController;
        self.editController.image = self.imageView.image;
    }
    else if ([segue.identifier isEqualToString:@"postSegue"])
    {
        self.postViewController = (ImgurPosting*)segue.destinationViewController;
        self.postViewController.image = self.imageView.image;
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = self.selectedImage;
    //[self.delegate didSelectImage:image :self.tag];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editSelected:(id)sender
{
   
    
    
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        EditViewController * editingStoryboardVC = (EditViewController *)[sb instantiateViewControllerWithIdentifier:@"editLocalImage"];
//        editingStoryboardVC.image = self.selectedImage;
//        
//        [self.navigationController pushViewController:editingStoryboardVC animated:YES];
//
    
}

- (IBAction)postSelected:(id)sender {
}
@end
