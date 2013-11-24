#import "HeartRateViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "UserInformationViewController.h"

#import "UILabel+HeartRate.h"
#import "UIImage+Factory.h"
#import "UIView+Utility.h"
#import "NSUserDefaults+HeartRate.h"

@interface HeartRateViewController ()
<
CBCentralManagerDelegate,
CBPeripheralDelegate
>

@property (nonatomic)   NSMutableArray      *heartRateMonitors;
@property (nonatomic)   UILabel             *heartRateLabel;
@property (nonatomic)   UILabel             *zoneLabel;
@property (nonatomic)   UILabel             *statusLabel;
@property (nonatomic)   CBCentralManager    *manager;
@property (nonatomic)   CBPeripheral        *peripheral;

#if !BLUETOOTH
@property (nonatomic)   NSTimer             *timer;
#endif

@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage named:@"settings"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSettings)];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor clearColor];
    
    //TODO: Change all strings to NSLocalizedString Macro
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.statusLabel applyDefaultStyleWithSize:32.f];
    self.statusLabel.text = @"Searching...";
    [self.view addSubview:self.statusLabel];
    
    self.heartRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 150)];
    [self.heartRateLabel applyDefaultStyleWithSize:144.f];
    self.heartRateLabel.text = @"...";
    [self.view addSubview:self.heartRateLabel];
    
    self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.heartRateLabel.bottom + 40, self.view.width, 40)];
    [self.zoneLabel applyDefaultStyleWithSize:34.f];
    [self.view addSubview:self.zoneLabel];
    
    self.heartRateMonitors = [NSMutableArray array];
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [self startScan];
}

#pragma mark - Selector Methods

- (void)showSettings {
    [self.navigationController pushViewController:[[UserInformationViewController alloc] init] animated:YES];
}

// Update UI with heart rate data received from device
- (void)updateWithHRMData:(NSData *)data
{
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {
        // uint8 bpm
        bpm = reportData[1];
    } else {
        // uint16 bpm
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }
    
    [self updateWithBPM:bpm];
}

- (void)updateWithBPM:(uint16_t)bpm {
    NSLog(@"bpm %d", bpm);
    self.heartRateLabel.text = [NSString stringWithFormat:@"%d", bpm];
    
    NSNumber *maxHeartRate = [NSUserDefaults getMaxHeartRate];
    
    if (maxHeartRate.unsignedShortValue < 220) {
        const uint16_t max_bpm = maxHeartRate.unsignedShortValue;
        
        //TODO: Move colors to category class
        if (bpm > max_bpm) {
            self.zoneLabel.text = @"Max";
            self.view.backgroundColor = [UIColor colorWithRed:(122/255.f) green:(43/255.f) blue:(53/255.f) alpha:1];
            self.zoneLabel.textColor = [UIColor whiteColor];
            self.heartRateLabel.textColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-20) {
            self.zoneLabel.text = @"Anaerobic";
            self.view.backgroundColor = [UIColor colorWithRed:(122/255.f) green:(43/255.f) blue:(53/255.f) alpha:1];
            self.zoneLabel.textColor = [UIColor whiteColor];
            self.heartRateLabel.textColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-40) {
            self.zoneLabel.text = @"Aerobic";
            self.view.backgroundColor = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
            self.zoneLabel.textColor = [UIColor whiteColor];
            self.heartRateLabel.textColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-60) {
            self.zoneLabel.text = @"Weight Control";
            self.view.backgroundColor = [UIColor colorWithRed:(98/255.f) green:(111/255.f) blue:(145/255.f) alpha:1];
            self.zoneLabel.textColor = [UIColor whiteColor];
            self.heartRateLabel.textColor = [UIColor whiteColor];
        } else if (bpm > max_bpm-80) {
            self.zoneLabel.text = @"Moderate";
            self.view.backgroundColor = [UIColor colorWithRed:(127/255.f) green:(164/255.f) blue:(116/255.f) alpha:1];
            self.zoneLabel.textColor = [UIColor whiteColor];
            self.heartRateLabel.textColor = [UIColor whiteColor];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            self.zoneLabel.text = @"Resting";
            self.view.backgroundColor = [UIColor whiteColor];
            self.zoneLabel.textColor = [UIColor blackColor];
            self.heartRateLabel.textColor = [UIColor blackColor];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    else {
        self.zoneLabel.text = @"";
        self.view.backgroundColor = [UIColor whiteColor];
        self.zoneLabel.textColor = [UIColor blackColor];
        self.heartRateLabel.textColor = [UIColor blackColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self showSettings];
        });
    }
    
    
    self.statusLabel.text = @"";
}

#pragma mark - Start/Stop Scan methods

// Use CBCentralManager to check whether the current platform/hardware supports Bluetooth LE.
- (BOOL)isLECapableHardware
{
    NSString * state = nil;
    switch ([self.manager state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    NSLog(@"Central manager state: %@", state);
    return FALSE;
}

// Request CBCentralManager to scan for heart rate peripherals using service UUID 0x180D
- (void)startScan
{
#if BLUETOOTH
    [self.manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]]
                                         options:nil];
#else
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(fakeHeartbeat)
                                                userInfo:nil
                                                 repeats:YES];
#endif
}

// Request CBCentralManager to stop scanning for heart rate peripherals
- (void)stopScan
{
#if BLUETOOTH
    [self.manager stopScan];
#else
    [self.timer invalidate];
    self.timer = nil;
#endif
}

