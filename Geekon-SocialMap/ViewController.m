//
//  ViewController.m
//  Geekon-SocialMap
//
//  Created by Wenxu Li on 6/16/14.
//  Copyright (c) 2014 OrdersTeam1. All rights reserved.
//

#import "ViewController.h"
#import "CJSONDeserializer.h"
#include "NSDictionary_JSONExtensions.h"
#import "myAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    self.mapView.showsUserLocation = YES;
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    [self.centerOnUserLocation addTarget:self action:@selector(centerOnUserLocationTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // customize search buttons
    UIColor * color = [UIColor colorWithRed:230.0f/255.0f green:184.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    
    [self.searchButtonForAll setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForAll.layer.cornerRadius = 12;
    self.searchButtonForAll.layer.borderWidth = 1;
    self.searchButtonForAll.layer.borderColor = color.CGColor;
    
    [self.searchButtonForFood setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForFood.layer.cornerRadius = 12;
    self.searchButtonForFood.layer.borderWidth = 1;
    self.searchButtonForFood.layer.borderColor = color.CGColor;
    
    [self.searchButtonForEvents setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForEvents.layer.cornerRadius = 12;
    self.searchButtonForEvents.layer.borderWidth = 1;
    self.searchButtonForEvents.layer.borderColor = color.CGColor;
    
    [self.searchButtonForDeals setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.searchButtonForDeals.layer.cornerRadius = 12;
    self.searchButtonForDeals.layer.borderWidth = 1;
    self.searchButtonForDeals.layer.borderColor = color.CGColor;

    
    // click on search buttons
    [self.searchButtonForAll addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForFood addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForEvents addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButtonForDeals addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // post text bar
    self.postBar.delegate = self;
    
    // Remove the icon, which is located in the left view
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    self.postBar.searchTextPositionAdjustment = UIOffsetMake(10, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.785834;
    zoomLocation.longitude= -122.406417;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    
    
    [self setSearchButtonBackground:@"none"];
//    [self fetchAndDisplayCheckins:@"all"];
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(myAnnotation *)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return NULL;
    }
    else{
        static NSString *identifier = @"myAnnotation";
        MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];

        annotationView.pinColor = MKPinAnnotationColorRed;
        
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }

}

- (void) centerOnUserLocationTapped:(id) button {
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, METERS_PER_MILE, METERS_PER_MILE);
    [self.mapView setRegion:region animated:YES];
}


- (void) fetchAndDisplayCheckins:(NSString *)category {
    MKCoordinateRegion mapRegion = [self.mapView region];
    CLLocationCoordinate2D center = mapRegion.center;
    
    NSNumber * center_lat_double = [NSNumber numberWithDouble:center.latitude];
    NSNumber * center_lon_double = [NSNumber numberWithDouble:center.longitude];
    
    NSNumber * max_lat_double = [NSNumber numberWithDouble:(center.latitude + mapRegion.span.latitudeDelta)];
    NSNumber * min_lat_double = [NSNumber numberWithDouble:(center.latitude - mapRegion.span.latitudeDelta)];
    
    NSNumber * max_lon_double = [NSNumber numberWithDouble:(center.longitude + mapRegion.span.latitudeDelta)];
    
    NSNumber * min_lon_double = [NSNumber numberWithDouble:(center.longitude - mapRegion.span.latitudeDelta)];
    
    NSString * center_lat = [center_lat_double stringValue];
    NSString * center_lon = [center_lon_double stringValue];
    
    NSNumber * distance_double = [NSNumber numberWithDouble:(69.0 * MAX(mapRegion.span.latitudeDelta, mapRegion.span.longitudeDelta))];
    
    NSString * distance = [distance_double stringValue];
    
    NSMutableString * query = [NSMutableString string];
    [query appendString:@"http://10.101.114.89:3000/checkins?"];
    [query appendString:@"lat="];
    [query appendString:center_lat];
    [query appendString:@"&lon="];
    [query appendString:center_lon];
    [query appendString:@"&dist="];
    [query appendString:distance];
    
    if([category isEqualToString:@"all"]){
    } else{
        [query appendString:@"&category="];
        [query appendString:category];
    }
    
    NSLog(@"query: %@", query);
    
    
    // Send a synchronous request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:query]];
    request.HTTPMethod = @"GET";
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *theError = nil;
    NSDictionary *checkins = [[NSDictionary dictionaryWithJSONString:jsonString error:&theError] objectForKey:@"social_map"];
    
    for (id key in checkins) {
        NSDecimalNumber * lat = [key objectForKey:@"lat"];
        NSDecimalNumber * lon = [key objectForKey:@"lon"];
        NSString * category = [key objectForKey:@"category"];
        NSString * text = [key objectForKey:@"text"];
        NSArray *extra_texts = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
        NSMutableString * mutable_text =  [NSMutableString string];


        //[key objectForKey:@"extraTexts"];

        for (id et in extra_texts) {
            [mutable_text appendString: et];
        }
        NSLog(@"lat: %@, lon: %@, category:%@, text:%@", lat, lon, category, mutable_text);
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = [lat doubleValue];
        coordinate.longitude = [lon doubleValue];
        
        myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate subtitle:mutable_text title:text category:category];
        [self.mapView addAnnotation:annotation];
    }
    
    NSLog(@"dictionary: %@", checkins);
    
    if (error == nil)
    {
        // Parse data here
    }

}

- (void) setSearchButtonBackground:(NSString *) category {
    
    [self.searchButtonForAll  setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    [self.searchButtonForFood  setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    [self.searchButtonForEvents  setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    [self.searchButtonForDeals  setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    if ([category isEqualToString:@"all"]){
        [self.searchButtonForAll  setBackgroundColor:[UIColor colorWithRed:202.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0]];
    } else if ([category isEqualToString:@"food_and_drinks"]){
        [self.searchButtonForFood  setBackgroundColor:[UIColor colorWithRed:202.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0]];
    } else if ([category isEqualToString:@"events"]){
        [self.searchButtonForEvents  setBackgroundColor:[UIColor colorWithRed:202.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0]];
    } else if ([category isEqualToString:@"deals"]){
        [self.searchButtonForDeals  setBackgroundColor:[UIColor colorWithRed:202.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0]];
    }
}

- (void) searchButtonTapped:(id) button {
    if (![button isKindOfClass:[UIButton class]])
        return;
    
    NSString *title = [(UIButton *)button currentTitle];
    NSString *category = nil;
    
    if ([title  isEqual: @"A"]) {
        category = @"all";
    } else if ([title  isEqual: @"F"]) {
        category = @"food_and_drinks";
    } else if ([title  isEqual: @"E"]) {
        category = @"events";
    } else if ([title  isEqual: @"D"]) {
        category = @"deals";
    }
    
    [self setSearchButtonBackground:category];

    NSLog(@"%@", category);
    
    // do GET request ...
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    [self fetchAndDisplayCheckins:category];
}

// POST

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // do POST request ...
    NSString *text = searchBar.text;
    NSLog(@"%@", text);
    
    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    
    NSNumber * location_lat_double = [NSNumber numberWithDouble:location.latitude];
    NSNumber * location_lon_double = [NSNumber numberWithDouble:location.longitude];
    
    NSString * location_lat = [location_lat_double stringValue];
    NSString * location_lon = [location_lon_double stringValue];
    
    NSMutableString * query = [NSMutableString string];
    [query appendString:@"http://10.101.114.89:3000/checkins?"];
    [query appendString:@"lat="];
    [query appendString:location_lat];
    [query appendString:@"&lon="];
    [query appendString:location_lon];
    [query appendString:@"&text="];
    [query appendString:text];
    
    NSLog(@"query: %@", query);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:query]];
    
    request.HTTPMethod = @"POST";
    
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                     error:&error];
    
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *theError = nil;
    NSDictionary *checkins = [[NSDictionary dictionaryWithJSONString:jsonString error:&theError] objectForKey:@"social_map"];
    NSLog(@"dictionary: %@", checkins);
    
    [self setSearchButtonBackground:@"all"];
    [self fetchAndDisplayCheckins:@"all"];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.postBar.text = @"";
    [self.postBar resignFirstResponder];
}

@end
