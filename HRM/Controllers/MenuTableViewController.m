//
//  MenuTableViewController.m
//  heartrate
//
//  Created by Jonathan Grana on 11/25/13.
//  Copyright (c) 2013 Dev Marvel LLC. All rights reserved.
//

#import "MenuTableViewController.h"

#import "BluetoothManager.h"
#import "HRMNavigationController.h"
#import "HeartRateViewController.h"
#import "IIViewDeckController.h"
#import "MenuItemCell.h"
#import "UIColor+HeartRate.h"
#import "UIImage+Factory.h"
#import "UILabel+HeartRate.h"
#import "UINavigationController+Factory.h"
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
@property (nonatomic)                       NSArray         *images;
@property (nonatomic, readwrite)            HRMNavigationController         *navHeartRate;
@property (nonatomic)                       UILabel         *deviceName;
@property (nonatomic)                       UILabel         *deviceBattery;

@end

@implementation MenuTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kBluetoothNotificationBattery
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = @[@"Heart Rate", @"Profile"];
    self.images = @[@"heart_monitor", @"user"];
    
    self.view.backgroundColor = [UIColor heartRateDarkRed];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 91, self.view.frame.size.width, 54 * 2) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
    
    self.deviceName = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 44)];
    [self.deviceName applyDefaultStyleWithSize:20.f];
    self.deviceName.numberOfLines = 0;
    self.deviceName.textAlignment = NSTextAlignmentLeft;
    self.deviceName.textColor = [UIColor whiteColor];
    [self.view addSubview:self.deviceName];
    
    self.deviceBattery = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 200, 24)];
    [self.deviceBattery applyDefaultStyleWithSize:20.f];
    self.deviceBattery.textAlignment = NSTextAlignmentLeft;
    self.deviceBattery.textColor = [UIColor whiteColor];
    [self.view addSubview:self.deviceBattery];
    
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBattery:)
                                                 name:kBluetoothNotificationBattery
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([BluetoothManager shared].deviceName) {
        self.deviceName.text = [BluetoothManager shared].deviceName;
    }
    else if ([BluetoothManager shared].manufactorName) {
        self.deviceName.text = [BluetoothManager shared].manufactorName;
    }
}

#pragma mark - Selectors

- (void)updateBattery:(NSNotification *)notification {
    NSNumber *percentage = notification.object;
    
    self.deviceBattery.text = [NSString stringWithFormat:@"%@%% Battery",percentage];
}

#pragma mark - Properties

- (HRMNavigationController *)navHeartRate {
    if (!_navHeartRate) {
        _navHeartRate = [HRMNavigationController navigationControllerWithController:[[HeartRateViewController alloc] init]];
    }
    return _navHeartRate;
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
            self.viewDeckController.centerController = _navHeartRate;
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
