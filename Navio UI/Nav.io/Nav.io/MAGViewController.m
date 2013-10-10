//
//  MAGViewController.m
//  Nav.io
//
//  Created by Jesse Allison on 9/20/13.
//  Copyright (c) 2013 MAG. All rights reserved.
//

#import "MAGViewController.h"
#import "MAGMapOverlay.h"
#import "MAGMapOverlayView.h"
#import <GoogleMaps/GoogleMaps.h>



@interface MAGViewController ()
- (IBAction)centerOnCCT:(UIBarButtonItem *)sender;
//@property (weak, nonatomic) IBOutlet MKMapView *cctMap;

@end

@implementation MAGViewController

GMSMapView *mapView_;

// You don't need to modify the default initWithNibName:bundle: method.

- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.407914
                                                            longitude:-91.172096
                                                                 zoom:22];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeHybrid;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(30.407614, -91.171743);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    MAGMapOverlay * mapOverlay = [[MAGMapOverlay alloc] init];
//    [self.cctMap addOverlay:mapOverlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)centerOnCCT:(UIBarButtonItem *)sender {
/*    MKCoordinateRegion theRegion = self.cctMap.region;
    NSLog(@"Map Coords %f, %f :: %f, %f", theRegion.center.latitude, theRegion.center.longitude, theRegion.span.latitudeDelta, theRegion.span.latitudeDelta);
    
    theRegion.center.latitude = 30.407614;
    theRegion.center.longitude = -91.171743;
    theRegion.span.latitudeDelta = 0.002493;
    theRegion.span.longitudeDelta = 0.002493;
    
    [self.cctMap setRegion:theRegion animated:YES];
 */
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
/*    MAGMapOverlay *mapOverlay = overlay;
    MAGMapOverlayView *mapOverlayView = [[MAGMapOverlayView alloc] initWithOverlay:mapOverlay];
    
    return mapOverlayView;
 */
    return nil;
    
}

@end
