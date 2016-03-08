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

typedef enum{
    settings,
    fonts,
    filters
}handleType;

typedef enum{
    forward,
    back
}movingHandleType;

@interface EditViewController ()

@property (assign, nonatomic) WorkingMode mode;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

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
@property (strong, nonatomic) UIView *leftHandleView;
@property (strong, nonatomic) UIView *rightHandleView;
@property (assign, nonatomic) double handleViewHeigh;
@property (assign, nonatomic) double handleViewWidth;
@property (strong, nonatomic) UIImageView *settingsArrow;
@property (strong, nonatomic) UIImageView *filtersArrow;
@property (strong, nonatomic) UIImageView *fontsArrow;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) UIImageView *readyToGoImageView;

@property (assign, nonatomic) NSString *shouldShowAlert;

@property (assign, nonatomic) BOOL isLoadIndicating;

@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;

@end

@implementation EditViewController

@synthesize isLeftMenuOpened;
@synthesize isRightFilteringMenuOpened;
@synthesize isRightTextMenuOpened;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self prepareScrollView];
    
    [self updateUIWithImage:self.image];
    
    if ([self.image.description hasPrefix:@"<_UIAnimatedImage"])
    {
        [self checkShouldShowAlert];
        [self showAlertView];
        [self.settingsMenuVC disableButton];
    }
    
    [self prepare];
    [self addHandlesLogic];
    
    self.FiltersMenuVC.currentImage = self.image;
    [self.FiltersMenuVC updateYourself];
    self.FontsMenuVC.imageWidth = self.image.size.width;
    [self.FontsMenuVC updateYourself];
    [self.settingsMenuVC updateYourself];
}

- (void)prepareScrollView
{
    self.imageViewWidthConstraint.constant = self.view.frame.size.width;
    self.imageViewHeightConstraint.constant = self.view.frame.size.height;
}

- (void)checkShouldShowAlert
{
    self.shouldShowAlert = @"YES";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"shouldShowAlert"] isEqualToString:@"NO"])
        self.shouldShowAlert = @"NO";
}

- (void)showAlertView
{
    if ([self.shouldShowAlert isEqualToString:@"YES"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This image cuold be animated" message:@"Editing of GIF images will cause it to become not animated" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Don't show this again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                        [defaults setObject:@"NO" forKey:@"shouldShowAlert"];
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self addHandlesLogic];
    if (self.isLoadIndicating)
    {
        
        [self stopLoadIndicating];
        [self startLoadIndicating];
        
    }
    self.imageViewWidthConstraint.constant = self.view.frame.size.width;
    self.imageViewHeightConstraint.constant = self.view.frame.size.height;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self closeAllMenus];
    [self removeAllHandes];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateBegan)
    {
        [self closeAllMenus];
    }
    else if (pinch.state == UIGestureRecognizerStateChanged)
    {
        if (self.imageViewWidthConstraint.constant < self.view.frame.size.width * 10 || pinch.scale < 1)//max scale
        {
            CGFloat xDiferance = self.imageView.frame.size.width * pinch.scale - self.imageView.frame.size.width;
            CGFloat yDiferance = self.imageView.frame.size.height * pinch.scale - self.imageView.frame.size.height;
            
            if (pinch.scale < 1 && (self.imageViewWidthConstraint.constant <= self.view.frame.size.width
                                    || self.imageViewHeightConstraint.constant <= self.view.frame.size.height))//min scale
            {
                self.imageViewWidthConstraint.constant = self.view.frame.size.width;
                self.imageViewHeightConstraint.constant = self.view.frame.size.height;
            }
            else
            {
                self.imageViewWidthConstraint.constant += xDiferance;
                self.imageViewHeightConstraint.constant += yDiferance;
            }
        }
        pinch.scale = 1.0;
    }
    else
    {
        CGFloat offsetX = (self.imageView.frame.size.width - self.view.frame.size.width) / 2;
        CGFloat offsetY = (self.imageView.frame.size.height - self.view.frame.size.height) / 2;
        CGRect rect = CGRectMake(offsetX, offsetY, self.view.frame.size.width, self.view.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }
}

