//
//  PageInfoViewController.m
//  ImgurMobile
//
//  Created by Roman Stasiv on 2/25/16.
//  Copyright © 2016 Melany. All rights reserved.
//

#import "PageInfoViewController.h"

@interface PageInfoViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *sortPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *windowPicker;

@property (strong, nonatomic) NSArray *sectionPickerData;
@property (strong, nonatomic) NSArray *sortPickerData;
@property (strong, nonatomic) NSArray *windowPickerData;
@end

@implementation PageInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionPicker.delegate = self;
    self.sortPicker.delegate = self;
    self.windowPicker.delegate = self;
    
    self.sectionPicker.dataSource = self;
    self.sortPicker.dataSource = self;
    self.windowPicker.dataSource = self;
    
    self.sectionPickerData = [NSArray arrayWithObjects:@"hot", @"top", @"user", nil];
    self.sortPickerData = [NSArray arrayWithObjects:@"viral", @"topest", @"latest", @"rising", nil];
    self.windowPickerData = [NSArray arrayWithObjects:@"day", @"week", @"month", @"year", @"all", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 101) return 3;
    if (pickerView.tag == 102) return 4;
    if (pickerView.tag == 103) return 5;
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 101) return [self.sectionPickerData objectAtIndex:row];
    if (pickerView.tag == 102) return [self.sortPickerData objectAtIndex:row];
    if (pickerView.tag == 103) return [self.windowPickerData objectAtIndex:row];
    return @";(";
}

#pragma mark- UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:[NSNumber numberWithInteger:[self.sectionPicker selectedRowInComponent:0]] forKey:@"section"];
    [info setObject:[NSNumber numberWithInteger:[self.sortPicker selectedRowInComponent:0]] forKey:@"sort"];
    [info setObject:[NSNumber numberWithInteger:[self.windowPicker selectedRowInComponent:0]] forKey:@"window"];
    [self.delegate pageInfoDidChange:info];
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
