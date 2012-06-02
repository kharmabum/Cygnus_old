//
//  Console_MapVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MapVC.h"
#import <MapKit/MapKit.h>
#import "ClientSettings.h"
#import "CygnusManager.h"
#import "CygnusAnnotation.h"
#import "Console_LoginVC.h"

@interface Console_MapVC () <MKMapViewDelegate, LoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation Console_MapVC
@synthesize mapView = _mapView;

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{    
    NSArray *mapPins = [CygnusManager mapPinsForClient];
    for (MapPin *mapPin in mapPins) {
        CygnusAnnotation *mpa = [[CygnusAnnotation alloc] init];
        mpa.mapPin = mapPin;
        [self.mapView addAnnotation:mpa];
    }
    
    //TODO corelocation
    [self zoomMapForBestFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard; //TODO return from UserPreferences
    
    if (![ClientSettings currentUser]) {
        Console_LoginVC *lvc = (Console_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Console_LoginVC"];
        lvc.delegate = self;
        [self presentModalViewController:lvc animated:NO];
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(Console_LoginVC *)sender didloginUserWithEmail:(NSString*)email
{
    BOOL passed = [ClientSettings setCurrentUser:email];
    if (!passed) {
        //handle error with login
    }
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Map Helpers

- (void)zoomMapForBestFit { 
    MKMapView *mapView = self.mapView;
    if ([mapView.annotations count] == 0) return; 
    
    CLLocationCoordinate2D topLeftCoord; 
    topLeftCoord.latitude =  -90; 
    topLeftCoord.longitude = 180; 
    
    CLLocationCoordinate2D bottomRightCoord; 
    bottomRightCoord.latitude = 90; 
    bottomRightCoord.longitude = -180; 
    
    for (id <MKAnnotation> annotation in mapView.annotations) { 
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
    } 
    
    MKCoordinateRegion region; 
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; 
    region = [mapView regionThatFits:region]; 
    [mapView setRegion:region animated:YES]; 
}

#pragma mark - MKMapViewDelegate

/*
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
 
        ImageDisplayVC *ivc;
        if (self.splitViewController) {
            ivc = [[[self splitViewController] viewControllers] lastObject];
            NSDictionary *photo = [(FlickrPhotoAnnotation *)view.annotation photo];
            ivc.photo = photo;
            [RecentlyViewedImages addToRecentlyViewed:photo];      
        } else {
            ivc = (ImageDisplayVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageDisplayVC"];
            NSDictionary *photo = [(FlickrPhotoAnnotation *)view.annotation photo];
            ivc.photo = photo;
            [RecentlyViewedImages addToRecentlyViewed:photo];  
            [self.navigationController pushViewController:ivc animated:YES];
        }

}
*/

#define ANNOTATION_VIEW_REUSE_ID @"MapPinView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_REUSE_ID];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_REUSE_ID];
        //view.canShowCallout = YES;
        /*
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        disclosureButton.frame = CGRectMake(0, 0, 23, 23);
        view.rightCalloutAccessoryView = disclosureButton;        
        
        if ([annotation isMemberOfClass:[FlickrPhotoAnnotation class]]) { 
            view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }*/
    }
    
    /*
    if ([annotation isMemberOfClass:[FlickrPlaceAnnotation class]]) {
        view.leftCalloutAccessoryView = nil;
    } else {
        ((UIImageView *)view.leftCalloutAccessoryView).image = nil;
    }*/
        
    view.draggable = YES;
    view.annotation = annotation;
    if ([(CygnusAnnotation*)annotation hasEvent]) {
        [(MKPinAnnotationView*)view setPinColor:MKPinAnnotationColorGreen];
    }
    view.enabled = YES;
    return view;
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    dispatch_queue_t fetchQueue = dispatch_queue_create("flickr thumbnail fetch queue", NULL);
    dispatch_async(fetchQueue, ^{
        if ([view.annotation isMemberOfClass:[FlickrPhotoAnnotation class]]) {
            FlickrPhotoAnnotation *selectedAnnotation = view.annotation; 
            NSDictionary *photo = selectedAnnotation.photo;
            NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.mapView.selectedAnnotations objectAtIndex:0] == selectedAnnotation) {
                    ((UIImageView *)view.leftCalloutAccessoryView).image = image;   
                }
            });
        }
    });
    dispatch_release(fetchQueue);
}
 */


@end
