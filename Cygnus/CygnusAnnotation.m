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
return [self.mapPin name];
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

@end
