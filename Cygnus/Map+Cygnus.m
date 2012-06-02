//
//  Map+Cygnus.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Map+Cygnus.h"
#import "CygnusManager.h"



@implementation Map (Cygnus)

+ (Map *)mapFromPlistData:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext*)context
{

    Map *map = nil;
    NSString *mapType;
    int type = [[dict valueForKey:@"mapType"] intValue];
    switch (type) {
        case SIM_MAP_TYPE_GROUP:
            mapType = CYGNUS_GROUP_MAP;
            break;
        
        case SIM_MAP_TYPE_AUX:
            mapType = CYGNUS_AUX_MAP;
            break;
            
        case SIM_MAP_TYPE_PRIVATE:
            mapType = CYGNUS_PRIVATE_MAP;
            break;
    }
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:mapType];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [dict objectForKey:CYGNUS_MAP_ID]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        NSString *placeName = [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME];
        photo.locationOfPhoto = [Place placeWithName:placeName inManagedObjectContext:context];
        NSArray *searchTagIdentifiers = [[flickrInfo valueForKeyPath:FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tagName in searchTagIdentifiers) {
            if ([tagName rangeOfString:@":"].location == NSNotFound) {
                SearchTag *tag = [SearchTag searchTagWithName:tagName forPhoto:photo inManagedObjectContext:context];
                [photo addSearchTagsObject:tag];
            }
        }
    } else {
        photo = [matches lastObject];
    }
    return photo;
}
    
/*
- (void)prepareForDeletion
{
    for (SearchTag* tag in self.searchTags) {
        tag.referenceCount = [NSNumber numberWithInt:(tag.referenceCount.intValue-1)];
        if (![tag.referenceCount intValue]) [tag.managedObjectContext deleteObject:tag];
    }
    self.locationOfPhoto.referenceCount = [NSNumber numberWithInt:(self.locationOfPhoto.referenceCount.intValue-1)];
    if (![self.locationOfPhoto.referenceCount intValue]) [self.locationOfPhoto.managedObjectContext deleteObject:self.locationOfPhoto];
    
    
}*/

}


@end
