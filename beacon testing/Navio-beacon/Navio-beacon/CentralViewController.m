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
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSUUID *_UUID;
    NSArray *_uuidArray;
    NSArray *_descriptorArray;
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
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    
    NSLog(@"%@",unknownBeacons);
    
    if([unknownBeacons count])
        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSLog(@"%@",_beacons);
    
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    
    NSLog(@"%@",immediateBeacons);
    
    if([immediateBeacons count])
        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
     NSLog(@"%@",_beacons);
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    
    NSLog(@"%@",nearBeacons);
    
    if([nearBeacons count])
        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
     NSLog(@"%@",_beacons);
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    
    NSLog(@"%@",farBeacons);
    
    if([farBeacons count])
        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    
     NSLog(@"%@",_beacons);
    
    [self.collectionView reloadData];
    //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
}

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
    
    NSUUID *uuid1 = [[NSUUID alloc] initWithUUIDString:@"0BDE845E-8721-4196-82E2-E75C45EBA6F1"];
    NSUUID *uuid2 = [[NSUUID alloc] initWithUUIDString:@"6DA526F4-E01E-4C96-B5FC-676C1EF70821"];
    NSUUID *uuid3 = [[NSUUID alloc] initWithUUIDString:@"90B962D6-3619-4D1A-AE41-784DEDA9CBAF"];
    
    NSString *desc1 = [[NSString alloc] initWithFormat:@"iPad1"];
    NSString *desc2 = [[NSString alloc] initWithFormat:@"Location"];
    NSString *desc3 = [[NSString alloc] initWithFormat:@"Room 200"];
    
    _uuidArray = [[NSArray alloc] initWithObjects:uuid1, uuid2, uuid3, nil];
    NSLog(@"%@", _uuidArray);
    _descriptorArray = [[NSArray alloc] initWithObjects:desc1, desc2, desc3, nil];
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
    NSLog(@"this is the beacon count: %lu", (unsigned long)_beacons.count);
    return _beacons.count;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *sectionValues = [_beacons allValues];
    return [[sectionValues objectAtIndex:section] count];

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
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *uuidLabel = (UILabel *)[cell viewWithTag:300];
    
    
    // Display the UUID, major, minor and accuracy for each beacon.
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
    
    rangeLabel.text = [NSString stringWithFormat:@"M:%@, m:%@, db:%.2ld", beacon.major, beacon.minor, (long)beacon.rssi];
    descriptionLabel.text = [NSString stringWithFormat:[_descriptorArray objectAtIndex:indexPath.row]];
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
