//
//  Console_RootTVC.m
//  Cygnus
//
//  Created by Juan-Carlos Foust on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Console_RootTVC.h"
#import "CygnusManager.h"
#import "ClientSessionManager.h"

@interface Console_RootTVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *beaconImageView;

@end

@implementation Console_RootTVC
@synthesize mapTypeSegmentedControl = _mapTypeSegmentedControl;
@synthesize beaconImageView = _beaconImageView;


- (void)viewWillAppear:(BOOL)animated
{
    self.mapTypeSegmentedControl.selectedSegmentIndex = [ClientSessionManager currentUserMapPreference];;
    
    if (![ClientSessionManager currentUserBeaconEnabled]) {
        self.beaconImageView.image = [UIImage imageNamed:@"beaconInactive.png"];
    } else if (![ClientSessionManager currentUserBeaconFrequency]) {
        self.beaconImageView.image = [UIImage imageNamed:@"beaconActive.png"];
    } else {
        self.beaconImageView.image = [UIImage imageNamed:@"beaconFollow.png"];
    }
    [super viewWillAppear:animated];
}

- (IBAction)mapTypeSelected:(UISegmentedControl *)sender 
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:sender.selectedSegmentIndex]forKey:CURRENT_USER_MAP_PREFERENCE];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setBeaconImageView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source
/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}*/



@end
