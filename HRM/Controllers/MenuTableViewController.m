//
//  MenuTableViewController.m
//  heartrate
//
//  Created by Jonathan Grana on 11/25/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "MenuTableViewController.h"

#import "UIColor+HeartRate.h"
#import "UILabel+HeartRate.h"
#import "UserInformationViewController.h"
#import "IIViewDeckController.h"
#import "UINavigationController+Factory.h"
#import "HeartRateViewController.h"
#import "UIImage+Factory.h"
#import "MenuItemCell.h"

typedef NS_ENUM(NSInteger, menuTags) {
    heartRateTag,
    profileTag,
//    historyTag
};

@interface MenuTableViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (strong, readwrite, nonatomic)    UITableView     *tableView;
@property (nonatomic)                       NSArray         *items;
@property (nonatomic)                       NSArray         *images;

@end

@implementation MenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = @[@"Heart Rate", @"Profile"];
    self.images = @[@"heart_monitor", @"user"];
    
    self.view.backgroundColor = [UIColor heartRateDarkRed];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 91, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel applyDefaultStyleWithSize:26.f];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor heartRateRed];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:cell.frame.size]];
    
    cell.textLabel.text = self.items[indexPath.row];
    UIImage *image = [[UIImage named:self.images[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewDeckController toggleLeftViewAnimated:YES];
    switch (indexPath.row) {
        case heartRateTag: {
            self.viewDeckController.centerController =
            [UINavigationController navigationControllerWithController:[[HeartRateViewController alloc] init]];
//            self.sideMenuViewController.contentViewController = [[UserInformationViewController alloc] init];
            break;
        }
        case profileTag: {
            self.viewDeckController.centerController =
            [UINavigationController navigationControllerWithController:[[UserInformationViewController alloc] init]];
//            self.sideMenuViewController.contentViewController = [[UserInformationViewController alloc] init];
            break;
        }
        default:
            break;
    }
}

@end
