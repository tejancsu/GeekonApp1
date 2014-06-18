//
//  myAnnotation.m
//  MapView
//
//  Created by Xin Chen on 6/17/14.
//  Copyright (c) 2014 Xin Chen. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation

//3.2
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
        self.category = NULL;
    }
    return self;
}


//3.2
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title category:(NSString *)category {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
        self.category = category;
    }
    return self;
}

@end