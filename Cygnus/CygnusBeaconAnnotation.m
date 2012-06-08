//
//  CygnusBeaconAnnotation.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CygnusBeaconAnnotation.h"
#import "Person+Cygnus.h"

@implementation CygnusBeaconAnnotation
@synthesize person = _person;

- (NSString *)title
{
    return @"My beacon";
}

- (NSString *)subtitle
{
    NSString *activity = ([self.person.beaconActive boolValue]) ? @"Enabled" : @"Disabled";    
    return [NSString stringWithFormat:@"%@, %@", activity, self.person.broadcastRange];
}


- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.person latitude] doubleValue];
    coordinate.longitude = [[self.person longitude] doubleValue];
    return coordinate;
}



- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.person.latitude = [NSNumber numberWithDouble:newCoordinate.latitude];
    self.person.longitude = [NSNumber numberWithDouble:newCoordinate.longitude];
}


@end
