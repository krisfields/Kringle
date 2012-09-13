//
//  User.m
//  SecretSanta
//
//  Created by Kris Fields on 9/12/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)ourHero {
    static User *userSingleton = nil; if (!userSingleton)
        userSingleton = [[super allocWithZone:nil] init];
    return userSingleton;
}

@end
