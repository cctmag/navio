//
//  MAGBeacon.h
//  Nav.io
//
//  Created by Jesse Allison on 10/10/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MAGBeacon : NSObject
{

}

@property (nonatomic, retain) NSString *UUID;
@property (nonatomic, retain) NSNumber *major;
@property (nonatomic, retain) NSNumber *minor;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, retain) NSNumber *roomID;

@end
