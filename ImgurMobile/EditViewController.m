//
//  EditViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "EditViewController.h"
#import "TopMenuViewController.h"

@interface EditViewController ()

@property (assign, nonatomic) WorkingMode mode;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

//Top menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *topMenuContainerView;

//Right Filters Menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *filterMenuContainerView;

//Right Fonts Menu
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *fontsMenuContainerView;

//Handle Views
@property (strong, nonatomic)UIView *topHandleView;
@property (assign, nonatomic)double topHandleViewWidth;
@property (assign, nonatomic)double topHandleViewHeigh;
@property (strong, nonatomic)UIView *rightHandleView;
@property (assign, nonatomic)double rightHandleViewWidth;
@property (assign, nonatomic)double rightHandleViewHeigh;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (assign, nonatomic) BOOL isTopMenuOpened;

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageNamed:@"sea"];
    
    [self addHandlesLogic];
}

- (void)addHandlesLogic
{
    [self addTopMenuHandle];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.isTopMenuOpened = NO;
    self.topMenuContainerView.tag = 1133;
}

- (void)addTopMenuHandle
{
    self.topHandleViewHeigh = 20;
    self.topHandleViewWidth = 100;
    CGRect frame = CGRectMake(self.view.frame.size.width / 2 - self.topHandleViewWidth / 2,
                               self.view.frame.origin.y,
                               self.topHandleViewWidth ,
                               self.topHandleViewHeigh);
    
    self.topHandleView = [[UIView alloc] initWithFrame:frame];
    self.topHandleView.backgroundColor = [UIColor redColor];
    self.topHandleView.tag = 113;
    self.topHandleView.userInteractionEnabled = YES;
    [self.view addSubview:self.topHandleView];
}

- (void)addRightMenuHandle
{
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    if(view.tag == 113)
    {
        [self changeStateOfTopMenu];
    }
    else
        return;

}

- (void)changeStateOfTopMenu
{
    if (self.isTopMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.topMenuTopConstraint ToValue:-100];
        self.isTopMenuOpened = NO;
        self.tapGesture.enabled = YES;
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.topMenuTopConstraint ToValue:0];
        self.isTopMenuOpened = YES;
        self.tapGesture.enabled = YES;
    }
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.8f animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

#pragma mark - topMenuDelegate

- (void)changeWorkingModeTo:(WorkingMode) mode
{
    self.mode = mode;
    [self addHandlesLogic];
}

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image = [UIImage imageNamed:@"sea"];
    
    
    self.ctx = [CIContext contextWithOptions:nil];

    self.beginImage = [CIImage imageWithCGImage:self.image.CGImage];
    
    self.filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:
                        kCIInputImageKey, self.beginImage,
                        @"inputIntensity", @0.8, nil];
    
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}

- (IBAction)intensityBeenChanged:(UISlider *)sender
{
    float slideValue = sender.value;
    
    [self.filter setValue:@(slideValue)
              forKey:@"inputIntensity"];
    CIImage *outImage = [self.filter outputImage];
    
    CGImageRef cgImg = [self.ctx createCGImage:outImage fromRect:[outImage extent]];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImg];
    
    CGImageRelease(cgImg);
}

- (void)addScrollView
{
    
}*/


@end
