//
//  EmbryoIndexViewController.m
//  HomePage
//
//  Created by oblena, erika danielle on 6/10/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "EmbryoIndexViewController.h"
#import "ExpandingCell.h"
#import "Term.h"

@interface EmbryoIndexViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation EmbryoIndexViewController
NSArray *searchResults;
NSIndexPath *globalIndexPath;
UITableView *globalTableView;
bool tableViewEIsCreated = false;

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
    // Do any additional setup after loading the view, typically from a nib.
    
    //Testing expandable cells code
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set index to -1 saying no cell is expanded or should expand.
    selectedIndex = -1;
    
    titleArray = [[NSMutableArray alloc] init];
    subtitleArray = [[NSMutableArray alloc] init];
    textArray = [[NSMutableArray alloc] init];
    
    
    
    //This declares the path to the Terms.plist where all the terms for the entire project are found
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms" ofType:@"plist"];
    
    //Iterates through entire terms list and creates array containing all the Neuroanatomy (array) terms
    NSArray *terms = [[NSArray alloc] initWithContentsOfFile:path];
    
    //Create temp array for keys
    NSMutableArray *tempNames = [[NSMutableArray alloc] init];
    NSMutableArray *tempDefs = [[NSMutableArray alloc] init];
    for (int i=0; i< 141; i++) {
        if ([terms objectAtIndex:i]!= nil) {
            NSString *check =[[terms objectAtIndex:i] objectAtIndex:1];
            if (![[[terms objectAtIndex:i] objectAtIndex:0] isEqualToString:@""] && ![[[terms objectAtIndex:i] objectAtIndex:3] isEqualToString:@""]) {
                [titleArray addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempNames addObject:[[terms objectAtIndex:i] objectAtIndex:0] ];
                [tempDefs addObject:[[terms objectAtIndex:i] objectAtIndex:3] ];
            }
        }
    }
    
    //Create Dictionary for terms and their definitions
    NSDictionary *nTerms = [[NSDictionary alloc] initWithObjects:tempDefs forKeys:tempNames];
    
    //Create alphabetical list of definition names
    NSArray * sortedKeys = [[nTerms allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    //Create alphabetical list of definitions
    NSArray * sortedValues = [nTerms objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    
    //Creates an array of all the definition names to be searched through
    titleArray = sortedKeys;
    
    //Creates an array of definition names
    subtitleArray = sortedKeys;
    
    //Creates array of definitions
    textArray = sortedValues;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return titleArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"expandingCell";
    
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // Set preselected term in the segmented control (tag 1000):
        UIView *nibView = [nib objectAtIndex:0];
        UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
        
        // in Embryo
        [segmentedControl setSelectedSegmentIndex:2];
    }
    
    
    NSString *term;
    if (indexPath.row <= titleArray.count) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            term =[searchResults objectAtIndex:indexPath.row];
            cell.titleLabel.text = [searchResults objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [searchResults objectAtIndex:indexPath.row];
            int pos = [subtitleArray indexOfObject:[searchResults objectAtIndex:indexPath.row]];
            cell.textLabel.text = [textArray objectAtIndex:pos];
        } else {
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            cell.subtitleLabel.text = [subtitleArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [textArray objectAtIndex:indexPath.row];
        }
        
    }
    
    //Formatting for definition text view
    cell.textLabel.layer.borderWidth = 2.0f;
    cell.textLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.textLabel.layer.cornerRadius = 8.0f;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:14.0];
    cell.clipsToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex == indexPath.row) {
        return 350;
    } else {
        return 38;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Access expandingCell's segmented controller
    static NSString *cellIdentifier = @"expandingCell";
    ExpandingCell *cell = (ExpandingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpandingCell"  owner:self options:nil];
    cell = [nib objectAtIndex:0];
    // Set preselected term in the segmented control (tag 1000):
    UIView *nibView = [nib objectAtIndex:0];
    UISegmentedControl *segmentedControl = (UISegmentedControl*)[nibView viewWithTag:1000];
    // Set segController to Embryo
    [segmentedControl setSelectedSegmentIndex:2];
    
    // Track indexPath and table view
    globalIndexPath = indexPath;
    globalTableView = tableView;
    tableViewEIsCreated = true;
    
    //User taps new row with none expanded
    if (selectedIndex == -1) {
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //User taps expanded row
    else if (selectedIndex == indexPath.row) {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    //User taps different row
    else if (selectedIndex != -1) {
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith [c] %@", searchText];
    searchResults = [titleArray filteredArrayUsingPredicate:resultPredicate];
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [controller.searchResultsTableView setBackgroundColor:[UIColor blackColor]];
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar
                                                                        selectedScopeButtonIndex]]];
    // close any open cells
    selectedIndex = -1;
    
    return YES;
}

// If cells have been opened, close them when starting search
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if (tableViewEIsCreated)
    {
        selectedIndex = -1;
        [globalTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:globalIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Don't let searchDisplayControllerWillBeginSearch reload globalTableView if it hasn't been established
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    tableViewEIsCreated = false;
}

// Prevent other indices from crashing if "cancel" was hit while results were being displayed
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)@""];
}

// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"Animations"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter E"],
                        [UIImage imageNamed:@"home"],
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices];
    callout.delegate = self;
    callout.showFromRight = YES;
    [callout showInViewController:self animated:YES];
}

// Set sidebar navigation
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    [sidebar dismissAnimated:YES completion:nil];
    
    //Animations clicked
    if (index == 0) {
        [self performSegueWithIdentifier:@"EmbryoIndexToEmbryoAnimationsListSegue" sender:self];
    }
    
    //Index clicked
    else if (index == 1) {
        // Do nothing
    }
    
    //Embryo Home clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"EmbryoIndexToEmbryoHomeSegue" sender:self];
    }
    
    //Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"EmbryoIndexToHomeSegue" sender:self];
    }
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

// Hide navigation bar when sidebar is open
- (void)sidebar:(RNFrostedSidebar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:NO animated:animatedYesOrNo];
}
- (void)sidebar:(RNFrostedSidebar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo {
    [self.navigationController setNavigationBarHidden:YES animated:animatedYesOrNo];
}

@end