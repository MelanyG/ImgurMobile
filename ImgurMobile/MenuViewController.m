//
//  ViewController.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 3/8/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (strong,nonatomic) NSArray * menuItems;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 3;
    
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.8];
    [self.view.layer setShadowRadius:3.0];
    [self.view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.menuItems = [NSArray arrayWithObjects:@"Message", @"Gallery", @"Login", @"Logout", nil ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectMenuItem:indexPath.row];
    self.MenuVCConstraint.constant = - 205;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
