//
//  BeaconViewController.m
//  Navio-beacon
//
//  Created by Danny Holmes on 9/21/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import "BeaconViewController.h"

@interface BeaconViewController ()

- (IBAction)pressedUUID:(id)sender;
- (IBAction)beaconSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *beaconSwitch;

@end

@implementation BeaconViewController {
    
    CBPeripheralManager *_peripheralManager;
    
    BOOL _enabled;
    NSUUID *_uuid;
    int _major;
    int _minor;
    int _power;
    NSString *idString;
    
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark Core Data Methods and other important things

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////// These are the methods for dealing with Core Data //////////////
////////   Call them each time you need them locally      //////////////
////////      ie. context changes won't save until        //////////////
////////           you call the save method               //////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

////////////////////////////////////
// Handles getting the Managed Object Context
//////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

////////////////////////////////////
// Handles saving the context each time changes are made
////////////////////////////////////

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

////////////////////////////////////
// Handles checking if the storage is empty or not
////////////////////////////////////

- (BOOL)coreDataHasEntriesForEntityName:(NSString *)UUID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:UUID inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        return NO;
        NSLog(@"NO");
    } else {
        return YES;
        NSLog(@"YES");
    }
}

////////////////////////////////////
// Other methods to set up
////////////////////////////////////

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

#pragma mark View Loaded

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _uuid = [[NSUUID alloc] initWithUUIDString:@"E36397B6-C4FC-4D90-A044-6A35606F8D0D"];
    
    //_power = 50;
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    _enabled = NO;
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    ////////////////////////////////////
    //Fetch UUID if it already exists in persistent store.
    ////////////////////////////////////
    
    if ([self coreDataHasEntriesForEntityName:@"UUID"] == YES) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UUID"];
        request.propertiesToFetch = @[@"uuid_string"];
        request.resultType = NSDictionaryResultType;
        NSArray *array = [context executeFetchRequest:request error:nil];
        NSString *UUID = [[array valueForKey:@"uuid_string"] componentsJoinedByString:@","];
        
        idString = [NSString stringWithString:UUID];

        _uuidLabel.text = [NSString stringWithFormat:@"%@",idString];
        
        NSLog(@"Fetched %@",idString);
        
    } else {
        
        ////////////////////////////////////
        //Generate a new UUID and save it to persistent store with Core Data
        ////////////////////////////////////
        
        idString = [[NSUUID UUID] UUIDString];                // Generate a random UUID
        //_uuid = [[NSUUID alloc] initWithUUIDString:UUID];           // Store the generated UUID
        _uuidLabel.text = idString;
        
        NSManagedObject *newUUID = [NSEntityDescription insertNewObjectForEntityForName:@"UUID" inManagedObjectContext:context];
        [newUUID setValue:idString forKey:@"uuid_string"];
        
        [self saveContext];                                          // Save the object to persistent store

        NSLog(@"Generated %@",idString);
        
    }
    
    ////////////////////////////////////
    //Check if peripheral manager is active set up initial state.
    ////////////////////////////////////
    
    if (_peripheralManager.isAdvertising == YES) {
        
        [self.beaconSwitch setOn:YES animated:NO];
        self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Beacon ON"];
        _enabled = YES;
        
    } else {
    
        _enabled = NO;
        self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Beacon OFF"];

    }
    
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////

#pragma mark UI Interactions

- (IBAction)beaconSwitch:(id)sender {
    
    //////////////////////////////////////////////////
    // If the beacon was off, we turn it on, (error if Bluetooth is off on the device itself)
    // create a region. In the Apple example, they "calibrated a device" to get the RSSI
    // power. We should be able to hard code the region's range by measuring the power vs distance.
    // In this case, the "_power" value is declared as soon as the viewDidLoad method is called.
    //////////////////////////////////////////////////
    
    if (_enabled == NO) {
        
        if (_uuid) {
            
            _enabled = YES;
            self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Beacon ON"];
            
            if(_peripheralManager.state < CBPeripheralManagerStatePoweredOn)
            {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
                
                return;
            }
            
            if (_enabled == YES)
            {
                //////////////////////////////////////////////////
                // We must construct a CLBeaconRegion that represents the payload we want the device to advertise.
                // We probably don't need all these cases when we hard code major and minor into beacons...
                //////////////////////////////////////////////////
                
                NSDictionary *peripheralData = nil;
                if(_uuid && _major && _minor)
                {
                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:_major minor:_minor identifier:idString];
                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
                }
                else if(_uuid && _major)
                {
                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:_major  identifier:idString];
                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
                }
                else if(_uuid)
                {
                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:idString];
                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
                }
                
                //////////////////////////////////////////////////
                // Now we advertise.
                //////////////////////////////////////////////////
                
                if(peripheralData)
                {
                    [_peripheralManager startAdvertising:peripheralData];
                    
                    NSLog(@"Advertising");
                    
                }
            }
            
        } else {
            
            [self.beaconSwitch setOn:NO animated:YES];
            self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Please Generate a new UUID"];
            [_peripheralManager stopAdvertising];
            
        }
    
    } else {
        
        _enabled = NO;
        self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Beacon OFF"];
        [_peripheralManager stopAdvertising];
        
        NSLog(@"Stopped Advertising");
        
    }
    
}


//////////////////////////////////////////////////
// Button to start email with UUID
//////////////////////////////////////////////////

- (IBAction)actionEmailComposer {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Beacon UUID"];
        NSString *emailBody = [NSString stringWithFormat:@"%@",_uuidLabel.text];
        [mailViewController setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:  (NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////

#pragma mark Other Methods

////////////////////////////////////////////////////////////////////////
/////////////      INCLUDED FOR TESTING PURPOSES.
/////////////  This will allow a tester to generate a new UUID and store it in place of the old one.
////////////////////////////////////////////////////////////////////////

- (IBAction)pressedUUID:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    ////////////////////////////////////
    // This makes sure everything is off before generating a new UUID
    ////////////////////////////////////
    
    [self.beaconSwitch setOn:NO animated:YES];
    self.beaconSwitchLabel.text = [NSString stringWithFormat:@"Beacon OFF"];
    [_peripheralManager stopAdvertising];
    
    ////////////////////////////////////
    // Fetch and delete the existing UUID
    ////////////////////////////////////
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UUID"];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (NSManagedObject *UUID in array) {
        [context deleteObject:UUID];
    }
    [self saveContext];
    
    NSLog(@"Old UUID Deleted");
    
    ////////////////////////////////////
    // Generate a new UUID and save it to persistent store
    ////////////////////////////////////
    
    NSString *UUID = [[NSUUID UUID] UUIDString];                // Generate a random UUID
    _uuid = [[NSUUID alloc] initWithUUIDString:UUID];           // Store the generated UUID
    _uuidLabel.text = [NSString stringWithFormat:@"%@",UUID];
    
    NSManagedObject *newUUID = [NSEntityDescription insertNewObjectForEntityForName:@"UUID" inManagedObjectContext:context];
    [newUUID setValue:UUID forKey:@"uuid_string"];
    
    [self saveContext];                                          // Save the object to persistent store
    
    NSLog(@"Generated %@",UUID);
    
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
