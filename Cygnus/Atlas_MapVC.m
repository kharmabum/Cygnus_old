//
//  Atlas_MapVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Atlas_MapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ClientSessionManager.h"
#import "CygnusManager.h"
#import "CygnusAnnotation.h"
#import "CygnusBeaconAnnotation.h"
#import "Atlas_LoginVC.h"

@interface Atlas_MapVC () <MKMapViewDelegate, CLLocationManagerDelegate, LoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *cygnusLabel;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) CygnusBeaconAnnotation *currentUserBeacon;
@property (strong, nonatomic) CLLocationManager *beaconManager;
@property (strong, nonatomic) NSDictionary *mapPinIcons;

@end

@implementation Atlas_MapVC
@synthesize mapView = _mapView;
@synthesize cygnusLabel = _cygnusLabel;
@synthesize listButton = _listButton;
@synthesize mapPinIcons = _mapPinIcons;
@synthesize beaconManager = _beaconManager;
@synthesize currentUserBeacon = _currentUserBeacon;

- (void)initMapPinIcons
{

    _mapPinIcons = [NSDictionary dictionaryWithObjectsAndKeys:                                        
                    [UIImage imageNamed:@"bluePin.png"], MAP_PIN_VIEW_LOCATION_DEFAULT,
                    [UIImage imageNamed:@"bluePinEmpty.png"], MAP_PIN_VIEW_LOCATION_CANEDIT,
                    
                    [UIImage imageNamed:@"redPin.png"], MAP_PIN_VIEW_EVENT_DEFAULT,
                    [UIImage imageNamed:@"redPinEmpty.png"], MAP_PIN_VIEW_EVENT_CANEDIT,
                    
                    [UIImage imageNamed:@"purplePin.png"], MAP_PIN_VIEW_PARTY_DEFAULT,
                    [UIImage imageNamed:@"purplePinEmpty.png"], MAP_PIN_VIEW_PARTY_CANEDIT,
                    
                    [UIImage imageNamed:@"beaconInactive.png"], MAP_PIN_VIEW_BEACON_INACTIVE,
                    [UIImage imageNamed:@"beaconActive.png"], MAP_PIN_VIEW_BEACON_ACTIVE,
                    [UIImage imageNamed:@"beaconFollow.png"], MAP_PIN_VIEW_BEACON_FOLLOW, nil];
}

- (void)loadClientSession
{
    if (![ClientSessionManager currentUser]) {
        Atlas_LoginVC *lvc = (Atlas_LoginVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"Atlas_LoginVC"];
        lvc.delegate = self;
        [self presentModalViewController:lvc animated:NO];

    } else {
        switch ([ClientSessionManager currentUserMapPreference]) {
            case MAP_TYPE_STANDARD:
                self.mapView.mapType = MKMapTypeStandard;
                self.cygnusLabel.textColor = [UIColor blackColor];
                self.cygnusLabel.alpha = 0.7;
                self.listButton.imageView.image = [UIImage imageNamed:@"179-notepad.png"];
                self.listButton.imageView.alpha = 0.9;
                break;
                
            case MAP_TYPE_HYBRID:
                self.mapView.mapType = MKMapTypeHybrid;
                self.cygnusLabel.textColor = [UIColor whiteColor];
                self.listButton.imageView.image = [UIImage imageNamed:@"179-notepad-white.png"];
                self.cygnusLabel.alpha = self.listButton.imageView.alpha = 1;
                break;
                
            case MAP_TYPE_SATELLITE:
                self.mapView.mapType = MKMapTypeSatellite;
                self.cygnusLabel.textColor = [UIColor whiteColor];
                self.listButton.imageView.image = [UIImage imageNamed:@"179-notepad-white.png"];
                self.cygnusLabel.alpha = self.listButton.imageView.alpha = 1;

                break;
        }
        
        // LOAD PINS - 
        if ([ClientSessionManager updateRequired]) {
            [self.mapView removeAnnotations:self.mapView.annotations];
        }
        NSSet *mapPins = [ClientSessionManager mapPinsForCurrentUser];
        for (MapPin *mapPin in mapPins) {
            //NSLog(@"mapPin for current user - %@", mapPin);
            CygnusAnnotation *mpa = [[CygnusAnnotation alloc] init];
            mpa.mapPin = mapPin;
            [self.mapView addAnnotation:mpa];
        }
        [self.mapView addAnnotation:self.currentUserBeacon];
        [self.mapView selectAnnotation:self.currentUserBeacon animated:NO];
    }
}

