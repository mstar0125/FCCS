//
//  ViewController.m
//  FCCS
//
//  Created by Ben Folds on 3/16/15.
//  Copyright (c) 2015 monoLancer. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogin:(id)sender
{
    [[FacebookManager sharedInstance] setDelegate:self];
    [[FacebookManager sharedInstance] loginFacebook];
}

- (void) fbDataReceived: (NSDictionary *)data
{
    NSLog(@"ViewController: fDataReceived");
    int responseMode = [[data objectForKey:@"type"] intValue] ;
    
    if ( responseMode == RESPONSE_FACEBOOK_LOGIN_DID ){
        
        [MBProgressHUD showGlobalHUDWithTitle:@"Loading Personal Info..."];
        
        [[FacebookManager sharedInstance] setDelegate:self];
        [[FacebookManager sharedInstance] getPersonalInfo];
        
    }else if (responseMode == RESPONSE_FACEBOOK_LOGIN_FAILED){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Problem" message:@"There are some problems in the server. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
    }else if(responseMode == RESPONSE_FACEBOOK_FBDONE){
        [MBProgressHUD hideGlobalHUD];
        MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainviewcontroller"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
