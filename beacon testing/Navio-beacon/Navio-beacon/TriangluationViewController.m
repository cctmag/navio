//
//  TriangluationViewController.m
//  Navio-beacon
//
//  Created by Danny Holmes on 10/18/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import "TriangluationViewController.h"

@interface TriangluationViewController ()

@property (weak, nonatomic) IBOutlet UIView *roomView;

@end

@implementation TriangluationViewController {
    
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    NSUUID *_UUID;
    NSArray *_uuidArray;
    
    CLBeacon *_firstBeacon;
    CLBeacon *_secondBeacon;
    CLBeacon *_thirdBeacon;
    
    CLBeacon *_currentLocation;
    
    NSDictionary *_theBeacons;
    
    CGPoint _ourPoint;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
    [_beacons removeAllObjects];
    
    _firstBeacon = nil;
    _secondBeacon = nil;
    _thirdBeacon = nil;
    
    if (beacons.count > 2) {
        
        for (CLBeacon *beacon in beacons) {
            
            int rssi = (int)beacon.rssi;
            
            //NSLog(@"rssi %d",rssi);
            
            if (_firstBeacon.rssi == 0 || rssi > _firstBeacon.rssi) {
                _firstBeacon = beacon;
            }

            else if (_secondBeacon.rssi == 0 || rssi > _secondBeacon.rssi) {
                _secondBeacon = beacon;
            }
            
            else if (_thirdBeacon.rssi == 0 || rssi > _thirdBeacon.rssi) {
                _thirdBeacon = beacon;
            }
            
            NSLog(@"firstBeacon:%@, secondBeacon:%@, thirdBeacon:%@",_firstBeacon.minor,_secondBeacon.minor,_thirdBeacon.minor);
            
        }
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Triangulate"
                                                        message:@"Not enough beacons in range."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self calculatePosition];

}


