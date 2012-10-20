//
//  Console_MyBeaconTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_MyBeaconTVC.h"
#import "CygnusManager.h"
#import "ClientSessionManager.h"

@interface Console_MyBeaconTVC ()
@property (weak, nonatomic) IBOutlet UIImageView *beaconImageView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *beaconRangeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *beaconFrequencySegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *beaconActivitySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *beaconUpdateSwitch;

@end

@implementation Console_MyBeaconTVC
@synthesize beaconImageView = _beaconImageView;
@synthesize beaconRangeSegmentedControl = _beaconRangeSegmentedControl;
@synthesize beaconFrequencySegmentedControl = _beaconFrequencySegmentedControl;
@synthesize beaconActivitySwitch = _beaconActivitySwitch;
@synthesize beaconUpdateSwitch = _beaconUpdateSwitch;


- (IBAction)switchBeaconStatus:(UISwitch *)beacon {
    if (beacon.on) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:CURRENT_USER_BEACON_ENABLED];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:CURRENT_USER_BEACON_ENABLED];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:SETTINGS_BEACON_FREQUENCY_0] forKey:CURRENT_USER_BEACON_FREQUENCY];
        [self.beaconUpdateSwitch setOn:NO];
        self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_INACTIVE];
    }
}

- (IBAction)switchBeaconFollowStatus:(UISwitch *)sender {
    if (sender.on) {
        [self.beaconActivitySwitch setOn:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:CURRENT_USER_BEACON_ENABLED];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:SETTINGS_BEACON_FREQUENCY_1 ] forKey:CURRENT_USER_BEACON_FREQUENCY];
        [self.beaconFrequencySegmentedControl setSelectedSegmentIndex:0];

        self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_FOLLOW];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:SETTINGS_BEACON_FREQUENCY_0 ] forKey:CURRENT_USER_BEACON_FREQUENCY];
        [self.beaconFrequencySegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
        self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_ACTIVE];
    }
}

- (IBAction)changeBeaconRange:(UISegmentedControl *)sender {
    int selectedIndex = [sender selectedSegmentIndex];
    int beaconRange;
    switch (selectedIndex) {
        case 0:
            beaconRange = SETTINGS_BEACON_RANGE_0;
            break;
        case 1:
            beaconRange = SETTINGS_BEACON_RANGE_1;
            break;
        case 2:
            beaconRange = SETTINGS_BEACON_RANGE_2;
            break;
        default:
            beaconRange = SETTINGS_BEACON_RANGE_3;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:beaconRange] forKey:CURRENT_USER_BEACON_RANGE];
}


- (IBAction)changeBeaconFrequency:(UISegmentedControl *)sender {
    int selectedIndex = [sender selectedSegmentIndex];
    int beaconFrequency;
    switch (selectedIndex) {
        case 0:
            beaconFrequency = SETTINGS_BEACON_FREQUENCY_1;
            break;
        case 1:
            beaconFrequency = SETTINGS_BEACON_FREQUENCY_2;
            break;
        case 2:
            beaconFrequency = SETTINGS_BEACON_FREQUENCY_3;
            break;
        default:
            beaconFrequency = SETTINGS_BEACON_FREQUENCY_4;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:beaconFrequency] forKey:CURRENT_USER_BEACON_FREQUENCY];
    [self.beaconUpdateSwitch setOn:YES];
    self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_FOLLOW];
}




#pragma mark - LIFECYCLE

- (void)viewWillAppear:(BOOL)animated
{
    int updateFrequency = [ClientSessionManager currentUserBeaconFrequency];
    BOOL beaconEnabled  = [ClientSessionManager currentUserBeaconEnabled];
    
    [self.beaconActivitySwitch setOn:beaconEnabled];
     
    if (beaconEnabled) {
        if (!updateFrequency) {
            self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_ACTIVE];
        } else {
            self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_FOLLOW];
        }
     } else {
         self.beaconImageView.image = [UIImage imageNamed:SETTINGS_BEACON_INACTIVE];
     }
    
    int selectedIndex = -1;
    if (!updateFrequency) {
        [self.beaconUpdateSwitch setOn:NO];
        [self.beaconFrequencySegmentedControl setSelectedSegmentIndex: UISegmentedControlNoSegment];
    } else {
        [self.beaconUpdateSwitch setOn:YES];
        switch (updateFrequency) {
            case SETTINGS_BEACON_FREQUENCY_1:
                selectedIndex = 0;
                break;
            case SETTINGS_BEACON_FREQUENCY_2:
                selectedIndex = 1;
                break;
            case SETTINGS_BEACON_FREQUENCY_3:
                selectedIndex = 2;
                break;
            case SETTINGS_BEACON_FREQUENCY_4:
                selectedIndex = 3;
                break;
            default:
                break;
        }        
        [self.beaconFrequencySegmentedControl setSelectedSegmentIndex: selectedIndex];
    }
    
    int beaconRange = [ClientSessionManager currentUserBeaconRange];
    switch (beaconRange) {
        case SETTINGS_BEACON_RANGE_0:
            selectedIndex = 0;
            break;
        case SETTINGS_BEACON_RANGE_1:
            selectedIndex = 1;
            break;
        case SETTINGS_BEACON_RANGE_2:
            selectedIndex = 2;
            break;
        case SETTINGS_BEACON_RANGE_3:
            selectedIndex = 3;
            break;
        default:
            break;
    }
    [self.beaconRangeSegmentedControl setSelectedSegmentIndex: selectedIndex];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setBeaconImageView:nil];
    [self setBeaconRangeSegmentedControl:nil];
    [self setBeaconFrequencySegmentedControl:nil];
    [self setBeaconActivitySwitch:nil];
    [self setBeaconUpdateSwitch:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
