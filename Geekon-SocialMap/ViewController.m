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
    
    //1
    CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = location.latitude;
    zoomLocation.longitude= location.longitude;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(myAnnotation *)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return NULL;
    }
    else{
        static NSString *identifier = @"myAnnotation";
        MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        if (annotation.category != (id)[NSNull null] && [annotation.category isEqualToString:@"events"]){
            annotationView.pinColor = MKPinAnnotationColorPurple;
        } else{
            annotationView.pinColor = MKPinAnnotationColorGreen;
        }
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
        
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }

}

- (void) centerOnUserLocationTapped:(id) button {
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
}

// GET

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
    
    NSLog(@"%@", category);
    
    // do GET request ...
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
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
        
        NSLog(@"lat: %@, lon: %@, category:%@, text:%@", lat, lon, category, text);
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = [lat doubleValue];
        coordinate.longitude = [lon doubleValue];
        myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate title:text category:category];
        [self.mapView addAnnotation:annotation];
    }
    
    NSLog(@"dictionary: %@", checkins);
    
    if (error == nil)
    {
        // Parse data here
    }
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
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.postBar.text = @"";
    [self.postBar resignFirstResponder];
}

@end
