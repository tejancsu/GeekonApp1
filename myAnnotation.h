//
//  myAnnotation.h
//  MapView
//
//  Created by Xin Chen on 6/17/14.
//  Copyright (c) 2014 Xin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//3.1
@interface myAnnotation : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *category;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate subtitle:(NSString *)subtitle title:(NSString *)title;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate subtitle:(NSString *)subtitle title:(NSString *)title category:(NSString *)category;

@end