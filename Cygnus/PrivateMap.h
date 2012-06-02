//
//  PrivateMap.h
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Map.h"

@class Person;

@interface PrivateMap : Map

@property (nonatomic, retain) Person *creator;

@end
