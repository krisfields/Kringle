//
//  SplashViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/10/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "SplashViewController.h"
#import "ExchangeViewController.h"
#import "DrawNameViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import <Socialize/Socialize.h>
#import "ComeBackSoonViewController.h"
#import "MissedExchangeViewController.h"

@interface SplashViewController ()
- (IBAction)facebookButton:(id)sender;

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)facebookButton:(id)sender {
    
    if (!self.dateString) {
        self.dateString = @"09/10/2012";
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *drawNamesDate = [formatter dateFromString:self.dateString];
    NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:drawNamesDate];
    NSArray *permissionsArray = @[@"user_birthday", @"offline_access", @"email"];
    __block UINavigationController *navController;
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (user) {
            User *hero = [User ourHero];
            PFUser *pfUser = [PFUser currentUser];
            PFQuery *query = [PFQuery queryWithClassName:@"UsersInExchange"];
            [query whereKey:@"user" equalTo:pfUser];
            NSArray* userInExchange = [query findObjects];
            if ([userInExchange count] > 0) {
                hero.isParticipating = YES;
            };
            [hero getAndSetFacebookUserData];
            hero.pfUserObject = user;
            UIViewController *viewController;
            if (timeInt <= 0 /*&& [[User ourHero] isParticipating] == NO*/) {
                viewController = [ExchangeViewController new];
            } else if (timeInt <= 0 && [[User ourHero] isParticipating] == YES) {
                viewController = [ComeBackSoonViewController new];
            } else if ([[User ourHero] isParticipating] == NO) {
                viewController = [MissedExchangeViewController new];
            } else {
                viewController = [DrawNameViewController new];
            }
            navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navController.navigationBar.tintColor =[UIColor colorWithRed:.62 green:.74 blue:.463 alpha:1.0];
            [self linkToFacebook];
        }
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            [self presentModalViewController:navController animated:YES];
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            [self presentModalViewController:navController animated:YES];
            NSLog(@"User logged in through Facebook!");
        }
    }];


}
- (void)linkToFacebook {
    [SZFacebookUtils setAppId:@"fb443486415704360"];
    
    
    // These should come from your own facebook auth process
    NSString *existingToken = [[PFFacebookUtils session] accessToken];
    NSDate *existingExpiration = [[PFFacebookUtils session] expirationDate];
    
    [SZFacebookUtils linkWithAccessToken:existingToken expirationDate:existingExpiration success:^(id<SocializeFullUser> user) {
        NSLog(@"Link successful");
    } failure:^(NSError *error) {
        NSLog(@"Link failed: %@", [error localizedDescription]);
    }];
}
@end
