//
//  FontsMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FontsMenuViewController.h"

UIColor * RGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

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

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (assign, nonatomic) CGFloat red;
@property (assign, nonatomic) CGFloat green;
@property (assign, nonatomic) CGFloat blue;
@property (assign, nonatomic) CGFloat alpha;
@property (strong, nonatomic) UIColor *currentColor;

@property (assign, nonatomic) double fontSize;

@property (strong, nonatomic) UIFont *currentFont;

@property (strong, nonatomic) NSString *currentText;

@property (strong, nonatomic)  UILabel *outLabel;

@end

@implementation FontsMenuViewController

- (UILabel *)outLabel
{
    if (!_outLabel)
    {
        _outLabel = [[UILabel alloc] init];
        _outLabel.adjustsFontSizeToFitWidth = NO;
    }
    return _outLabel;
}

- (void)updateYourself
{
    self.view.tag = 2222;
    self.inputTextField.text = @"choose text, You need";
    [self setInitialColor];
    [self setInitialFontSize];
}

- (void)setInitialFontSize
{
    self.fontSize = 10;
    self.currentFont = [UIFont systemFontOfSize:self.fontSize];
    [self updateLabel];
#warning FONT SIZE 
}

- (void)setInitialColor
{
    self.red = 0;
    self.green = 0;
    self.blue = 0;
    self.alpha = 0;
    self.currentColor = RGBA(self.red, self.green, self.blue, self.alpha);
}

- (IBAction)colorDidChanged:(UISlider *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.red = sender.value;
            break;
            
        case 2:
            self.green = sender.value;
            break;
            
        case 3:
            self.blue = sender.value;
            break;
            
        case 4:
            self.alpha = sender.value;
            break;
            
        default:
            break;
    }
    self.currentColor = RGBA(self.red, self.green, self.blue, self.alpha);
}

- (IBAction)fontSizeDidChanged:(UISlider *)sender
{
    self.fontSize = sender.value;
    self.currentFont = [self.currentFont fontWithSize:self.fontSize];
    [self updateLabel];
}
- (IBAction)inputTextDidChanged:(UITextField *)sender
{
    
}

- (void)updateLabel
{
    CGSize size = [self.inputTextField.text sizeWithAttributes:
                   @{NSFontAttributeName: [self.currentFont fontWithSize:self.fontSize + 1]}];
    
    CGRect frame = CGRectMake(0,
                              0,
                              size.width,
                              size.height);
    self.outLabel.frame = frame;
    
    self.outLabel.text = self.inputTextField.text;
    
    [self.delegate setLabel:self.outLabel withPosition:Center];
}

@end
