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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.407451
                                                            longitude:-91.172437
                                                                 zoom:19];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    // mapView_.mapType = kGMSTypeHybrid;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    // 30.407035,-91.172672
    // 30.407836,-91.172102
    
    // 30.407050,-91.172668
    // 30.407856,-91.172082
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(30.407050,-91.172668);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    mapView_.delegate = self;
    marker.map = mapView_;
    
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(30.407050,-91.172668);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(30.407856,-91.172082);
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    
    UIImage *icon = [UIImage imageNamed:@"DMC2nfloor.png"];
    GMSGroundOverlay *overlay =
    [GMSGroundOverlay groundOverlayWithBounds:overlayBounds icon:icon];
    overlay.bearing = 6.4;
    overlay.map = mapView_;
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

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}



@end