#if !BLUETOOTH
- (void)fakeHeartbeat {
    static uint8_t bpm;
    
    if (bpm >= 50) {
        bpm = (bpm + 10) % 220;
    }
    else {
        bpm = 50;
    }
    
    [self updateWithBPM:bpm];
}
#endif

#pragma mark - CBCentralManager delegate methods

// Invoked when the central manager's state is updated.
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware];
}

// Invoked when the central discovers heart rate peripheral while scanning.
- (void) centralManager:(CBCentralManager *)central
  didDiscoverPeripheral:(CBPeripheral *)aPeripheral
      advertisementData:(NSDictionary *)advertisementData
                   RSSI:(NSNumber *)RSSI
{
    NSMutableArray *peripherals = [self mutableArrayValueForKey:@"heartRateMonitors"];
    if(![self.heartRateMonitors containsObject:aPeripheral])
        [peripherals addObject:aPeripheral];
    
    // Retrieve already known devices
    [self.manager retrievePeripherals:[NSArray arrayWithObject:(id)aPeripheral.UUID]];
}

// Invoked when the central manager retrieves the list of known peripherals.
// Automatically connect to first known peripheral
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripheral: %u - %@", [peripherals count], peripherals);
    [self stopScan];
    // If there are any known devices, automatically connect to it.
    if([peripherals count] >= 1) {
        self.peripheral = [peripherals objectAtIndex:0];
        [self.manager connectPeripheral:self.peripheral
                                options:[NSDictionary dictionaryWithObject:
                                         [NSNumber numberWithBool:YES]
                                                                    forKey:
                                         CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

// Invoked when a connection is succesfully created with the peripheral.
// Discover available services on the peripheral
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"connected");
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
}

// Invoked when an existing connection with the peripheral is torn down.
// Reset local variables
- (void) centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)aPeripheral
                  error:(NSError *)error
{
    if (self.peripheral) {
        [self.peripheral setDelegate:nil];
        self.peripheral = nil;
    }
}

// Invoked when the central manager fails to create a connection with the peripheral.
- (void) centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)aPeripheral
                  error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    if (self.peripheral) {
        [self.peripheral setDelegate:nil];
        self.peripheral = nil;
    }
}

#pragma mark - CBPeripheral delegate methods

// Invoked upon completion of a -[discoverServices:] request.
// Discover available characteristics on interested services
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services) {
        NSLog(@"Service found with UUID: %@", aService.UUID);
        
        /* Heart Rate Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180D"]]) {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        /* Device Information Service */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        /* GAP (Generic Access Profile) for Device Name */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"1800"]]) {
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }
}

// Invoked upon completion of a -[discoverCharacteristics:forService:] request.
// Perform appropriate operations on interested characteristics
- (void) peripheral:(CBPeripheral *)aPeripheral
didDiscoverCharacteristicsForService:(CBService *)service
              error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180D"]]) {
        for (CBCharacteristic *aChar in service.characteristics) {
            // Set notification on heart rate measurement
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]]) {
                [self.peripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found a Heart Rate Measurement Characteristic");
                self.statusLabel.text = @"Connecting...";
            }
            
            // Read body sensor location
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]]) {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Body Sensor Location Characteristic");
            }
            
            // Write heart rate control point
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A39"]]) {
                uint8_t val = 1;
                NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                [aPeripheral writeValue:valData forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
            }
        }
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"1800"]]) {
        for (CBCharacteristic *aChar in service.characteristics) {
            // Read device name
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A00"]]) {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Name Characteristic");
            }
        }
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        for (CBCharacteristic *aChar in service.characteristics) {
            // Read manufacturer name
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                [aPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Manufacturer Name Characteristic");
            }
        }
    }
}

// Invoked upon completion of a -[readValueForCharacteristic:] request
// or on the reception of a notification/indication.
- (void) peripheral:(CBPeripheral *)aPeripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]]) {
        if(characteristic.value || !error) {
            NSLog(@"received value: %@", characteristic.value);
            // Update UI with heart rate data
            [self updateWithHRMData:characteristic.value];
        }
    }
    // Value for body sensor location received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A38"]]) {
        NSData * updatedValue = characteristic.value;
        uint8_t* dataPointer = (uint8_t*)[updatedValue bytes];
        if (dataPointer) {
            uint8_t location = dataPointer[0];
            NSString*  locationString;
            switch (location) {
                case 0:
                    locationString = @"Other";
                    break;
                case 1:
                    locationString = @"Chest";
                    break;
                case 2:
                    locationString = @"Wrist";
                    break;
                case 3:
                    locationString = @"Finger";
                    break;
                case 4:
                    locationString = @"Hand";
                    break;
                case 5:
                    locationString = @"Ear Lobe";
                    break;
                case 6:
                    locationString = @"Foot";
                    break;
                default:
                    locationString = @"Reserved";
                    break;
            }
            NSLog(@"Body Sensor Location = %@ (%d)", locationString, location);
        }
    }
    // Value for device Name received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A00"]]) {
        NSString * deviceName = [[NSString alloc] initWithData:characteristic.value
                                                      encoding:NSUTF8StringEncoding];
        NSLog(@"Device Name = %@", deviceName);
    }
    // Value for manufacturer name received
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        NSString *manufacturer = [[NSString alloc] initWithData:characteristic.value
                                                       encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer Name = %@", manufacturer);
    }
}

@end
