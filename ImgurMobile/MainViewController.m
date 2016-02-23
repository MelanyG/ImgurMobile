//
//  MainViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 19.02.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "MainViewController.h"
#import "imgurServerManager.h"
#import "imgurJSONParser.h"
#import "NotChalengingQueue.h"
#import "imgurCell.h"
#import "UIImageView+AFNetworking.h"
#import "imgurPost.h"

@interface MainViewController ()

@property (strong, nonatomic) NSMutableDictionary *photosData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [self.collectionView registerClass:[imgurCell class] forCellWithReuseIdentifier:@"imgurCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NotChalengingQueue *queue = [[NotChalengingQueue alloc] init];
    imgurServerManager *manager = [[imgurServerManager alloc] init];
    [manager getPhotosForPage:0 Section:hot Sort:viral Window:all Completion:^(NSDictionary *resp)
     {
         [queue addObject:resp];
         
         self.photosData = [queue getObject];
         NSLog(@"%@", self.photosData);
     }];
    [self.collectionView reloadData];
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareData
{
    self.photos = [NSMutableArray array];
    NSArray *posts = [self.photosData objectForKey:@"posts"];
    for (imgurPost *post in posts)
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.imageURL]]];
        [self.photos addObject:image];
    }
}


#pragma mark- UICollectionViewDataSource


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imgurCell *tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgurCell" forIndexPath:indexPath];
    
    imgurPost * post = [[self.photosData objectForKey:@"posts"] objectAtIndex:indexPath.row];
    
    [tempCell.imageView setImageWithURL:post.imageURL]; //:[self.photos objectAtIndex:indexPath.row]];
    return tempCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.photosData objectForKey:@"posts"] count];
}

#pragma mark- UICollectionViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
