//
//  BeaconViewController.m
//  Navio-beacon
//
//  Created by Danny Holmes on 9/21/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import "BeaconViewController.h"

@interface BeaconViewController ()

- (IBAction)beaconSwitch:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *beaconSwitch;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;


@end

@implementation BeaconViewController {
    
    CBPeripheralManager *_peripheralManager;
    
    BOOL _enabled;
    NSUUID *_uuid;
    int _major;
    int _minor;
    int _power;
    
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
    NSLog(@"saved %@", managedObjectContext);
}

////////////////////////////////////
// Handles checking if the storage is empty or not
////////////////////////////////////

- (BOOL)coreDataHasEntriesForEntityName:(NSString *)DATA {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:DATA inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:2];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] < 2) {
        
        NSLog(@"No DATA");
        return NO;

    } else {
        
        NSLog(@"%@ %@",[results objectAtIndex:0],[results objectAtIndex:1]);
        return YES;
        
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
    //Fetch properties if they already exists in persistent store.
    ////////////////////////////////////
    
    if ([self coreDataHasEntriesForEntityName:@"DATA"] == YES) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DATA"];
        request.propertiesToFetch = @[@"major",@"minor"];
        request.resultType = NSDictionaryResultType;
        NSArray *array = [context executeFetchRequest:request error:nil];
        NSString *major = [array valueForKey:@"major"];
        NSString *minor = [array valueForKey:@"minor"];
    
        NSLog(@"major %@ minor %@",major,minor);

    
        //idString = [NSString stringWithString:UUID];

        //_uuidLabel.text = [NSString stringWithFormat:@"%@",idString];
        
        //NSLog(@"Fetched %@",idString);
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Identifiers Needed"
                                                        message:@"You must select a Major and Minor identifier."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
        
        ////////////////////////////////////
        //Generate a new UUID and save it to persistent store with Core Data
        ////////////////////////////////////
        
//        idString = [[NSUUID UUID] UUIDString];                // Generate a random UUID
//        //_uuid = [[NSUUID alloc] initWithUUIDString:UUID];           // Store the generated UUID
//        _uuidLabel.text = idString;
//        
//        NSManagedObject *newUUID = [NSEntityDescription insertNewObjectForEntityForName:@"UUID" inManagedObjectContext:context];
//        [newUUID setValue:idString forKey:@"uuid_string"];
//        
//        [self saveContext];                                          // Save the object to persistent store
//
//        NSLog(@"Generated %@",idString);
    
    //}
    
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
                
                NSString *identifier = [NSString stringWithFormat:@"edu.LSU.MAG"];
                
                NSDictionary *peripheralData = nil;
                if(_uuid && _major && _minor)
                {
                    
                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:_major minor:_minor identifier:identifier];
                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
                    
                } else {
                    
                    nil;
                    //Make pop up and require major and minor
                    
                }
                
                
//                else if(_uuid && _major)
//                {
//                    
//                    
//                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid major:_major  identifier:identifier];
//                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
//                }
//                else if(_uuid)
//                {
//
//                    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:identifier];
//                    peripheralData = [region peripheralDataWithMeasuredPower:nil];
//                }
                
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (textField == self.majorTextField) {
 
        [self deleteMajor];
        

        
        
        int thisMajor = [self.majorTextField.text intValue];
        
        _major = thisMajor;
        
        NSNumber *majorNumber = [NSNumber numberWithInt:_major];
        
        NSManagedObject *major = [NSEntityDescription insertNewObjectForEntityForName:@"DATA" inManagedObjectContext:context];
        [major setValue:majorNumber forKey:@"major"];
        
        [self saveContext];                                          // Save the object to persistent store
        
        
        
        NSLog(@"Major %@",self.majorTextField.text);
        
        
        [self.majorTextField resignFirstResponder];
        return YES;
        
    } else {
      
        [self deleteMinor];
        
        
        int thisMinor = [self.minorTextField.text intValue];
        
        _minor = thisMinor;
        
        NSNumber *minorNumber = [NSNumber numberWithInt:_minor];
        
        
        NSManagedObject *minor = [NSEntityDescription insertNewObjectForEntityForName:@"DATA" inManagedObjectContext:context];
        [minor setValue:minorNumber forKey:@"minor"];
        
        [self saveContext];
        
        
        NSLog(@"Minor %@",self.minorTextField.text);
        
        [self.minorTextField resignFirstResponder];
        return YES;
        
    }
    
}

-(void)deleteMajor {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DATA"];
    
    
    request.propertiesToFetch = @[@"major",@"minor"];
    request.resultType = NSDictionaryResultType;
    NSArray *array = [context executeFetchRequest:request error:nil];
    
   // NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (NSManagedObject *major in array) {
        [context deleteObject:major];
    }
    [self saveContext];
    
    NSLog(@"major deleted");
}

-(void)deleteMinor {
    
    //make a change
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DATA"];
    
    request.propertiesToFetch = @[@"major",@"minor"];
    request.resultType = NSDictionaryResultType;
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    
    for (NSManagedObject *minor in array) {
        [context deleteObject:minor];
    }
    [self saveContext];
    
    NSLog(@"minor deleted");
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
}



//////////////////////////////////////////////////
// Button to start email with UUID
//////////////////////////////////////////////////

//- (IBAction)actionEmailComposer {
//    
//    if ([MFMailComposeViewController canSendMail]) {
//        
//        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
//        mailViewController.mailComposeDelegate = self;
//        [mailViewController setSubject:@"Beacon UUID"];
//        NSString *emailBody = [NSString stringWithFormat:@"%@",_uuidLabel.text];
//        [mailViewController setMessageBody:emailBody isHTML:NO];
//        
//        [self presentViewController:mailViewController animated:YES completion:nil];
//    }
//    
//    else {
//        
//        NSLog(@"Device is unable to send email in its current state.");
//        
//    }
//    
//}
//
//
//-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:  (NSError*)error
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

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
    //_uuidLabel.text = [NSString stringWithFormat:@"%@",UUID];
    
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
