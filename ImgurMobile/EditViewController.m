//
//  EditViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "EditViewController.h"
#import "SettingsMenuViewController.h"
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

//SettingsMenuVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsMenuLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingsMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *leftMenuContainerView;
@property (weak, nonatomic) SettingsMenuViewController *settingsMenuVC;

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
@property (strong, nonatomic)UIView *leftHandleView;
@property (strong, nonatomic)UIView *rightHandleView;
@property (assign, nonatomic)double handleViewHeigh;
@property (assign, nonatomic)double handleViewWidth;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic) BOOL isLeftMenuOpened;
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
    self.isLeftMenuOpened = NO;
    self.isRightFilteringMenuOpened = NO;
    self.isRightTextMenuOpened = NO;
    self.handleViewHeigh = 100;
    self.handleViewWidth = 20;
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
    [self addLeftMenuHandle];
    [self addRightMenuHandle];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)addLeftMenuHandle
{
    CGRect frame = CGRectMake(self.view.frame.origin.x,
                               self.view.frame.size.height / 2 - self.handleViewHeigh / 2,
                               self.handleViewWidth ,
                               self.handleViewHeigh);
    
    self.leftHandleView = [[UIView alloc] initWithFrame:frame];
    self.leftHandleView.backgroundColor = [UIColor redColor];
    self.leftHandleView.tag = 113;
    self.leftHandleView.userInteractionEnabled = YES;
    [self.view addSubview:self.leftHandleView];
}

- (void)addRightMenuHandle
{
    CGRect frame = CGRectMake(self.view.frame.size.width - self.handleViewWidth,
                              self.view.frame.size.height / 2 - self.handleViewHeigh / 2,
                              self.handleViewWidth ,
                              self.handleViewHeigh);
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
        [self changeStateOfLeftMenu];
    if(view.tag == 114)
        [self changeStateOfRightMenu:FilteringMenu];
    if(view.tag == 115)
        [self changeStateOfRightMenu:TextEditingMenu];
    else
        return;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
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
        if(velocity.x < 0)
        {
            [self changeStateOfLeftMenu];
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
- (void)changeStateOfLeftMenu
{
    if (self.isLeftMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.settingsMenuLeadingConstraint ToValue:-self.settingsMenuWidthConstraint.constant];
        self.isLeftMenuOpened = NO;
        self.tapGesture.enabled = YES;
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.settingsMenuLeadingConstraint ToValue:0];
        self.isLeftMenuOpened = YES;
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
        self.settingsMenuVC = (SettingsMenuViewController *)[segue destinationViewController];
        self.settingsMenuVC.delegate = self;
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
