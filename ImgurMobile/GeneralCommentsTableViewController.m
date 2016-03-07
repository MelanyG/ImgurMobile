//
//  GeneralCommentsTableViewController.m
//  ImgurMobile
//
//  Created by Vitaliy Yarkun on 05.03.16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "GeneralCommentsTableViewController.h"
#import "CommentTableViewCell.h"
#import "SocialViewController.h"
#import "Comment.h"
#import "AddCommentViewController.h"

@interface GeneralCommentsTableViewController ()

@property (assign, nonatomic) NSInteger commentsIndex;
@property (strong, nonatomic) AddCommentViewController* addCommentVC;

@end

@implementation GeneralCommentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[ UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommentTableViewCell class ])];
    [self.tableView reloadData];
    

}

- (IBAction)doneAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addCommentSegue"])
    {
        self.addCommentVC = (AddCommentViewController*)segue.destinationViewController;
        self.addCommentVC.socialVC = self.socialVC;
    }
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.socialVC.commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*static NSString* identifier = @"Cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }*/
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentTableViewCell class]) forIndexPath:indexPath];
    
    Comment* comment = [self.socialVC.commentsArray objectAtIndex:indexPath.row];
    
    cell.autherComment.text = comment.comment;
    cell.autherName.text = comment.authorName;
    
    /*dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.socialVC getAutherAvatarIDWithID:comment.authorAvatarID]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.autherAvatar = (UIImageView*)[UIImage imageWithData: data];
            [tableView reloadData];
        });
    });*/
    
    cell.likeOutlet.tag = indexPath.row;
    cell.dislikeOutlet.tag = indexPath.row * 100;
    
    [cell.likeOutlet addTarget:self action:@selector(likeCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dislikeOutlet addTarget:self action:@selector(dislikeCommentAction:) forControlEvents:UIControlEventTouchUpInside];

   
    return cell;
    
}

- (void)likeCommentAction:(UIButton*) sender
{
    self.commentsIndex = sender.tag;
    Comment* comment = [self.socialVC.commentsArray objectAtIndex:self.commentsIndex];
    [self.socialVC likeCommentRequestByID:comment.commentID];

}

- (void)dislikeCommentAction:(UIButton*) sender
{
    self.commentsIndex = sender.tag;
    Comment* comment = [self.socialVC.commentsArray objectAtIndex:self.commentsIndex];
    [self.socialVC dislikeCommentRequestByID:comment.commentID];

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.5;
}


@end
