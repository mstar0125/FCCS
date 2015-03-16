//
//  MainViewController.h
//  FCCS
//
//  Created by Ben Folds on 3/16/15.
//  Copyright (c) 2015 monoLancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FacebookManager.h"
@interface MainViewController : UIViewController<FacebookManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fbProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *fbGenderLabel;
@end
