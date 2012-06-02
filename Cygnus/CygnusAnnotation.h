//
//  CygnusAnnotation.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapPin+Cygnus.h"

@interface CygnusAnnotation : NSObject <MKAnnotation>
@property (nonatomic, strong) MapPin *mapPin;

- (BOOL)hasEvent;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
