//
//  EditViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "EditViewController.h"
#import "TopMenuViewController.h"
#import "FiltersMenuViewController.h"
#import "FontsMenuViewController.h"
#import "UIView+SuperClassChecker.h"

@interface EditViewController ()

@property (assign, nonatomic) WorkingMode mode;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) CIContext *ctx;
@property (strong, nonatomic) CIImage *beginImage;
@property (strong, nonatomic) CIFilter *filter;

//TopMenuVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMenuTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *topMenuContainerView;
@property (weak, nonatomic) TopMenuViewController *TopMenuVC;

//FiltersMenuVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFiltersMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *filterMenuContainerView;
@property (weak, nonatomic) FiltersMenuViewController *FiltersMenuVC;

//FontsMenuVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightFontsMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *fontsMenuContainerView;
@property (weak, nonatomic) FontsMenuViewController *FontsMenuVC;

//Handle Views
@property (strong, nonatomic)UIView *topHandleView;
@property (assign, nonatomic)double topHandleViewWidth;
@property (assign, nonatomic)double topHandleViewHeigh;
@property (strong, nonatomic)UIView *rightHandleView;
@property (assign, nonatomic)double rightHandleViewWidth;
@property (assign, nonatomic)double rightHandleViewHeigh;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) BOOL isTopMenuOpened;
@property (assign, nonatomic) BOOL isRightFilteringMenuOpened;
@property (assign, nonatomic) BOOL isRightTextMenuOpened;

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageNamed:@"sea"];
    [self prepare];
    [self addHandlesLogic];
}

- (void)prepare
{
    self.mode = FilteringMenu;
    self.isTopMenuOpened = NO;
    self.isRightFilteringMenuOpened = NO;
    self.isRightTextMenuOpened = NO;
    self.topHandleViewHeigh = 20;
    self.topHandleViewWidth = 100;
    self.rightHandleViewHeigh = 100;
    self.rightHandleViewWidth = 20;
}

- (void)removeAllHandes
{
    for (UIView *v in self.view.subviews)
    {
        if (v.tag == 113 || v.tag == 114 || v.tag == 115)
        {
            [v removeFromSuperview];
        }
    }
}

- (void)addHandlesLogic
{
    [self removeAllHandes];
    [self addTopMenuHandle];
    [self addRightMenuHandle];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)addTopMenuHandle
{
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
    CGRect frame = CGRectMake(self.view.frame.size.width - self.rightHandleViewWidth,
                              self.view.frame.size.height / 2 - self.rightHandleViewHeigh / 2,
                              self.rightHandleViewWidth ,
                              self.rightHandleViewHeigh);
    switch (self.mode)
    {
        case imageFiltering:
        {
            self.rightHandleView = [[UIView alloc] initWithFrame:frame];
            self.rightHandleView.backgroundColor = [UIColor blueColor];
            self.rightHandleView.tag = 114;
        }
            break;
            
        case textEditing:
        {
            self.rightHandleView = [[UIView alloc] initWithFrame:frame];
            self.rightHandleView.backgroundColor = [UIColor greenColor];
            self.rightHandleView.tag = 115;
        }
            break;
            
        default:
            break;
    }
    self.rightHandleView.userInteractionEnabled = YES;
    [self.view addSubview:self.rightHandleView];
}

#pragma mark - gestures
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.view];
    UIView *view = [self.view hitTest:location withEvent:nil];
    
    if(view.tag == 113)
        [self changeStateOfTopMenu];
    if(view.tag == 114)
        [self changeStateOfRightMenu:FilteringMenu];
    if(view.tag == 115)
        [self changeStateOfRightMenu:TextEditingMenu];
    else
        return;
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if (pan.state == UIGestureRecognizerStateCancelled)
    {
        [app endIgnoringInteractionEvents];
        self.panGesture.enabled = YES;
    }
    
    UIView *view;
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [app beginIgnoringInteractionEvents];
        CGPoint location = [pan locationInView:self.view];
        view = [self.view hitTest:location withEvent:nil];
    }
    
    CGPoint velocity = [pan velocityInView:self.view];
    
    if ([view superTag:1111])
    {
        if(velocity.y < 0)
        {
            [self changeStateOfTopMenu];
            self.panGesture.enabled = NO;
        }
    }
    else if ([view superTag:2222])
    {
        if(velocity.x > 0)
        {
            [self changeStateOfRightMenu:TextEditingMenu];
            self.panGesture.enabled = NO;
        }
    }
    else if ([view superTag:3333])
    {
        if(velocity.x > 0)
        {
            [self changeStateOfRightMenu:FilteringMenu];
            self.panGesture.enabled = NO;
        }
    }
    
   
}

#pragma mark - constraints changing
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

- (void)changeStateOfRightMenu:(RightMenuType)type
{
    switch (type)
    {
        case FilteringMenu:
            [self changeStateOfFilteringMenu];
            break;
            
        case TextEditingMenu:
            [self changeStateOfTextEditingMenu];
            break;
            
        default:
            break;
    }
}

- (void)changeStateOfFilteringMenu
{
    if (self.isRightFilteringMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFiltersMenuTrailingConstraint
                                  ToValue:-self.rightFiltersMenuWidthConstraint.constant];
        self.isRightFilteringMenuOpened = NO;
        self.tapGesture.enabled = YES;
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFiltersMenuTrailingConstraint ToValue:0];
        self.isRightFilteringMenuOpened = YES;
        self.tapGesture.enabled = YES;
    }
}

- (void)changeStateOfTextEditingMenu
{
    if (self.isRightTextMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFontsMenuTrailingConstraint
                                  ToValue:-self.rightFontsMenuWidthConstraint.constant];
        self.isRightTextMenuOpened = NO;
        self.tapGesture.enabled = YES;
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFontsMenuTrailingConstraint ToValue:0];
        self.isRightTextMenuOpened = YES;
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

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TopMenuVC_seague"])
    {
        self.TopMenuVC = (TopMenuViewController *)[segue destinationViewController];
        self.TopMenuVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"FiltersMenuVC_seague"])
    {
        self.FiltersMenuVC = (FiltersMenuViewController *)[segue destinationViewController];
    }
    else if ([segue.identifier isEqualToString:@"FontsMenuVC_seague"])
    {
        self.FontsMenuVC = (FontsMenuViewController *)[segue destinationViewController];
    }
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
