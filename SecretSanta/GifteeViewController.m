//
//  GifteeViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/10/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "GifteeViewController.h"
#import <Parse/Parse.h>

@interface GifteeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gifteeName;
@property (weak, nonatomic) IBOutlet UIImageView *gifteeImage;
@property (weak, nonatomic) IBOutlet UILabel *gifteeAge;
@property (weak, nonatomic) IBOutlet UILabel *gifteeGender;
@property (weak, nonatomic) IBOutlet UILabel *gifteeLike1;
@property (weak, nonatomic) IBOutlet UILabel *gifteeLike2;
@property (weak, nonatomic) IBOutlet UILabel *gifteeLike3;
@property (weak, nonatomic) IBOutlet UILabel *gifteeLike4;
@property (weak, nonatomic) IBOutlet UILabel *gifteeLike5;
@property (weak, nonatomic) IBOutlet UITextView *gifteeStalk1;

@property (weak, nonatomic) IBOutlet UITextView *gifteeStalk2;
@property (weak, nonatomic) IBOutlet UITextView *gifteeStalk3;
@property (weak, nonatomic) IBOutlet UITextView *gifteeStalk4;
@property (weak, nonatomic) IBOutlet UILabel *gifteeStreetAddress;
@property (weak, nonatomic) IBOutlet UILabel *gifteeCity;
@property (weak, nonatomic) IBOutlet UILabel *gifteeState;
@property (weak, nonatomic) IBOutlet UILabel *gifteeZip;
@property (weak, nonatomic) IBOutlet UILabel *gifteeCountry;
- (IBAction)markAsSentButton:(id)sender;

@end

@implementation GifteeViewController
@synthesize gifteeName;
@synthesize gifteeImage;
@synthesize gifteeAge;
@synthesize gifteeGender;
@synthesize gifteeLike1;
@synthesize gifteeLike2;
@synthesize gifteeLike3;
@synthesize gifteeLike4;
@synthesize gifteeLike5;
@synthesize gifteeStalk1;
@synthesize gifteeStalk2;
@synthesize gifteeStalk3;
@synthesize gifteeStalk4;
@synthesize gifteeStreetAddress;
@synthesize gifteeCity;
@synthesize gifteeState;
@synthesize gifteeZip;
@synthesize gifteeCountry;

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
    PFQuery *query = [PFQuery queryWithClassName:@"UsersInExchange"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *currentUserInExchange = [query getFirstObject];
    NSString *gifteeId = [[currentUserInExchange valueForKey:@"givingTo"] objectId];
    PFUser *giftee = [PFQuery getUserObjectWithId:gifteeId];
    [self setGifteeAttributes:giftee];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (void) setGifteeAttributes:(PFUser *)giftee {
    self.gifteeName.text = [giftee valueForKey:@
                            "name"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthdate = [dateFormat dateFromString:[giftee valueForKey:@"birthday"]];
    self.gifteeAge.text = [NSString stringWithFormat:@"%d", [self calculateAgeFromDate:birthdate]];
    self.gifteeStreetAddress.text = [giftee valueForKey:@"streetAddress"];
    self.gifteeGender.text = [giftee valueForKey:@"gender"];
    self.gifteeCity.text = [giftee valueForKey:@"city"];
    self.gifteeState.text = [giftee valueForKey:@"state"];
    self.gifteeZip.text = [giftee valueForKey:@"zip"];
    self.gifteeCountry.text = [giftee valueForKey:@"country"];
    self.gifteeLike1.text = [giftee valueForKey:@"userLike1"];
    self.gifteeLike2.text = [giftee valueForKey:@"userLike2"];
    self.gifteeLike3.text = [giftee valueForKey:@"userLike3"];
    self.gifteeLike4.text = [giftee valueForKey:@"userLike4"];
    self.gifteeLike5.text = [giftee valueForKey:@"userLike5"];
    self.gifteeStalk1.text = [giftee valueForKey:@"userStalkMe1"];
    self.gifteeStalk2.text = [giftee valueForKey:@"userStalkMe2"];
    self.gifteeStalk3.text = [giftee valueForKey:@"userStalkMe3"];
    self.gifteeStalk4.text = [giftee valueForKey:@"userStalkMe4"];
    self.gifteeImage.image = [UIImage imageNamed:@"sad_tree.jpeg"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        PFFile *theImage = [giftee objectForKey:@"image"];
        NSData *imageData = [theImage getData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifteeImage.image = [UIImage imageWithData:imageData];
        });
    });
}
- (int)calculateAgeFromDate:(NSDate *)dateOfBirth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        
    } else {
        
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}
- (void)viewDidUnload
{
    [self setGifteeImage:nil];
    [self setGifteeAge:nil];
    [self setGifteeGender:nil];
    [self setGifteeLike1:nil];
    [self setGifteeLike2:nil];
    [self setGifteeLike3:nil];
    [self setGifteeLike4:nil];
    [self setGifteeLike5:nil];
    [self setGifteeStalk1:nil];
    [self setGifteeStalk2:nil];
    [self setGifteeStalk3:nil];
    [self setGifteeStalk4:nil];
    [self setGifteeStreetAddress:nil];
    [self setGifteeCity:nil];
    [self setGifteeState:nil];
    [self setGifteeZip:nil];
    [self setGifteeCountry:nil];
    [self setGifteeName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)markAsSentButton:(id)sender {
    [self.view setNeedsDisplay];
}
@end
