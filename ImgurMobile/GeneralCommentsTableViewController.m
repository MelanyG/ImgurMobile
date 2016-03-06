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

@interface GeneralCommentsTableViewController ()

@end

@implementation GeneralCommentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[ UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommentTableViewCell class ])];
    [self.tableView reloadData];
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
    
    
   
    return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.5;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
