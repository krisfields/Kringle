//
//  ExchangeViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/10/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "ExchangeViewController.h"
#import "RulesViewController.h"
#import "UserInfoFormViewController.h"
#import <Parse/Parse.h>
#import <Socialize/Socialize.h>


@interface ExchangeViewController () <PF_FBRequestDelegate, UITextFieldDelegate>
- (IBAction)participateButton:(id)sender;
- (IBAction)rulesButton:(id)sender;
@property (nonatomic, retain) SZActionBar *actionBar;
@property (nonatomic, retain) id<SZEntity> entity;

@property (strong, nonatomic) UserInfoFormViewController *userInfoFormVC;
@end

@implementation ExchangeViewController

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
    self.title = @"Gift Exchange";
        self.userInfoFormVC = [UserInfoFormViewController new];
    
    
    // Create request for user's facebook data
    NSString *requestPath = @"me?fields=name,gender,birthday,email";
    
    // Send request to facebook
    PF_FBRequest *request = [PF_FBRequest requestForGraphPath:requestPath];

    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            
            
            self.userInfoFormVC.userData = (NSDictionary *)result; // The result is a dictionary
            
            
            self.userInfoFormVC.imageData = [[NSMutableData alloc] init]; // the image will be loaded in here
            
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.userInfoFormVC.userData objectForKey:@"id"]]];
            NSLog(@"profilePictureURl = %@",profilePictureURL);
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
            NSLog(@"profilePictureURLRequest = %@", profilePictureURLRequest);
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self.userInfoFormVC];
            
            
            

            // Create URLRequest
//            NSString *pictureURL = [[[userData objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
//            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pictureURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSLog(@"%@", pictureURL);
//            // Run request asynchronously
//            [NSURLConnection connectionWithRequest:urlRequest delegate:self];
            // Now add the data to the UI elements
        }
    }];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"some_entity" name:@"Some Entity"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
    }
    self.actionBar.backgroundColor = [UIColor yellowColor];

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

- (IBAction)participateButton:(id)sender {
    
    [self.navigationController pushViewController:self.userInfoFormVC animated:YES];
}

- (IBAction)rulesButton:(id)sender {
    RulesViewController *rulesVC = [RulesViewController new];
    [self.navigationController pushViewController:rulesVC animated:YES];
}
@end
