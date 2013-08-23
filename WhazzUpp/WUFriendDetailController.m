//
//  WUFriendDetailController.m
//  WhazzUpp
//
//  Created by Michael Knecht on 03.06.13.
//  Copyright (c) 2013 C2Call GmbH. All rights reserved.
//

#import "WUFriendDetailController.h"
#import "WUChatController.h"

#import <SocialCommunication/UIViewController+SCCustomViewController.h>

@interface WUFriendDetailController ()

@end

@implementation WUFriendDetailController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)chat:(id)sender
{
    int idx = [self.navigationController.viewControllers indexOfObject:self];
    if (idx != NSNotFound && idx > 0) {
        UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:idx - 1];
        if ([previousController isKindOfClass:[WUChatController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    MOC2CallUser *user = [self currentUser];
    [self showChatForUserid:user.userid];
}

@end
