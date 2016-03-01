//
//  FontsMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FontsMenuViewController.h"
#import "UIButton+highlighter.h"

UIColor * RGBA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@interface FontsMenuViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//Sliders
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;

@property (weak, nonatomic) IBOutlet UIImageView *colorIndicator;

@property (weak, nonatomic) IBOutlet UIPickerView *fontPicker;
@property (strong, nonatomic) NSArray *fontNamesArray;

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

@property (assign, nonatomic) PositionType currentPosition;

@property (assign, nonatomic) BOOL shouldPosition;

@property (strong, nonatomic)  UILabel *outLabel;

@end

@implementation FontsMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glas_texture"]];
    
    // border radius
    self.contentView.layer.cornerRadius = 5;
    
    // drop shadow
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.8];
    [self.view.layer setShadowRadius:5.0];
    [self.view.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
}

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
    self.shouldPosition = NO;
    self.shouldRespondOnSlideEvents = YES;
    self.fontPicker.delegate = self;
    self.inputTextField.text = @"choose text, You need";
    [self getArrayOfFontNames];
    [self.fontPicker reloadAllComponents];
    [self setInitialColor];
    [self setInitialFontSize];
}

- (void)setInitialFontSize
{
    self.fontSize = 10;
    self.currentFont = [UIFont systemFontOfSize:self.fontSize];
    [self updateLabel];
}

- (void)setInitialColor
{
    self.red = 0;
    self.green = 0;
    self.blue = 0;
    self.alpha = 1;
    self.currentColor = RGBA(self.red, self.green, self.blue, self.alpha);
}

- (IBAction)positionDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.currentPosition = LeftTop;
            self.shouldPosition = YES; break;
            
        case 2:
            self.currentPosition = RightTop;
            self.shouldPosition = YES; break;
            
        case 3:
            self.currentPosition = LeftBottom;
            self.shouldPosition = YES; break;
            
        case 4:
            self.currentPosition = RightBottom;
            self.shouldPosition = YES; break;
            
        case 5:
            self.currentPosition = Center;
            self.shouldPosition = YES; break;
            
        case 6:
            self.shouldPosition = NO; break;
            
        default:
            break;
    }
    [self updateLabel];
}

- (IBAction)colorDidChanged:(UISlider *)sender
{
    self.shouldRespondOnSlideEvents = NO;
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
    [self updateLabel];
}

- (IBAction)fontSizeDidChanged:(UISlider *)sender
{
    self.shouldRespondOnSlideEvents = NO;
    self.fontSize = sender.value;
    self.currentFont = [self.currentFont fontWithSize:self.fontSize];
    [self updateLabel];
}
- (IBAction)inputTextDidChanged:(UITextField *)sender
{
    [self updateLabel];
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
    
    self.outLabel.font = self.currentFont;
    
    self.outLabel.text = self.inputTextField.text;
    
    self.outLabel.textColor = self.currentColor;
    
    if (self.shouldPosition)
        [self.delegate setLabel:self.outLabel withPosition:self.currentPosition];
    else
        [self.delegate removeTextLabels];
}

- (void)getArrayOfFontNames
{
    NSMutableArray *outArray = [NSMutableArray array];
    
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        for (NSString *name in fontNames)
        {
            [outArray addObject:name];
        }
    }
    
    self.fontNamesArray = outArray;
}

#pragma mark UIPickerViewDelegate UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.fontNamesArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    
    if (!label)
        label = [[UILabel alloc] init];
    
    label.text = [self.fontNamesArray objectAtIndex:row];
    
    label.font = [UIFont fontWithName:[self.fontNamesArray objectAtIndex:row]
                                 size:16];
    CGSize size = [label.text sizeWithAttributes:
                   @{NSFontAttributeName: [label.font fontWithSize:17]}];
    
    CGRect frame = CGRectMake(0,
                              0,
                              size.width,
                              size.height);
    
    label.frame = frame;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentFont = [UIFont fontWithName:[self.fontNamesArray objectAtIndex:row]
                                       size:self.fontSize];
    [self updateLabel];
}


@end