- (void)prepare
{
    self.mode = FilteringMenu;
    self.isLeftMenuOpened = NO;
    self.isRightFilteringMenuOpened = NO;
    self.isRightTextMenuOpened = NO;
    self.handleViewHeigh = 100;
    self.handleViewWidth = 100;
    
    self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:self.pinch];
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

- (void)moveHandle:(handleType)handle inDirection:(movingHandleType)direction
{
    if (handle == settings)
    {
        UIView *view = [self getViewForHandleType:settings];
        if (direction == forward)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(self.settingsMenuWidthConstraint.constant,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
        else if (direction == back)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(0,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
    }
    else if (handle == filters)
    {
        UIView *view = [self getViewForHandleType:filters];
        if (direction == forward)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(self.view.frame.size.width - view.frame.size.width - self.rightFiltersMenuWidthConstraint.constant,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
        else if (direction == back)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(self.view.frame.size.width - view.frame.size.width,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
    }
    else if (handle == fonts)
    {
        UIView *view = [self getViewForHandleType:fonts];
        if (direction == forward)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(self.view.frame.size.width - view.frame.size.width - self.rightFontsMenuWidthConstraint.constant,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
        else if (direction == back)
        {
            [self hideView:view ForTime:1.2];
            CGRect frame = CGRectMake(self.view.frame.size.width - view.frame.size.width,
                                      view.frame.origin.y,
                                      view.frame.size.width,
                                      view.frame.size.height);
            view.frame = frame;
        }
    }
}

- (UIView *)getViewForHandleType:(handleType)handle
{
    NSInteger tag = 100;
    if (handle == settings)
        tag = 113;
    else if (handle == fonts)
        tag = 115;
    else if (handle == filters)
        tag = 114;
    
    for (UIView *subview in self.view.subviews)
    {
        if (subview.tag == tag)
            return subview;
    }
    return nil;
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
    [self configureViewDesign:self.leftHandleView];
    
    CGRect labelFrame = CGRectMake(0,
                                   - self.handleViewHeigh / 2,
                                   self.handleViewWidth,
                                   self.handleViewHeigh / 2);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = @"settings";
    label.textAlignment = NSTextAlignmentCenter;
    [self.leftHandleView addSubview:label];
    
    CGRect iconFrame = CGRectMake(5,
                                  5,
                                   self.handleViewWidth,
                                   self.handleViewHeigh);
    self.settingsArrow = [[UIImageView alloc] initWithFrame:iconFrame];
    self.settingsArrow.image = [UIImage imageNamed:@"arrow_right"];
    [self.leftHandleView addSubview:self.settingsArrow];
    
    self.leftHandleView.tag = 113;
    self.leftHandleView.userInteractionEnabled = YES;
    [self.view addSubview:self.leftHandleView];
    [self hideView:self.leftHandleView ForTime:1.2];
}

- (void)addRightMenuHandle
{
    CGRect frame = CGRectMake(self.view.frame.size.width - self.handleViewWidth,
                              self.view.frame.size.height / 2 - self.handleViewHeigh / 2,
                              self.handleViewWidth ,
                              self.handleViewHeigh);
    self.rightHandleView = [[UIView alloc] initWithFrame:frame];
    [self configureViewDesign:self.rightHandleView];
    
    CGRect labelFrame = CGRectMake(0,
                                   - self.handleViewHeigh / 2,
                                   self.handleViewWidth,
                                   self.handleViewHeigh / 2);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    CGRect iconFrame = CGRectMake(5,
                                  5,
                                  self.handleViewWidth,
                                  self.handleViewHeigh);
    
    
    switch (self.mode)
    {
        case imageFiltering:
        {
            self.rightHandleView.tag = 114;
            label.text = @"filters";
            [self.rightHandleView addSubview:label];
            
            self.filtersArrow = [[UIImageView alloc] initWithFrame:iconFrame];
            self.filtersArrow.image = [UIImage imageNamed:@"arrow_left"];
            [self.rightHandleView addSubview:self.filtersArrow];
        }
            break;
            
        case textEditing:
        {
            self.rightHandleView.tag = 115;
            label.text = @"fonts";
            [self.rightHandleView addSubview:label];
            
            self.fontsArrow = [[UIImageView alloc] initWithFrame:iconFrame];
            self.fontsArrow.image = [UIImage imageNamed:@"arrow_left"];
            [self.rightHandleView addSubview:self.fontsArrow];
        }
            break;
            
        default:
            break;
    }
    self.rightHandleView.userInteractionEnabled = YES;
    [self.view addSubview:self.rightHandleView];
    [self hideView:self.rightHandleView ForTime:1.2];
}

- (void)configureViewDesign:(UIView *)view
{
    view.backgroundColor = [UIColor colorWithRed:0.22 green:0.91 blue:0.87 alpha:0.3];
    
    // border radius
    view.layer.cornerRadius = 5;
    
    // border
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.05f];
    
    // drop shadow
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.3];
    [view.layer setShadowRadius:15.0];
    [view.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
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
    
    if ([view superTag:1111]) // settingsMenu
    {
        self.settingsMenuVC.shouldRespondToTouchEvents = NO;
        if(velocity.x < 0)
        {
            [self changeStateOfLeftMenu];
            self.panGesture.enabled = NO;
        }
    }
    if (view.tag == 113)
    {
        self.settingsMenuVC.shouldRespondToTouchEvents = NO;
        if(velocity.x > 0)
        {
            [self changeStateOfLeftMenu];
            self.panGesture.enabled = NO;
        }
    }
    
    else if ([view superTag:2222]) // FontsMenu
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
    if (view.tag == 115)
    {
        self.settingsMenuVC.shouldRespondToTouchEvents = NO;
        if(velocity.x < 0)
        {
            [self changeStateOfRightMenu:TextEditingMenu];
            self.panGesture.enabled = NO;
        }
    }
    
    else if ([view superTag:3333]) // FiltersMenu
    {
        if(velocity.x > 0)
        {
            [self changeStateOfRightMenu:FilteringMenu];
            self.panGesture.enabled = NO;
        }
    }
    if (view.tag == 114)
    {
        self.settingsMenuVC.shouldRespondToTouchEvents = NO;
        if(velocity.x < 0)
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
        [self moveHandle:settings inDirection:back];
        self.settingsArrow.image = [UIImage imageNamed:@"arrow_right"];
        self.isLeftMenuOpened = NO;
    }
    if (self.isRightFilteringMenuOpened)
    {
        self.rightFiltersMenuTrailingConstraint.constant = -self.rightFiltersMenuWidthConstraint.constant;
        [self moveHandle:filters inDirection:back];
        self.filtersArrow.image = [UIImage imageNamed:@"arrow_left"];
        self.isRightFilteringMenuOpened = NO;
    }
    if (self.isRightTextMenuOpened)
    {
        self.rightFontsMenuTrailingConstraint.constant = -self.rightFontsMenuWidthConstraint.constant;
        [self moveHandle:fonts inDirection:back];
        self.fontsArrow.image = [UIImage imageNamed:@"arrow_left"];
        self.isRightTextMenuOpened = NO;
    }
}

- (void)changeStateOfLeftMenu
{
    if (self.isLeftMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.settingsMenuLeadingConstraint ToValue:-self.settingsMenuWidthConstraint.constant];
        [self moveHandle:settings inDirection:back];
        self.isLeftMenuOpened = NO;
        self.tapGesture.enabled = YES;
        self.settingsArrow.image = [UIImage imageNamed:@"arrow_right"];
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.settingsMenuLeadingConstraint ToValue:0];
        [self moveHandle:settings inDirection:forward];
        self.isLeftMenuOpened = YES;
        self.tapGesture.enabled = YES;
        self.settingsMenuVC.shouldRespondToTouchEvents = YES;
        self.settingsArrow.image = [UIImage imageNamed:@"arrow_left"];
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
        [self moveHandle:filters inDirection:back];
        self.isRightFilteringMenuOpened = NO;
        self.tapGesture.enabled = YES;
        self.filtersArrow.image = [UIImage imageNamed:@"arrow_left"];
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFiltersMenuTrailingConstraint ToValue:0];
        [self moveHandle:filters inDirection:forward];
        self.isRightFilteringMenuOpened = YES;
        self.tapGesture.enabled = YES;
        self.filtersArrow.image = [UIImage imageNamed:@"arrow_right"];
    }
}

- (void)changeStateOfTextEditingMenu
{
    if (self.isRightTextMenuOpened)
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFontsMenuTrailingConstraint
                                  ToValue:-self.rightFontsMenuWidthConstraint.constant];
        [self moveHandle:fonts inDirection:back];
        self.isRightTextMenuOpened = NO;
        self.tapGesture.enabled = YES;
        self.fontsArrow.image = [UIImage imageNamed:@"arrow_left"];
    }
    else
    {
        self.tapGesture.enabled = NO;
        [self animateChangingOfConstraint:self.rightFontsMenuTrailingConstraint ToValue:0];
        [self moveHandle:fonts inDirection:forward];
        self.isRightTextMenuOpened = YES;
        self.tapGesture.enabled = YES;
        self.fontsArrow.image = [UIImage imageNamed:@"arrow_right"];
    }
    //self.FontsMenuVC.shouldRespondOnSlideEvents = YES;
}

