//
//  User.h
//  SecretSanta
//
//  Created by Kris Fields on 9/12/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject <PF_FBRequestDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) PFUser *pfUserObject;
@property (nonatomic) BOOL isParticipating;
@property (strong, nonatomic) NSDictionary *facebookUserData;
@property (strong, nonatomic) UIImage *userImage;
+ (User *)ourHero;
- (void)getAndSetFacebookUserData;
@end
