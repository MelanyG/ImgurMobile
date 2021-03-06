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
            
            return YES;

        }
    }
    
    return NO;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat delta = 1.f;
    if (self.socialVC.album)
    {
        
        imgurPost * post = [[self.socialVC.album posts] objectAtIndex:indexPath.row];
        UIImage * image = [self.images objectForKey:[[post.imageURL pathComponents] lastObject]];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        if ([[image description] hasPrefix:@"<_UIAnimatedImage"])
        {
            delta = 1.f;
            if (self.image.size.width > self.view.frame.size.width) {
                delta = self.image.size.width/self.view.frame.size.width;
            }
            return image.size.height/delta;
        }
        else{
            if (![[post.imageURL pathExtension] isEqualToString:@"gif"] ){
                if (![image isEqual:placeholderImage]) {
                    delta = 1.f;
                    if (self.image.size.width > self.view.frame.size.width) {
                        delta = self.image.size.width/self.view.frame.size.width;
                    }
                    return  image.size.height/delta;
                }
                return 100;
            }
            else
                return 100;
        }
    }

    else{
        delta = 1.f;
        if (self.socialVC.image.size.width > self.view.frame.size.width) {
            delta = self.socialVC.image.size.width/self.view.frame.size.width;
            
        }
        return self.socialVC.image.size.height/delta;
    }
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.socialVC.album) {
        NSString* imageURLToSend = [[self.socialVC.album.posts objectAtIndex:indexPath.row] imageURL];
        UIImage* imageToSend = [self.images objectForKey:[[imageURLToSend pathComponents] lastObject]];
        self.socialVC.imageToEdit = imageToSend;
        NSLog(@"%ld", (long)indexPath.row);
    }
}

@end
