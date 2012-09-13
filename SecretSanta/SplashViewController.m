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
    
    NSString *dateString = @"11/15/2012";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *drawNamesDate = [formatter dateFromString:dateString];
    NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:drawNamesDate];
    UINavigationController *navController;
    if (timeInt <= 0) {
        ExchangeViewController *exchangeVC = [ExchangeViewController new];
        navController = [[UINavigationController alloc] initWithRootViewController:exchangeVC];
    } else {
        DrawNameViewController *drawNameVC = [DrawNameViewController new];
        navController = [[UINavigationController alloc] initWithRootViewController:drawNameVC];
    }
    
    navController.navigationBar.tintColor =[UIColor colorWithRed:.62 green:.74 blue:.463 alpha:1.0];
    NSArray *permissionsArray = @[@"user_birthday", @"offline_access", @"email"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (user) {
            User *hero = [User ourHero];
            hero.pfUserObject = user;
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
//- (void)linkToFacebook {
//    [SZFacebookUtils setAppId:@"fb443486415704360"];
//    
//    
//    // These should come from your own facebook auth process
//    NSString *existingToken = @"EXISTING_TOKEN";
//    NSDate *existingExpiration = [NSDate distantFuture];
//    
//    [SZFacebookUtils linkWithAccessToken:existingToken expirationDate:existingExpiration success:^(id<SocializeFullUser> user) {
//        NSLog(@"Link successful");
//    } failure:^(NSError *error) {
//        NSLog(@"Link failed: %@", [error localizedDescription]);
//    }];
//}
@end
