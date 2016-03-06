//
//  CustomCellTableViewCell.h
//  ImgurMobile
//
//  Created by Melany on 3/5/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customTitle;
@property (weak, nonatomic) IBOutlet UILabel *customDescription;
@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *customAlbumName;



@end
