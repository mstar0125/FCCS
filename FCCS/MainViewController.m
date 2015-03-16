//
//  MainViewController.m
//  FCCS
//
//  Created by Ben Folds on 3/16/15.
//  Copyright (c) 2015 monoLancer. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize fbNameLabel;
@synthesize fbEmailLabel;
@synthesize fbProfileImageView;
@synthesize fbCountryLabel;
@synthesize fbGenderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    [[FacebookManager sharedInstance] setDelegate:self];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    fbNameLabel.text = [THE_APP fbUserName];
    fbEmailLabel.text = [THE_APP fbEmail];
    fbProfileImageView.image = [[FacebookManager sharedInstance] getFBPic:[THE_APP fbId]];
    fbCountryLabel.text = [THE_APP fbCountry];
    fbGenderLabel.text = [THE_APP fbGender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogout :(id)sender
{
    [[FacebookManager sharedInstance] setDelegate:self];
    [[FacebookManager sharedInstance] logoutFacebook];
}

- (void) fbDataReceived: (NSDictionary *)data
{
    NSLog(@"MainViewController: fDataReceived");
    int responseMode = [[data objectForKey:@"type"] intValue] ;
    
    if ( responseMode == RESPONSE_FACEBOOK_LOGOUT ){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
