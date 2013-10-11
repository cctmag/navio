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

    if([unknownBeacons count])
        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];

    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];

    if([immediateBeacons count])
        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];

    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];

    if([nearBeacons count])
        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];

    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];

    if([farBeacons count])
        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];

    //NSLog(@"%d",beacons.count);
    [self.collectionView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    // Start ranging when the view appears.
    
    NSLog(@"2......   %@",_rangedRegions);
    
    NSEnumerator *enumerator = [_rangedRegions objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {
        [_locationManager startRangingBeaconsInRegion:anObject];
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
    _rangedRegions = [[NSMutableArray alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    //////////
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E36397B6-C4FC-4D90-A044-6A35606F8D0D"];
    
    _uuidArray = [[NSArray alloc] initWithObjects:uuid, nil];
    NSLog(@"uuidArray %@", _uuidArray);

    //////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    
    
    // Populate the regions we will range once.

    NSEnumerator *enumerator = [_uuidArray objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {

        NSUUID *uuid = (NSUUID *)anObject;

        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        NSLog(@"region %@", region);
        [_rangedRegions addObject:region];
        NSLog(@"added %@",_rangedRegions);
        
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return _beacons.count;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSArray *sectionValues = [_beacons allValues];
    NSLog(@"........%@",sectionValues);
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
    
    UILabel *dbLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *minorLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *majorLabel = (UILabel *)[cell viewWithTag:300];
    
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
    //CLRegion *region = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    
//    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
//    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
//    
//    UIColor *bgColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1];
//    
//    cell.backgroundColor = bgColor;
    
    dbLabel.text = [NSString stringWithFormat:@"dB: %.2ld", (long)beacon.rssi];
    minorLabel.text = [NSString stringWithFormat:@"Minor: %@", beacon.minor];
    majorLabel.text = [NSString stringWithFormat:@"Major: %@", beacon.major];

    return cell;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
