//
//  FiltersMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FiltersMenuViewController.h"
#import "ImageFilterProcessor.h"
#import "UIImage+Resize.h"
#import "UIActivityIndicatorView+manager.h"

@interface FiltersMenuViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeighConstraint;
@property (strong, nonatomic) NSMutableArray *processedSampleImages;
@property (assign, nonatomic) CGSize sampleImageSize;
@property (strong, nonatomic) UIImage *sampleImage;

@property (strong, nonatomic) ImageFilterProcessor *processor;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"glas_texture"]];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // border radius
    self.view.layer.cornerRadius = 5;
    
    // drop shadow
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.8];
    [self.view.layer setShadowRadius:5.0];
    [self.view.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
}

- (void)updateYourself
{
    self.view.tag = 3333;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:self.tapGesture];
    
    [self configureScrollView];
    
    [self fillImagesArrayWithPlaceHolders];
    
    [self getSampleImages];
}

- (void)fillImagesArrayWithPlaceHolders
{
    self.processedSampleImages = [NSMutableArray array];
    double yCoordinate = 10;
    
    for (int i = 0; i < FILTERS_COUNT; i++)
    {
        CGRect frame = CGRectMake(0, yCoordinate + (self.sampleImageSize.height + 10) * i,
                                  self.sampleImageSize.width,
                                  self.sampleImageSize.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        [UIActivityIndicatorView addActivityIndicatorToView:imageView];
        
        [self.contentView addSubview:imageView];
        [self.processedSampleImages addObject:imageView];
    }
}

- (void)prepareSampleImage
{
    double coef = self.currentImage.size.width / self.contentView.frame.size.width;
    self.sampleImageSize = CGSizeMake((NSInteger)self.currentImage.size.width / coef,
                                      (NSInteger)self.currentImage.size.height / coef);
    self.sampleImage = [UIImage imageWithImage:self.currentImage scaledToSize:CGSizeMake(self.sampleImageSize.width, self.sampleImageSize.height)];
}

- (void)configureScrollView
{
    [self prepareSampleImage];
    double scrollViewOffset = 10;
    
    self.containerViewHeighConstraint.constant =  (10 + self.sampleImageSize.height) * FILTERS_COUNT + scrollViewOffset;
    self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width,
                                             (self.scrollView.frame.size.height / 2 + self.sampleImageSize.height / 2) * self.processedSampleImages.count);
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.contentView];
    UIView *view = [self.contentView hitTest:location withEvent:nil];
    
    if ([view isKindOfClass:[UIImageView class]])
    {
        [self.delegate changeStateOfRightMenu:FilteringMenu];
        [self.filterDelegate startLoadIndicating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            
            [self.processor getFilteredImage:self.currentImage WithFilter:(FilterName)view.tag Completion:^(NSDictionary *imageAndTag)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    [self.filterDelegate stopLoadIndicating];
                    [self.filterDelegate updateUIWithImage:[imageAndTag objectForKey:KEY_FOR_IMAGE]];
                });
            }];
        });
        
    }
}
- (IBAction)discardFiltering:(UIButton *)sender
{
    [self.delegate changeStateOfRightMenu:FilteringMenu];
    [self.filterDelegate updateUIWithImage:self.currentImage];
}

- (ImageFilterProcessor *)processor
{
    if (!_processor)
    {
        _processor = [ImageFilterProcessor sharedProcessor];
    }
    return _processor;
}

- (void)getSampleImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        for (int i = 0; i < FILTERS_COUNT; i++)
        {
            [self.processor getFilteredImage:self.sampleImage WithFilter:(FilterName)i Completion:^(NSDictionary *imageAndTag)
            {
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [self setImageIntoContentView:imageAndTag];
                                });
             }];
        }
    });
    
}

- (void)setImageIntoContentView:(NSDictionary *)imageAndTag
{
    for (UIImageView *view in self.contentView.subviews)
    {
        if (!view.image)
        {
            view.image = [imageAndTag objectForKey:KEY_FOR_IMAGE];
            view.tag = [[imageAndTag objectForKey:KEY_FOR_TAG] intValue];
            [UIActivityIndicatorView removeActivityIndicatorFromView:view];
            view.userInteractionEnabled = YES;
            break;
        }
    }
}

@end
