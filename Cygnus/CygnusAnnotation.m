//
//  CygnusAnnotation.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CygnusAnnotation.h"

@implementation CygnusAnnotation
@synthesize mapPin = _mapPin;

- (NSString *)title
{
return [self.mapPin location_name];
}

- (NSString *)subtitle
{
return [self.mapPin summary];
}

- (CLLocationCoordinate2D)coordinate
{
CLLocationCoordinate2D coordinate;
coordinate.latitude = [[self.mapPin latitude] floatValue];
coordinate.longitude = [[self.mapPin longitude] floatValue];
return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.mapPin.latitude = [NSNumber numberWithDouble:newCoordinate.latitude];
    self.mapPin.longitude = [NSNumber numberWithDouble:newCoordinate.longitude];
}


- (BOOL)hasEvent 
{
    return [[self.mapPin events] count];
}

@end
