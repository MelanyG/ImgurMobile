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

@interface ImageTableViewController ()

@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[ UINib nibWithNibName:NSStringFromClass([ImageCustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImageCustomTableViewCell class ])];
    [self.tableView reloadData];
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
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImageCustomTableViewCell class]) forIndexPath:indexPath];
    
    cell.cellSocialImage.frame = CGRectMake(0, 0, self.socialVC.image.size.width, self.socialVC.image.size.height);
    [cell.cellSocialImage setImage:self.socialVC.image];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.socialVC.image.size.height;
}

@end
