//
//  ComeBackSoonViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/12/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "ComeBackSoonViewController.h"
#import <Socialize/Socialize.h>
#import "UserInfoFormViewController.h"
#import "SplashViewController.h"

@interface ComeBackSoonViewController ()

@property (nonatomic, strong) SZActionBar *actionBar;
@property (nonatomic, strong) id<SZEntity> entity;
@property (nonatomic, strong) UserInfoFormViewController *userInfoFormVC;
@end

@implementation ComeBackSoonViewController

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
    self.userInfoFormVC = [UserInfoFormViewController new];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"http://www.kringleapp.com" name:@"1st Annual Secret Santa Gift Exchange"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        SZActionButton *userSettings = [SZActionButton actionButtonWithIcon:nil title:@"All about you"];
        userSettings.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
            NSLog(@"userSettings button pressed");
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.userInfoFormVC];
            [self presentModalViewController:navController animated:YES];
        };
        SZActionButton *letsPretend = [SZActionButton actionButtonWithIcon:nil title:@"<<"];
        letsPretend.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
            SplashViewController *splashVC = [SplashViewController new];
            splashVC.dateString = @"11/11/2011";
            [self presentModalViewController:splashVC animated:YES];
        };
        self.actionBar.itemsLeft = [NSArray arrayWithObjects:userSettings, letsPretend, nil];
        
    }
    self.actionBar.backgroundImage = [UIImage new];
    self.actionBar.backgroundColor = [UIColor colorWithRed:.75 green:.651 blue:.81568 alpha:.8];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
