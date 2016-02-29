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
#import "UIActivityIndicatorView+manager.h"
#import "UIImageView+imageRectGetter.h"
#import "ImgurPosting.h"

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
    self.image = [UIImage imageNamed:@"sea"];
    self.imageView.image = self.image;
    [self prepare];
    [self addHandlesLogic];
    
    self.FiltersMenuVC.currentImage = self.image;
    [self.FiltersMenuVC updateYourself];
    [self.FontsMenuVC updateYourself];
    [self.settingsMenuVC updateYourself];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self addHandlesLogic];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self removeAllHandes];
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
        self.settingsMenuVC.shouldRespondToTouchEvents = NO;
        if(velocity.x < 0)
        {
            [self changeStateOfLeftMenu];
            self.panGesture.enabled = NO;
        }
    }
    else if ([view superTag:2222])
    {
        if (self.FontsMenuVC.shouldRespondOnSlideEvents)
        {
            if(velocity.x > 0)
            {
                [self changeStateOfRightMenu:TextEditingMenu];
                self.panGesture.enabled = NO;
            }
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
- (void)closeAllMenus
{
    if (self.isLeftMenuOpened)
    {
        self.settingsMenuLeadingConstraint.constant = -self.settingsMenuWidthConstraint.constant;
        self.isLeftMenuOpened = NO;
    }
    if (self.isRightFilteringMenuOpened)
    {
        self.rightFiltersMenuTrailingConstraint.constant = -self.rightFiltersMenuWidthConstraint.constant;
        self.isRightFilteringMenuOpened = NO;
    }
    if (self.isRightTextMenuOpened)
    {
        self.rightFontsMenuTrailingConstraint.constant = -self.rightFontsMenuWidthConstraint.constant;
        self.isRightTextMenuOpened = NO;
    }
}

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
        self.settingsMenuVC.shouldRespondToTouchEvents = YES;
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
    self.FontsMenuVC.shouldRespondOnSlideEvents = YES;
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

#pragma mark - settingsMenuDelegate
- (void)changeWorkingModeTo:(WorkingMode) mode
{
    self.mode = mode;
    [self addHandlesLogic];
}

- (void)saveImageToGallery
{
    UIImageWriteToSavedPhotosAlbum([self getImageFromCurrentContext], nil, nil, nil);
}

- (void)giveImageToShareVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImgurPosting * postingStoryboardVC = (ImgurPosting *)[sb instantiateViewControllerWithIdentifier:@"postingStoryboardVC"];
    postingStoryboardVC.image = [self getImageFromCurrentContext];
    
    [self.navigationController pushViewController:postingStoryboardVC animated:YES];
}

- (UIImage *)getImageFromCurrentContext
{
    [self removeAllHandes];
    
    UIGraphicsBeginImageContextWithOptions([self.imageView calculateClientRectOfImage].size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self addHandlesLogic];
    
    return image;
}

#pragma mark - filteringDelegate
- (void)updateUIWithImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)startLoadIndicating
{
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    background.tag = 1001;
    [self.view addSubview:background];
    [UIActivityIndicatorView addActivityIndicatorToView:self.view];
}

- (void)stopLoadIndicating
{
    for (UIView *subview in self.view.subviews)
    {
        if (subview.tag == 1001)
        {
            [subview removeFromSuperview];
        }
    }
    [UIActivityIndicatorView removeActivityIndicatorFromView:self.view];
}

#pragma mark - fontDelegate
- (void)setLabel:(UILabel *)label withPosition:(PositionType)position
{
    [self removeTextLabels];
    label.tag = 911;
    
    CGRect imageRect = [self.imageView calculateClientRectOfImage];
    
    switch (position)
    {
        case LeftTop:
        {
            CGRect frame = CGRectMake(imageRect.origin.x,
                                      imageRect.origin.y,
                                      label.frame.size.width,
                                      label.frame.size.height);
            label.frame = frame;
            [self.view addSubview:label];
        }
            break;
            
        case RightTop:
        {
            CGRect frame = CGRectMake(imageRect.size.width - label.frame.size.width,
                               imageRect.origin.y,
                               label.frame.size.width,
                               label.frame.size.height);
            label.frame = frame;
            [self.view addSubview:label];
        }
            break;
            
        case LeftBottom:
        {
            CGRect frame = CGRectMake(imageRect.origin.x,
                               imageRect.size.height - label.frame.size.height,
                               label.frame.size.width,
                               label.frame.size.height);
            label.frame = frame;
            [self.view addSubview:label];
        }
            break;
            
        case RightBottom:
        {
            CGRect frame = CGRectMake(imageRect.size.width - label.frame.size.width,
                               imageRect.size.height - label.frame.size.height,
                               label.frame.size.width,
                               label.frame.size.height);
            label.frame = frame;
            [self.view addSubview:label];
        }
            break;
            
        case Center:
        {
            CGRect frame = CGRectMake(imageRect.size.width / 2 - label.frame.size.width / 2,
                                      imageRect.size.height / 2 - label.frame.size.height / 2,
                                      label.frame.size.width,
                                      label.frame.size.height);
            label.frame = frame;
            [self.view addSubview:label];
        }
            break;
            
        default:
            break;
    }
}

- (void)removeTextLabels
{
    for (UIView *subview in self.view.subviews)
    {
        if (subview.tag == 911)
        {
            [subview removeFromSuperview];
        }
    }
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
        self.FiltersMenuVC.delegate = self;
        self.FiltersMenuVC.filterDelegate = self;
    }
    else if ([segue.identifier isEqualToString:@"FontsMenuVC_seague"])
    {
        self.FontsMenuVC = (FontsMenuViewController *)[segue destinationViewController];
        self.FontsMenuVC.delegate = self;
    }
}




@end
