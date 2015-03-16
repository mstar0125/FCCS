//
//  FacebookManager.m
//  FCCS
//
//  Created by RongNaiZhong on 3/16/15.
//

#import "FacebookManager.h"

@implementation FacebookManager

@synthesize delegate;

#pragma mark Initialization
static FacebookManager *sharedInstance = nil;

+ (FacebookManager *) sharedInstance {
    
    @synchronized([FacebookManager class])
    {
        if(!sharedInstance) {
            sharedInstance = [[FacebookManager alloc] init];
        }
        return sharedInstance;
    }
    return nil;
}
+(id)alloc
{
	@synchronized([FacebookManager class])
	{
		NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of FacebookManager.");
		sharedInstance = [super alloc];
		return sharedInstance;
	}
	return nil;
}

-(id)init{
    if((self = [super init])) {
        [self initData];
    }
    return self;
}

- (void) initData{
    
}

#pragma mark Facebook Manager

-(BOOL) initFacebook {
    if (!FBSession.activeSession.isOpen) {
        return NO;
    }else{
        
        return YES;
    }
    return NO;
}

- (void) restoreFacebook{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"public_profile",nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          [self sessionStateChanged:session
                                                              state:state
                                                              error:error];
                                      }];
    }
}

- (void) loginFacebook{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", @"public_profile",nil];
    
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      [self sessionStateChanged:session
                                                          state:state
                                                          error:error];
                                  }];
    
}
- (void) logoutFacebook{
    
    [FBSession.activeSession closeAndClearTokenInformation];

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:RESPONSE_FACEBOOK_LOGOUT],@"type", nil];
    [delegate fbDataReceived:d];
}

- (void) getPersonalInfo{

    [FBRequestConnection startForMeWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             
             NSLog(@"User Info=%@", user);
             long long int fbId  = [[user objectForKey:@"id"] longLongValue];
             NSString *fbName = [user objectForKey:@"name"];
             NSString *fbLocale = [user objectForKey:@"locale"];
             NSString *fbEmail = [user objectForKey:@"email"];
             NSString *fbGender = [user objectForKey:@"gender"];
             
             NSString *location;
             NSDictionary *locD = [user objectForKey:@"location"];
             NSString *locString = [locD objectForKey:@"name"];
             if ( (NSNull *)[user objectForKey:@"location"] == [NSNull null] ){
                 location = @"unknown";
             }
             else if ( (NSNull *)[locD objectForKey:@"name"] == [NSNull null] ) {
                 location = @"unknown";
             }else{
                 location = locString;
             }
             
             [THE_APP setFbId:fbId];
             [THE_APP setFbUserName:fbName];
             [THE_APP setFbCountry:location];
             [THE_APP setFbEmail:fbEmail];
             [THE_APP setFbGender:fbGender];
             
             NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:RESPONSE_FACEBOOK_FBDONE],@"type", user, @"data",
                                        nil];
             [delegate fbDataReceived:d1];
         }
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            // Handle the logged in scenario
            
            // You may wish to show a logged in view
            NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:RESPONSE_FACEBOOK_LOGIN_DID],@"type",
                                       nil];
            NSLog(@"access Token %@",session.accessTokenData.accessToken);
            NSLog(@"access Token %@", session.accessTokenData.expirationDate);
            [delegate fbDataReceived:d1];
            break;
        }
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed: {
            // Handle the logged out scenario
            
            // Close the active session
            [FBSession.activeSession closeAndClearTokenInformation];
            NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:RESPONSE_FACEBOOK_LOGIN_FAILED],@"type",
                                       nil];
            [delegate fbDataReceived:d1];
            // You may wish to show a logged out view
            
            break;
        }
        default:
            break;
    }
    
    if (error) {
        // Handle authentication errors
    }
}

#define TMP NSTemporaryDirectory()
- (UIImage *) getFBPic:(long long int)fbid
{
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%lli/picture",fbid];
    NSString *fileName = [NSString stringWithFormat:@"%lli",fbid];
    NSString *cachedPath = [TMP stringByAppendingPathComponent:fileName];
    
    //NSString *filename = path;
    //NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    NSData *data;
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath:cachedPath])
    {
        //image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
        data = [NSData dataWithContentsOfFile:cachedPath];
    }
    else
    {
        // get a new one
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        //[self cacheData:uniquePath data:data];
        //image = [UIImage imageWithContentsOfFile: uniquePath];
        [data writeToFile:cachedPath atomically:TRUE];
    }
    image = [UIImage imageWithData:data];
    return image;
}
@end
