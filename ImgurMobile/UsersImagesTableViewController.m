//
//  UsersImagesTableViewController.m
//  ImgurMobile
//
//  Created by Melany on 3/5/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "UsersImagesTableViewController.h"
#import "ImgurPosting.h"
#import "UserImage.h"


@interface UsersImagesTableViewController ()

@property (strong, nonatomic) UserImage* currentImage;
@property (strong, nonatomic) NSString* documentsDirectoryPath;

@end

@implementation UsersImagesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.imagesList count];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CustomCellTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ( indexPath.row % 2 == 0 )
        customCell.backgroundColor = [UIColor grayColor];
    else
        customCell.backgroundColor = [UIColor darkGrayColor];
    
    self.currentImage = self.imagesList[indexPath.row];
    NSString* title = self.currentImage.title;
    NSString* description = self.currentImage.descriptionImage;
    NSString* imageName = self.currentImage.link;
    //UIImage * imageFromURL = [self getImageFromURL:imageName];
    NSString* albumName = self.currentImage.albumName;
    //UIImage * imageFromWeb = [self loadImage:imageName ofType:@"jpg" inDirectory:self.documentsDirectoryPath];
    
    
   // UIImage* image = [UIImage imageNamed:imageName];
    customCell.customTitle.text = title;
    customCell.customDescription.text = description;
  customCell.customImage.image = [self.allImagesInDictionary objectForKey:imageName];
    customCell.customAlbumName.text = albumName;
   // [customCell.customImage.image setObject:image forKey:[imageName absoluteString]];
    return customCell;
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
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

- (IBAction)backToPreviousPage:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}
@end
