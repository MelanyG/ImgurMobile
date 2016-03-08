//
//  ImageTableViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 06.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "ImageTableViewController.h"
#import "ImageCustomTableViewCell.h"
#import "SocialViewController.h"
#import "imgurAlbum.h"
#import "imgurPost.h"
#import "UIImage+Animation.h"

@interface ImageTableViewController ()

@property (strong, nonatomic) UIImage* image;

@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) NSMutableArray* imagesToSend;

@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[ UINib nibWithNibName:NSStringFromClass([ImageCustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImageCustomTableViewCell class ])];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.images = [[NSMutableDictionary alloc] init];
    self.imagesToSend = [[NSMutableArray alloc] init];
    /*imgurPost *post = [self.socialVC.album.posts firstObject];
    
    [self.images setObject:self.socialVC.image forKey:[[post.imageURL pathComponents] lastObject]];*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.socialVC.album) {
        return [self.socialVC.album.posts count];
    }
    else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImageCustomTableViewCell class]) forIndexPath:indexPath];
   /* if (indexPath.row == 0)
    {
        cell.cellSocialImage.frame = CGRectMake(0, 0, self.socialVC.image.size.width, self.socialVC.image.size.height);
        [cell.cellSocialImage setImage:self.socialVC.image];
    }
    else*/
    if (self.socialVC.album)
    {
        imgurPost* post = [self.socialVC.album.posts objectAtIndex:indexPath.row];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        [cell.cellSocialImage setImage:placeholderImage];
        cell.cellSocialImage.frame = CGRectMake(0, 0, placeholderImage.size.width, placeholderImage.size.height);

        if (![self.images objectForKey:[[post.imageURL pathComponents] lastObject]])
        {
            [self.images setObject:[UIImage imageNamed:@"placeholder"] forKey:[[post.imageURL pathComponents] lastObject]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:post.imageURL]];
                UIImage * image;
                static int i = 0;
                i++;
                NSLog(@"%@%d%@", @"oh gawd!!!! fuck we finished lowading ", i, @" images !!!!11111111adinadin");
                if ([[post.imageURL pathExtension] isEqualToString:@"gif"] )
                {
                    image = [UIImage animatedImageWithAnimatedGIFData:imageData];
                }
                else
                {
                    image = [UIImage imageWithData: imageData];
                }
                
                self.image = image;
                if (image == nil) {
                    [self.images removeObjectForKey:[[post.imageURL pathComponents] lastObject]];
                }
                else{
                    [self.images setObject:image forKey:[[post.imageURL pathComponents] lastObject]];
                    [self.imagesToSend addObject:image];
                }
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   if ([self isRowIsVisible:indexPath.row])
                                   {
                                       cell.cellSocialImage.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
                                       [cell.cellSocialImage setImage:image];

                                   }
                                       [self.tableView reloadData];
                                       NSLog(@"%@", self.images);
                               });
                
            });
        }
        else
        {

            UIImage * image = [self.images objectForKey:[[post.imageURL pathComponents] lastObject]];
            cell.cellSocialImage.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            [cell.cellSocialImage setImage:image];
        }
    }
    else if (self.socialVC.post){
        cell.cellSocialImage.frame = CGRectMake(0, 0, self.socialVC.image.size.width, self.socialVC.image.size.height);
        [cell.cellSocialImage setImage:self.socialVC.image];
    }
    
    return cell;
}

-(BOOL)isRowIsVisible:(NSUInteger) row
{
    NSArray *indexes = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *index in indexes) {
        if (index.row == row) {
                        NSLog(@"YES");
            return YES;

        }
    }
                NSLog(@"LOH");
    return NO;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.socialVC.album)
    {
        imgurPost * post = [[self.socialVC.album posts] objectAtIndex:indexPath.row];
        UIImage * image = [self.images objectForKey:[[post.imageURL pathComponents] lastObject]];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        if ([[image description] hasPrefix:@"<_UIAnimatedImage"])
        {
            return image.size.height;
        }
        else{
            if (![[post.imageURL pathExtension] isEqualToString:@"gif"] ){
                if (![image isEqual:placeholderImage]) {
                    return  image.size.height;
                }
                return 100;
            }
            else
                return 100;
        }
    }

    else{
        return self.socialVC.image.size.height;
    }
    return 100;
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.socialVC.imageToEdit = [self.imagesToSend objectAtIndex:indexPath.row];
}

@end
