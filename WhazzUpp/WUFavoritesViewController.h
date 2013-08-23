//
//  WUFavoritesViewController.h
//  WhazzUpp
//
//  Created by Michael Knecht on 03.06.13.
//  Copyright (c) 2013 C2Call GmbH. All rights reserved.
//

#import <SocialCommunication/SocialCommunication.h>

@interface WUFavoritesCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel     *nameLabel, *statusLabel, *onlineLabel;

@end

@interface WUFavoritesViewController : SCDataTableViewController

-(IBAction)toggleEditing:(id)sender;

@end
