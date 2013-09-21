//
//  MAGMapOverlay.m
//  Nav.io
//
//  Created by Jesse Allison on 9/20/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGMapOverlay.h"

@implementation MAGMapOverlay

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self != nil) {
        
        
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(30.407614, -91.171743);
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(30.409614, -91.161743));
    MKMapPoint upperRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(30.409614, -91.181743));
    MKMapPoint bottomLeft  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(30.405614, -91.161743));
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - upperRight.x), fabs(upperLeft.y - bottomLeft.y));
    
    return bounds;
}


@end
