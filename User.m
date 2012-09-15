//
//  User.m
//  SecretSanta
//
//  Created by Kris Fields on 9/12/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "User.h"
@interface User ()
@property (strong, nonatomic) NSMutableData *imageData;
@end

@implementation User

+ (User *)ourHero {
    static User *userSingleton = nil;
    if (!userSingleton) {
        userSingleton = [[super allocWithZone:nil] init];
        userSingleton.isParticipating = NO;
    }
    return userSingleton;
}
- (void)getAndSetFacebookUserData
{
    // Create request for user's facebook data
    NSString *requestPath = @"me?fields=name,gender,birthday,email";
    
    // Send request to facebook
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];
    
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            
            
            self.facebookUserData = (NSDictionary *)result; // The result is a dictionary
            
            
            self.imageData = [[NSMutableData alloc] init]; // the image will be loaded in here
            
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.facebookUserData objectForKey:@"id"]]];
            NSLog(@"profilePictureURl = %@",profilePictureURL);
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
            NSLog(@"profilePictureURLRequest = %@", profilePictureURLRequest);
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
            
        }
    }];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"appending to imageData");
    [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    NSLog(@"Set image");
    self.userImage = [UIImage imageWithData:self.imageData];
}

@end