- (void)reloadClientSession 
{
    [self.mapView removeAnnotations:self.mapView.annotations];  
    [self setBeacon];
    [self loadClientSession];
    [self zoomMapForBestFit];

}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    [self loadClientSession];
    [self zoomMapForBestFit];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.beaconManager = [[CLLocationManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.beaconManager.distanceFilter = kCLDistanceFilterNone;
    [self initMapPinIcons];
    [self setBeacon];  
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setCygnusLabel:nil];
    [self setListButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(Atlas_LoginVC *)sender didloginUserWithEmail:(NSString*)email
{
    BOOL passed = [ClientSessionManager setCurrentUser:email];
    if (!passed) {
        //handle error with login
        NSLog(@"Login failure");
    }
    [self dismissModalViewControllerAnimated:YES];
    [self reloadClientSession];
}


#pragma mark - Map Helpers

- (void)setBeacon
{
    CygnusBeaconAnnotation *beacon = [[CygnusBeaconAnnotation alloc] init];
    beacon.person = [ClientSessionManager currentUser];
    self.currentUserBeacon = beacon;  
    int beaconFrequency;
    if ((beaconFrequency = [ClientSessionManager currentUserBeaconFrequency])) {
        [self.beaconManager startUpdatingLocation];
    }
}

- (void)zoomMapForBestFit { 
    MKMapView *mapView = self.mapView;
    if ([mapView.annotations count] == 0) { 
        return; 
    }

    if ([mapView.annotations count] == 1) { 
        [self.mapView setCenterCoordinate:self.currentUserBeacon.coordinate];
        return;
    }
    
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
    [mapView setRegion:region animated:NO]; 
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager 
     didUpdateToLocation:(CLLocation *)newLocation 
            fromLocation:(CLLocation *)oldLocation
{
    if (!self.currentUserBeacon.person) return;
    [self.currentUserBeacon setCoordinate:newLocation.coordinate];
    [self.beaconManager stopUpdatingLocation];    
    [self.beaconManager performSelector:@selector(startUpdatingLocation) 
                             withObject:nil 
                             afterDelay:[ClientSessionManager currentUserBeaconFrequency]];
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

#define ANNOTATION_VIEW_REUSE_ID @"mapPin_MKAnnotationView"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_REUSE_ID];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_REUSE_ID];
        //view.canShowCallout = YES;
        /*
         UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
         disclosureButton.frame = CGRectMake(0, 0, 23, 23);
         view.rightCalloutAccessoryView = disclosureButton;        
         view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
         }*/
    }
    
    /*
     if ([annotation isMemberOfClass:[FlickrPlaceAnnotation class]]) {
     view.leftCalloutAccessoryView = nil;
     } else {
     ((UIImageView *)view.leftCalloutAccessoryView).image = nil;
     }*/
    
    
    //  IS THE PIN EDITABLE BY CURRENT USER
    //view.draggable = YES;
    
    view.annotation = annotation;
    
    NSString *viewWithEditStatus;
    if ([annotation isMemberOfClass:[CygnusBeaconAnnotation class]]) {
        if ([ClientSessionManager currentUserBeaconEnabled]) {
            viewWithEditStatus = ([ClientSessionManager currentUserBeaconFrequency]) ? MAP_PIN_VIEW_BEACON_FOLLOW : MAP_PIN_VIEW_BEACON_ACTIVE;
        } else {
            viewWithEditStatus =  MAP_PIN_VIEW_BEACON_INACTIVE;
        }
        // TODO - SET DATA FOR BEACON CALL OUT VIEW
    } else {
        //if ([(CygnusAnnotation*)annotation hasParty]) {   // TODO - PARTY ON PIN
        if ([(CygnusAnnotation*)annotation hasEvent]) {
            viewWithEditStatus = MAP_PIN_VIEW_EVENT_DEFAULT; //TODO - can edit?
            //TODO - set data on callout
        } else {
            viewWithEditStatus = MAP_PIN_VIEW_LOCATION_DEFAULT; //TODO -can edit?
            //TODO - set data on callout
        }
    }
    [(MKAnnotationView*)view setImage:[self.mapPinIcons objectForKey:viewWithEditStatus]];
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
