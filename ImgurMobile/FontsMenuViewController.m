//
//  FontsMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FontsMenuViewController.h"

@interface FontsMenuViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Sliders
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;

@property (weak, nonatomic) IBOutlet UIImageView *colorIndicator;

@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;

@end

@implementation FontsMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 2222;
}

- (IBAction)colorDidChanged:(UISlider *)sender
{//1234
    
}

- (IBAction)fontSizeDidChanged:(UISlider *)sender
{
    
}


@end
