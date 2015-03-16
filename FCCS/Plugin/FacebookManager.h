//
//  FacebookManager.h
//  FCCS
//
//  Created by RongNaiZhong on 3/16/15.

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

typedef enum{
    
    RESPONSE_FACEBOOK_LOGIN_DID = 0,
    RESPONSE_FACEBOOK_LOGIN_FAILED,
    RESPONSE_FACEBOOK_LOGOUT,
    RESPONSE_FACEBOOK_FBDONE,
    numResponseModes
} responseModes;

@protocol FacebookManagerDelegate <NSObject>
@optional

- (void) fbDataReceived: (NSDictionary *)data;

@end


@interface FacebookManager : NSObject{
    id <FacebookManagerDelegate> delegate;
}

@property (strong) id delegate;

+ (FacebookManager *)sharedInstance;

// Initialize
- (void) initData;

// Facebook Manager
- (BOOL) initFacebook;
- (void) loginFacebook;
- (void) logoutFacebook;
- (void) restoreFacebook;
- (void) getPersonalInfo;
- (UIImage *) getFBPic:(long long int)fbid;
@end
