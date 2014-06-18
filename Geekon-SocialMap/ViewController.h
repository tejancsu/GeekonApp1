//
//  ViewController.h
//  Geekon-SocialMap
//
//  Created by Wenxu Li on 6/16/14.
//  Copyright (c) 2014 OrdersTeam1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CJSONDeserializer.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *searchButtonForAll;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonForFood;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonForEvents;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonForDeals;

@property (weak, nonatomic) IBOutlet UISearchBar *postBar;

@end