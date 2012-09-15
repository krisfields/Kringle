//
//  DrawNameViewController.m
//  SecretSanta
//
//  Created by Kris Fields on 9/10/12.
//  Copyright (c) 2012 Kris Fields. All rights reserved.
//

#import "DrawNameViewController.h"
#import <Parse/Parse.h>
#import "GifteeViewController.h"

@interface DrawNameViewController ()
- (IBAction)drawNameButton:(id)sender;

@end

@implementation DrawNameViewController

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
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)drawNameButton:(id)sender {
    [self setUsersInExchangeGivingToAndReceivingFromToNull];
    //use this in testing
//    [self testDrawNameMethod];
    //use this in production
    [self drawName:[PFUser currentUser]];
}
- (void)drawName:(PFUser *)personDrawing
{
    PFQuery *query = [PFQuery queryWithClassName:@"UsersInExchange"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSLog(@"objects not in order = %@", objects);
        //find the correct object in objects using objectId
        [query whereKey:@"user" equalTo:personDrawing];
        NSArray *currentUserAsOnlyObjectInArray = [query findObjects];
        PFObject *currentUserInExchange = [currentUserAsOnlyObjectInArray objectAtIndex:0];
        NSString *currentUserInExchangeObjectId = [currentUserInExchange objectId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", currentUserInExchangeObjectId];
        PFObject *userInExchange = [[objects filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    
        
        NSArray *newObjects = [objects sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            return [[obj1 valueForKey:@"objectId"] compare:[obj2 valueForKey:@"objectId"]];
           
        }];

        //now find it in newObjects, and note it's index
        NSLog(@"objects in order = %@", newObjects);
        int indexOfCurrentUserInNewObjects = [newObjects indexOfObject:userInExchange];

        PFUser *userToGiveTo;
        if (indexOfCurrentUserInNewObjects == 0) {
            userToGiveTo = [[newObjects objectAtIndex:[newObjects count] -1] valueForKey:@"user"];
        } else {
            userToGiveTo = [[newObjects objectAtIndex:indexOfCurrentUserInNewObjects -1] valueForKey:@"user"];
        }
        [currentUserInExchange setObject:userToGiveTo forKey:@"givingTo"];
        [currentUserInExchange save];
        GifteeViewController *gifteeVC = [GifteeViewController new];
        [self presentModalViewController:gifteeVC animated:YES];
        
    }];
}

-(void) testDrawNameMethod {
    PFQuery *query = [PFQuery queryWithClassName:@"UsersInExchange"];
    NSArray *objectsFromQuery = [query findObjects];
    NSArray *objects = [self shuffleArray:objectsFromQuery];
    
    for (PFObject * object in objects) {
        PFUser *personDrawing = [object valueForKey:@"user"];
        [self drawName:personDrawing];
    }
}
- (NSArray*)shuffleArray:(NSArray*)array {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
}
//for testing only - set fields back to null
-(void)setUsersInExchangeGivingToAndReceivingFromToNull
{
    PFQuery *query = [PFQuery queryWithClassName:@"UsersInExchange"];
    NSArray *objects = [query findObjects];
    for (PFObject *object in objects) {
        [object setObject:[NSNull null] forKey:@"receivingFrom"];
        [object setObject:[NSNull null] forKey:@"givingTo"];
        [object save];
    }
}
@end
