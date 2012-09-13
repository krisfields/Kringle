//
//  User.h
//  SecretSanta
//
//  Created by Kris Fields on 9/12/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (strong, nonatomic) PFUser *pfUserObject;

+ (User *)ourHero;
@end
