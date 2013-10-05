//
//  CentralViewController.h
//  Navio-beacon
//
//  Created by Danny Holmes on 9/30/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OurBeaconRegion.h"

@interface CentralViewController : UICollectionViewController <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end