#pragma mark - animations
- (void)hideView:(UIView *)view ForTime:(double)seconds
{
    [UIView animateWithDuration:seconds animations:^()
    {
        view.alpha = 0.0;
        view.alpha = 1.0;
    }];
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.8f animations:^
     {
         [weakSelf.view layoutIfNeeded];
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
    [self startLoadIndicating];
    UIImageWriteToSavedPhotosAlbum([self getImageFromCurrentContext], nil, nil, nil);
    [self stopLoadIndicating];
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
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        UIGraphicsBeginImageContextWithOptions(self.readyToGoImageView.frame.size, YES, 0.0);
        
        [self.readyToGoImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
    });
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - filteringDelegate
- (void)updateUIWithImage:(UIImage *)image
{
    self.readyToGoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                           image.size.width,
                                                                           image.size.height)];
    self.readyToGoImageView.image = image;

    self.imageView.image = image;
}

- (void)startLoadIndicating
{
    @synchronized(self)
    {
        self.isLoadIndicating = YES;
        UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
        background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        background.tag = 1001;
        [self.view addSubview:background];
        [UIActivityIndicatorView addActivityIndicatorToView:self.view];
    }
}

- (void)stopLoadIndicating
{
    @synchronized(self)
    {
        self.isLoadIndicating = NO;
        for (UIView *subview in self.view.subviews)
        {
            if (subview.tag == 1001)
            {
                [subview removeFromSuperview];
            }
        }
        [UIActivityIndicatorView removeActivityIndicatorFromView:self.view];
    }
}

