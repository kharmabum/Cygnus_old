//
//  CygnusBeaconAnnotation.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Person+Cygnus.h"

@interface CygnusBeaconAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong) Person *person;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end

