//
//  UsersImagesTableViewController.h
//  ImgurMobile
//
//  Created by Melany on 3/5/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellTableViewCell.h"



@interface UsersImagesTableViewController : UITableViewController

@property (strong, nonatomic) NSArray* imagesList;
@property (strong, nonatomic) NSDictionary* allImagesInDictionary;

- (IBAction)backToPreviousPage:(id)sender;


@end
