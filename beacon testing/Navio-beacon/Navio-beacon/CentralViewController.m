//
//  CentralViewController.m
//  Navio-beacon
//
//  Created by Danny Holmes on 9/30/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import "CentralViewController.h"

@interface CentralViewController ()

@end

@implementation CentralViewController
{
    //NSMutableDictionary *_beacons;
    NSMutableDictionary *_beacons;
    NSArray *_theBeacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSUUID *_UUID;
    NSArray *_uuidArray;
    NSArray *_descriptorArray;
    int beaconCount;
    int beaconCount2;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    
    [_beacons removeAllObjects];
    
    //NSLog(@"%@",beacons);
    //beaconCount = 0;
    
    NSEnumerator *enumerator = [beacons objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {
        NSLog( @"......%@",anObject);
        
        beaconCount2 += 1;
        NSLog(@"beaconCount %d",beaconCount2);
        
        NSNumber *stupidNumber = [[NSNumber alloc] initWithInt:beaconCount2];
        
        NSLog(@"stupidNumber %@",stupidNumber);
        
        [_beacons setObject:anObject forKey:stupidNumber];
        
        NSLog(@"%d",_beacons.count);
        
    }
    
    NSLog(@"done");
    beaconCount2 = 0;
    
    
}



 
//    _beaconCount = beacons.count;
//    
//    
//    NSLog(@"%d",beacons.count);
//    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
//    
//    //NSLog(@"%@",unknownBeacons);
//    
//    if([unknownBeacons count])
//        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
//    
//    //NSLog(@"%@",_beacons);
//    
//    
//    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
//    
//    //NSLog(@"%@",immediateBeacons);
//    
//    if([immediateBeacons count])
//        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
//    
//    // NSLog(@"%@",_beacons);
//    
//    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
//    
//   // NSLog(@"%@",nearBeacons);
//    
//    if([nearBeacons count])
//        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
//    
//    // NSLog(@"%@",_beacons);
//    
//    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
//    
//   // NSLog(@"%@",farBeacons);
//    
//    if([farBeacons count])
//        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
//    
//    //NSLog(@"%@",_beacons);
//    
//    
//    if (_beacons.count > 0) {
//    NSLog(@"1st count %d",_beacons.count);
//        [self.collectionView reloadData];
//    } else {
//        NSLog(@"no beacons");
//    }
    
    //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
//}

- (void)viewDidAppear:(BOOL)animated
{
    // Start ranging when the view appears.
    
    NSEnumerator *enumerator = [_uuidArray objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {

        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:anObject identifier:[anObject UUIDString]];
        NSLog(@"%@",region);
        [_locationManager startRangingBeaconsInRegion:region];
        NSLog(@"ranging");
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    // Stop ranging when the view goes away.
    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager stopRangingBeaconsInRegion:region];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Ranging";
    
    
    _beacons = [[NSMutableDictionary alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    //////////
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E36397B6-C4FC-4D90-A044-6A35606F8D0D"];
    
   // NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:@"0BDE845E-8721-4196-82E2-E75C45EBA6F1"];
    //NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:@"E39E0EA0-897A-47F8-80A3-6C1BB2B174CB"];
   // NSUUID *uuid3 = [[NSUUID alloc] initWithUUIDString:@"76272CBC-A53C-4EA8-9F0B-99B6CD622E24"];
    //NSUUID *uuid4 = [[NSUUID alloc] initWithUUIDString:@"90B962D6-3619-4D1A-AE41-784DEDA9CBAF"];
    
    NSString *desc1 = [[NSString alloc] initWithFormat:@"iPad1"];
    NSString *desc2 = [[NSString alloc] initWithFormat:@"Location"];
   // NSString *desc3 = [[NSString alloc] initWithFormat:@"Room 200"];
    
    _uuidArray = [[NSArray alloc] initWithObjects:uuid, nil];
    NSLog(@"%@", _uuidArray);
    _descriptorArray = [[NSArray alloc] initWithObjects:desc1, desc2, nil];
    NSLog(@"%@", _descriptorArray);
    
    //////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    
    
    // Populate the regions we will range once.

    NSEnumerator *enumerator = [_uuidArray objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {

        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:anObject identifier:[anObject UUIDString]];
        NSLog(@"%@", region);
        [_rangedRegions addObject:region];
        NSLog(@"added");
        
        
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger theInt = (int)1;
    
    //NSInteger myInt = (NSUInteger)_beacons.count;
    //NSLog(@"2nd count %d", myInt);
    return theInt;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    
//    NSArray *sectionValues = [_beacons allValues];
//    NSLog(@"%@",sectionValues);
//    return [[sectionValues objectAtIndex:section] count];
    
    return beaconCount;

}

//- (NSString *)collectionView:(UICollectionView *)collectionView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = nil;
//    NSArray *sectionKeys = [_beacons allKeys];
//    
//    // The collection view will display beacons by proximity.
//    NSNumber *sectionKey = [sectionKeys objectAtIndex:section];
//    switch([sectionKey integerValue])
//    {
//        case CLProximityImmediate:
//            title = @"Immediate";
//            break;
//            
//        case CLProximityNear:
//            title = @"Near";
//            break;
//            
//        case CLProximityFar:
//            title = @"Far";
//            break;
//            
//        default:
//            title = @"Unknown";
//            break;
//    }
//    
//    return title;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *rangeLabel = (UILabel *)[cell viewWithTag:100];
    //UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *uuidLabel = (UILabel *)[cell viewWithTag:300];
    
    
    // Display the UUID, major, minor and accuracy for each beacon.
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
    
    rangeLabel.text = [NSString stringWithFormat:@"M:%@, m:%@, db:%.2ld", beacon.major, beacon.minor, (long)beacon.rssi];
    //descriptionLabel.text = [NSString stringWithFormat:[_descriptorArray objectAtIndex:indexPath.row]];
    uuidLabel.text = [beacon.proximityUUID UUIDString];
   
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2lddb", beacon.major, beacon.minor, (long)beacon.rssi];

    return cell;
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
