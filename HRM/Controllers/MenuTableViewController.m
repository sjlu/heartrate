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

@end

@implementation MenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = @[@"Heart Rate", @"Profile"];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel applyDefaultStyleWithSize:26.f];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor heartRateRed];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case heartRateTag: {
//            self.sideMenuViewController.contentViewController = [[UserInformationViewController alloc] init];
            break;
        }
        case profileTag: {
//            self.sideMenuViewController.contentViewController = [[UserInformationViewController alloc] init];
            break;
        }
        default:
            break;
    }
}

@end
