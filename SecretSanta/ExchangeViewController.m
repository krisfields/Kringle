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


@interface ExchangeViewController () </*PF_FBRequestDelegate, */UITextFieldDelegate>
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
    
        
}
- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:@"http://www.kringleapp.com" name:@"1st Annual Secret Santa Gift Exchange"];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        SZActionButton *userSettings = [SZActionButton actionButtonWithIcon:nil title:@"All about you"];
        userSettings.actionBlock = ^(SZActionButton *button, SZActionBar *bar) {
            [self.navigationController pushViewController:self.userInfoFormVC animated:YES];
        };
        self.actionBar.itemsLeft = [NSArray arrayWithObject:userSettings];
        
    }
    self.actionBar.backgroundImage = [UIImage new];
    self.actionBar.backgroundColor = [UIColor colorWithRed:.75 green:.81568 blue:.651 alpha:.8];
     

}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
