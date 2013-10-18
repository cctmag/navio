//
//  BeaconViewController.h
//  Navio-beacon
//
//  Created by Danny Holmes on 9/21/13.
//  Copyright (c) 2013 LSU|MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
//#import <MessageUI/MessageUI.h>
//#import <MessageUI/MFMailComposeViewController.h>

//MFMailComposeViewControllerDelegate,

@interface BeaconViewController : UIViewController <CBPeripheralManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@end
