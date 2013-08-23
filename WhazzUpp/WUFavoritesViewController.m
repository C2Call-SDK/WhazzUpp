//
//  WUFavoritesViewController.m
//  WhazzUpp
//
//  Created by Michael Knecht on 03.06.13.
//  Copyright (c) 2013 C2Call GmbH. All rights reserved.
//

#import "WUFavoritesViewController.h"
#import <SocialCommunication/UIViewController+SCCustomViewController.h>
#import <SocialCommunication/debug.h>

@implementation WUFavoritesCell

@synthesize nameLabel, statusLabel, onlineLabel;

@end

@interface WUFavoritesViewController () {
    CGFloat     favoritesCellHeight;
}

@end

@implementation WUFavoritesViewController

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
    self.cellIdentifier = @"WUFavoritesCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    favoritesCellHeight = cell.frame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark fetchRequest

-(NSFetchRequest *) fetchRequest
{
    return [[SCDataManager instance] fetchRequestForFriendlist:YES];
}

#pragma mark Configure Cell

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return favoritesCellHeight;
}

-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MOC2CallUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[WUFavoritesCell class]]) {
        WUFavoritesCell *favocell = (WUFavoritesCell *) cell;
        favocell.nameLabel.text = [[C2CallPhone currentPhone] nameForUserid:user.userid];
        favocell.statusLabel.text = @"Hi there, I'm using WhazzUpp!";
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"didSelectRowAtIndexPath : %d / %d", indexPath.section, indexPath.row);
    
    MOC2CallUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    [self showChatForUserid:user.userid];
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"accessoryButtonTappedForRowWithIndexPath : %d / %d", indexPath.section, indexPath.row);
    
    MOC2CallUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([user.userType intValue] == 2) {
        [self showGroupDetailForGroupid:user.userid];
    } else {
        [self showFriendDetailForUserid:user.userid];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MOC2CallUser *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[SCDataManager instance] removeDatabaseObject:user];
    }
}

-(IBAction)toggleEditing:(id)sender
{
    if (self.tableView.editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing:)];
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

#pragma mark SearchDisplayController Delegate

-(void) refetchResults
{
    [self.fetchedResultsController performFetch:nil];
}

-(void) setTextFilterForText:(NSString *) text
{
    NSFetchRequest *fetch = [self.fetchedResultsController fetchRequest];
    
    NSPredicate *textFilter = [NSPredicate predicateWithFormat:@"displayName contains[cd] %@ OR email contains[cd] %@", text, text];
   [fetch setPredicate:textFilter];
}

-(void) removeTextFilter
{
    NSFetchRequest *fetch = [self.fetchedResultsController fetchRequest];
    [fetch setPredicate:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self setTextFilterForText:searchString];
    [self refetchResults];
    
    // Return NO, as the search will be done in the background
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self setTextFilterForText:[self.searchDisplayController.searchBar text]];
    [self refetchResults];
    
    // Return NO, as the search will be done in the background
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    DLog(@"searchDisplayControllerDidBeginSearch");
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    DLog(@"searchDisplayControllerDidEndSearch");
    [self removeTextFilter];
    [self refetchResults];
    
    
    return;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)_tableView
{
}



@end