- (void)viewDidAppear:(BOOL)animated
{
    
    // Start ranging when the view appears.
    
    NSEnumerator *enumerator = [_rangedRegions objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {
        [_locationManager startRangingBeaconsInRegion:anObject];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _beacons = [[NSMutableDictionary alloc] init];
    _rangedRegions = [[NSMutableArray alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    _firstBeacon = [[CLBeacon alloc]init];
    _secondBeacon = [[CLBeacon alloc]init];
    _thirdBeacon = [[CLBeacon alloc]init];
    
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(0, 6)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(12, 0)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(12, 6)];

    _theBeacons = @{ @1 : value1, @2 : value2, @3 : value3, @4 : value4 };
    
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    //////////
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E36397B6-C4FC-4D90-A044-6A35606F8D0D"];
    
    _uuidArray = [[NSArray alloc] initWithObjects:uuid, nil];
    
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
        
        [_rangedRegions addObject:region];
        
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


- (void)calculatePosition
{
    

    NSValue *val1 = [_theBeacons objectForKey:_firstBeacon.minor];
    NSValue *val2 = [_theBeacons objectForKey:_secondBeacon.minor];
    NSValue *val3 = [_theBeacons objectForKey:_thirdBeacon.minor];
    
    CGPoint firstBeaconPoint = [val1 CGPointValue];
    CGPoint secondBeaconPoint = [val2 CGPointValue];
    CGPoint thirdBeaconPoint = [val3 CGPointValue];

    float dBN1 = (float)_firstBeacon.rssi;
    float dBN2 = (float)_secondBeacon.rssi;
    float dBN3 = (float)_thirdBeacon.rssi;
    float dBR = -60;
    
    NSLog(@"rssi %f, %f, %f",dBN1,dBN2,dBN3);
    
    float test = pow(10,(dBN1 - dBR));

    NSLog(@"%f",test);
    
    // beacon distances determined using beacon.RSSI calculation
    float firstBeaconDistance = pow(10,((dBN1 - dBR) / -20));
    float secondBeaconDistance = pow(10,((dBN2 - dBR) / -20));
    float thirdBeaconDistance = pow(10,((dBN3 - dBR) / -20));
    
    NSLog(@"distances %f, %f, %f",firstBeaconDistance,secondBeaconDistance,thirdBeaconDistance);

    // beacon coordinates determined by searching an array containing all beacons
    // particular beacon can be found using major/minor numbers
    
    double xFirstBeacon = firstBeaconPoint.x;
    double yFirstBeacon = firstBeaconPoint.y;
    
    double xSecondBeacon = secondBeaconPoint.x;
    double ySecondBeacon = secondBeaconPoint.y;
    
    double xThirdBeacon = thirdBeaconPoint.x;
    double yThirdBeacon = thirdBeaconPoint.y;
    
    // check if all three beacons are on the same line (i.e. no solution)
    if ((xFirstBeacon == xSecondBeacon && xSecondBeacon == xThirdBeacon) ||
        ((yFirstBeacon == ySecondBeacon && ySecondBeacon == yThirdBeacon)))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to determine position"
                                                        message:@"All three beacons are on the same line."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // alter system of equations if first and second beacons have same y-coordinate
    // in order to prevent dividing by 0
    if (ySecondBeacon == yFirstBeacon)
    {
        double tempValue = secondBeaconDistance;
        secondBeaconDistance = thirdBeaconDistance;
        thirdBeaconDistance = tempValue;
        
        tempValue = xSecondBeacon;
        xSecondBeacon = xThirdBeacon;
        xThirdBeacon = tempValue;
        
        tempValue = ySecondBeacon;
        ySecondBeacon = yThirdBeacon;
        yThirdBeacon = tempValue;
    }
    
    // used to make x-coordinate calculation neater
    double termA = (pow(firstBeaconDistance, 2.0) - pow(thirdBeaconDistance, 2.0)) -
    (pow(xFirstBeacon, 2.0) - pow(xThirdBeacon, 2.0)) -
    (pow(yFirstBeacon, 2.0) - pow(yThirdBeacon, 2.0));
    
    double termB = ((yThirdBeacon - yFirstBeacon) / (ySecondBeacon - yFirstBeacon)) *
    ((pow(firstBeaconDistance, 2.0) - pow(secondBeaconDistance, 2.0)) -
     (pow(xFirstBeacon, 2.0) - pow(xSecondBeacon, 2.0)) -
     (pow(yFirstBeacon, 2.0) - pow(ySecondBeacon, 2.0)));
    
    double termC = 2.0 * (xThirdBeacon - xFirstBeacon) -
    2.0 * (xSecondBeacon - xFirstBeacon) *
    ((yThirdBeacon - yFirstBeacon) / (ySecondBeacon - yFirstBeacon));
    
    // calculate x-coordinate
    double xCoordinate = (termA - termB) / termC;
    
    
    // used to make y-coordinate calculation neater
    double termD = (pow(firstBeaconDistance, 2.0) - pow(secondBeaconDistance, 2.0)) -
    (pow(yFirstBeacon, 2.0) - pow(ySecondBeacon, 2.0)) -
    (pow(xFirstBeacon, 2.0) - pow(xSecondBeacon, 2.0)) -
    2.0 * xCoordinate * (xSecondBeacon - xFirstBeacon);
    
    double termE = 2.0 * (ySecondBeacon - yFirstBeacon);
    
    // calculate y-coordinate
    double yCoordinate = termD / termE;
    
    NSLog(@"x-coordinate: %@", [NSNumber numberWithDouble:xCoordinate]);
    NSLog(@"y-coordinate: %@", [NSNumber numberWithDouble:yCoordinate]);
    
    xCoordinate = 1.0 - (xCoordinate/212);
    xCoordinate = xCoordinate + 160;
    
    yCoordinate = 2.0 - (yCoordinate/212);
    yCoordinate = yCoordinate + 372;
    
    
    _ourPoint = CGPointMake(xCoordinate, yCoordinate);
    
    [self drawLocation];
    
}


-(void)drawLocation
{
    //160-372  100-524  212 424
    
    CGRect rect = CGRectMake(0, 0, 5, 5);
    
    UIView *locationIndicator = [[UIView alloc]initWithFrame:rect];
    
    locationIndicator.center = _ourPoint;
    locationIndicator.backgroundColor = [[UIColor alloc]initWithWhite:0 alpha:1];
    
    [self.view addSubview:locationIndicator];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
