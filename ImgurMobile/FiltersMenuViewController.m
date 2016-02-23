//
//  FiltersMenuViewController.m
//  ImgurMobile
//
//  Created by alex4eetah on 2/23/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "FiltersMenuViewController.h"

@interface FiltersMenuViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tag = 3333;
}
@end
