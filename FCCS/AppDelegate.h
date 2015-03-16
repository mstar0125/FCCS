//
//  AppDelegate.h
//  FCCS
//
//  Created by Ben Folds on 3/16/15.
//  Copyright (c) 2015 monoLancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookManager.h"

@class ViewController;

#define THE_APP (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *fbUserName;
@property (nonatomic, strong) NSString *fbEmail;
@property (readwrite) long long int fbId;
@property (nonatomic, strong) NSString *fbCountry;
@property (nonatomic, strong) NSString *fbGender;
@end