#pragma mark - fontDelegate
- (void)setLabel:(UILabel *)label withPosition:(PositionType)position
{
    //[self removeTextLabels];
    //label.tag = 911;
    
    /*if (self.image.size.width > 100)
    {
        double pointCount = self.image.size.width / 100;
        double newFontSize = label.font.pointSize + (pointCount * 3);
        
        UIFont *newFont = [UIFont fontWithName:label.font.fontName size:newFontSize];
        
        CGSize size = [label.text sizeWithAttributes:
                       @{NSFontAttributeName: newFont}];
        
        CGRect frame = CGRectMake(0,
                                  0,
                                  size.width,
                                  size.height);
        label.frame = frame;
        
        label.font = newFont;
    }*/
    
    //CGRect imageRect = [self.imageView calculateClientRectOfImage];
    CGRect renderingImageRect = self.readyToGoImageView.frame;
    //UILabel *renderLabel = [self deepLabelCopy:label];
    
    dispatch_queue_t queue;
    if ([NSThread isMainThread])
        queue = dispatch_get_current_queue();
    else
        queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^
    {
        for (UIView *subview in self.readyToGoImageView.subviews)
        {
            [subview removeFromSuperview];
        }
        
        switch (position)
        {
            case LeftTop:
            {
                /*CGRect frame = CGRectMake(imageRect.origin.x,
                                          imageRect.origin.y,
                                          label.frame.size.width,
                                          label.frame.size.height);
                label.frame = frame;
                [self.view insertSubview:label aboveSubview:self.imageView];*/
                
                CGRect renderFrame = CGRectMake(renderingImageRect.origin.x,
                                                renderingImageRect.origin.y,
                                                label.frame.size.width,
                                                label.frame.size.height);
                label.frame = renderFrame;
                [self.readyToGoImageView insertSubview:label aboveSubview:self.imageView];
            }
                break;
                
            case RightTop:
            {
                /*CGRect frame = CGRectMake(imageRect.size.width - label.frame.size.width,
                                          imageRect.origin.y,
                                          label.frame.size.width,
                                          label.frame.size.height);
                label.frame = frame;
                [self.view insertSubview:label aboveSubview:self.imageView];*/
                
                CGRect renderFrame = CGRectMake(renderingImageRect.size.width - label.frame.size.width,
                                                renderingImageRect.origin.y,
                                                label.frame.size.width,
                                                label.frame.size.height);
                label.frame = renderFrame;
                [self.readyToGoImageView insertSubview:label aboveSubview:self.imageView];
            }
                break;
                
            case LeftBottom:
            {
                /*CGRect frame = CGRectMake(imageRect.origin.x,
                                          imageRect.origin.y + imageRect.size.height - label.frame.size.height,
                                          label.frame.size.width,
                                          label.frame.size.height);
                label.frame = frame;
                [self.view insertSubview:label aboveSubview:self.imageView];*/
                
                CGRect renderFrame = CGRectMake(renderingImageRect.origin.x,
                                                renderingImageRect.origin.y + renderingImageRect.size.height - label.frame.size.height,
                                                label.frame.size.width,
                                                label.frame.size.height);
                label.frame = renderFrame;
                [self.readyToGoImageView insertSubview:label aboveSubview:self.imageView];
            }
                break;
                
            case RightBottom:
            {
                /*CGRect frame = CGRectMake(imageRect.size.width - label.frame.size.width,
                                          imageRect.origin.y + imageRect.size.height - label.frame.size.height,
                                          label.frame.size.width,
                                          label.frame.size.height);
                label.frame = frame;
                [self.view insertSubview:label aboveSubview:self.imageView];*/
                
                CGRect renderFrame = CGRectMake(renderingImageRect.size.width - label.frame.size.width,
                                                renderingImageRect.origin.y + renderingImageRect.size.height - label.frame.size.height,
                                                label.frame.size.width,
                                                label.frame.size.height);
                label.frame = renderFrame;
                [self.readyToGoImageView insertSubview:label aboveSubview:self.imageView];
            }
                break;
                
            case Center:
            {
                /*CGRect frame = CGRectMake(imageRect.size.width / 2 - label.frame.size.width / 2,
                                          imageRect.origin.y + imageRect.size.height / 2 - label.frame.size.height / 2,
                                          label.frame.size.width,
                                          label.frame.size.height);
                label.frame = frame;
                [self.view insertSubview:label aboveSubview:self.imageView];*/
                
                CGRect renderFrame = CGRectMake(renderingImageRect.size.width / 2 - label.frame.size.width / 2,
                                                renderingImageRect.origin.y + renderingImageRect.size.height / 2 - label.frame.size.height / 2,
                                                label.frame.size.width,
                                                label.frame.size.height);
                label.frame = renderFrame;
                [self.readyToGoImageView insertSubview:label aboveSubview:self.imageView];
            }
                break;
                
            default:
                break;
        }
        self.imageView.image = [self getImageFromCurrentContext];
    });
}

- (UILabel *)deepLabelCopy:(UILabel *)label
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:label.frame];
    duplicateLabel.text = label.text;
    duplicateLabel.textColor = label.textColor;
    duplicateLabel.font = label.font;
    
    return duplicateLabel;
}

- (void)removeTextLabels
{
    dispatch_queue_t queue;
    if ([NSThread isMainThread])
        queue = dispatch_get_current_queue();
    else
        queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^
    {
        for (UIView *subview in self.readyToGoImageView.subviews)
        {
                [subview removeFromSuperview];
        }
        self.imageView.image = [self getImageFromCurrentContext];
    });
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
