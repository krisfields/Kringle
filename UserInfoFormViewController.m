//
//  UserInfoFormViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/10/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "UserInfoFormViewController.h"
#import "ComeBackSoonViewController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface UserInfoFormViewController () <NSURLConnectionDelegate, UITextFieldDelegate> {
    UITextField *activeField;
}
- (IBAction)submitUserInfoButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userStreetAddress;
@property (weak, nonatomic) IBOutlet UITextField *userCity;
@property (weak, nonatomic) IBOutlet UITextField *userState;
@property (weak, nonatomic) IBOutlet UITextField *userZip;
@property (weak, nonatomic) IBOutlet UITextField *userCountry;
@property (weak, nonatomic) IBOutlet UIDatePicker *userAge;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userSex;
@property (weak, nonatomic) IBOutlet UITextField *userLike1;
@property (weak, nonatomic) IBOutlet UITextField *userLike2;
@property (weak, nonatomic) IBOutlet UITextField *userLike3;
@property (weak, nonatomic) IBOutlet UITextField *userLike4;
@property (weak, nonatomic) IBOutlet UITextField *userLike5;
@property (weak, nonatomic) IBOutlet UITextField *userStalkMe1;
@property (weak, nonatomic) IBOutlet UITextField *userStalkMe2;
@property (weak, nonatomic) IBOutlet UITextField *userStalkMe3;
@property (weak, nonatomic) IBOutlet UITextField *userStalkMe4;



@end

@implementation UserInfoFormViewController
@synthesize userName;
@synthesize userEmail;
@synthesize userStreetAddress;
@synthesize userCity;
@synthesize userState;
@synthesize userZip;
@synthesize userCountry;
@synthesize userAge;
@synthesize userSex;
@synthesize userLike1;
@synthesize userLike2;
@synthesize userLike3;
@synthesize userLike4;
@synthesize userLike5;
@synthesize userStalkMe1;
@synthesize userStalkMe2;
@synthesize userStalkMe3;
@synthesize userStalkMe4;

@synthesize userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerForKeyboardNotifications];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [[self castViewToScrollView] addGestureRecognizer:tapGesture];
    
    self.userImage.image = [UIImage imageWithData:self.imageData];
        self.title = @"All about you...";
    NSString *name = [self.userData objectForKey:@"name"];
    NSString *gender = [self.userData objectForKey:@"gender"];
    NSString *birthday = [self.userData objectForKey:@"birthday"];
    NSString *email = [self.userData objectForKey:@"email"];
    self.userName.text = name;
    self.userEmail.text = email;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    self.userAge.date = [df dateFromString: birthday];
    if ([gender isEqualToString:@"female"]) {
        self.userSex.selectedSegmentIndex = 0;
    } else if ([gender isEqualToString:@"male"]) {
        self.userSex.selectedSegmentIndex = 1;
    } else {
        self.userSex.selectedSegmentIndex = 2;
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)hideKeyboard
{
    [activeField resignFirstResponder];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"appending to imageData");
    [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    NSLog(@"Set image");
    self.userImage.image = [UIImage imageWithData:self.imageData];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidUnload
{
    [self setUserImage:nil];
    [self setUserName:nil];
    [self setUserEmail:nil];
    [self setUserStreetAddress:nil];
    [self setUserCity:nil];
    [self setUserState:nil];
    [self setUserZip:nil];
    [self setUserCountry:nil];
    [self setUserAge:nil];
    [self setUserSex:nil];
    
    [self setUserLike1:nil];
    [self setUserLike2:nil];
    [self setUserLike3:nil];
    [self setUserLike4:nil];
    [self setUserLike5:nil];
    [self setUserStalkMe1:nil];
    [self setUserStalkMe2:nil];
    [self setUserStalkMe3:nil];
    [self setUserStalkMe4:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)submitUserInfoButton:(id)sender {
    [activeField resignFirstResponder];
    ComeBackSoonViewController *comeBackVC = [ComeBackSoonViewController new];
    [self presentModalViewController:comeBackVC animated:YES];
    [self.navigationController pushViewController:comeBackVC animated:YES];
    PFUser *user = [PFUser currentUser];
    PFObject *exchangeUser = [PFObject objectWithClassName:@"Exchange"];
    [exchangeUser setObject:[NSNumber numberWithInt:1] forKey:@"exchangeID"];
    [exchangeUser setObject:user forKey:@"user"];
    [exchangeUser save];
    
    PFUser *hero = [PFUser currentUser];
    [hero setObject:self.userName.text forKey:@"name"];
    [hero setObject:self.userEmail.text forKey:@"email"];
    [hero setObject:self.userStreetAddress.text forKey:@"streetAddress"];
    [hero setObject:self.userCity.text forKey:@"city"];
    [hero setObject:self.userState.text forKey:@"state"];
    [hero setObject:self.userZip.text forKey:@"zip"];
    if (self.userSex.selectedSegmentIndex == 0) {
        [hero setObject:@"Female" forKey:@"sex"];
    } else if (self.userSex.selectedSegmentIndex == 1) {
        [hero setObject:@"Male" forKey:@"sex"];
    } else {
        [hero setObject:@"Robot" forKey:@"sex"];
    }
    [hero setObject:self.userLike1.text forKey:@"userLike1"];
    [hero setObject:self.userLike2.text forKey:@"userLike2"];
    [hero setObject:self.userLike3.text forKey:@"userLike3"];
    [hero setObject:self.userLike4.text forKey:@"userLike4"];
    [hero setObject:self.userLike5.text forKey:@"userLike5"];
    [hero setObject:self.userStalkMe1.text forKey:@"userStalkMe1"];
    [hero setObject:self.userStalkMe2.text forKey:@"userStalkMe2"];
    [hero setObject:self.userStalkMe3.text forKey:@"userStalkMe3"];
    [hero setObject:self.userStalkMe4.text forKey:@"userStalkMe4"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];    
    NSString *birthday = [formatter stringFromDate:self.userAge.date];
    [hero setObject:birthday forKey:@"birthday"];
    
    NSData *imageData = UIImagePNGRepresentation(self.userImage.image);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [hero setObject:imageFile forKey:@"image"];

    [hero saveInBackground];

    

    
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(UIScrollView *)castViewToScrollView
{
    return (UIScrollView *)self.view;
}
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height +60, 0.0);

    [self castViewToScrollView].contentInset = contentInsets;
    [self castViewToScrollView].scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = activeField.frame.origin;
    origin.y -= [self castViewToScrollView].contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-(aRect.size.height));
        [[self castViewToScrollView] setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [self castViewToScrollView].contentInset = contentInsets;
    [self castViewToScrollView].scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

@end
