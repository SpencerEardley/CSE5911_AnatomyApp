//
//  Gross3DModelViewController.m
//  HomePage
//
//  Created by lutz, bryan jeffrey on 6/9/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import "Gross3DModelViewController.h"

@interface Gross3DModelViewController ()
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation Gross3DModelViewController

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

// Create navigation sidebar
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"videos"],
                        [UIImage imageNamed:@"3D Models"],
                        [UIImage imageNamed:@"Index"],
                        [UIImage imageNamed:@"Letter G"],
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
    
    //Videos clicked
    if (index == 0) {
        [self performSegueWithIdentifier:@"Gross3DToGrossVideosSegue" sender:self];
    }
    
    //3D Models clicked
    else if (index == 1) {
        //Do nothing
    }
    
    //Index clicked
    else if (index == 2) {
        [self performSegueWithIdentifier:@"Gross3DModelsToGrossIndexSegue" sender:self];
    }
    
    //Gross Home clicked
    else if (index == 3) {
        [self performSegueWithIdentifier:@"Gross3DToGrossHomeSegue" sender:self];
    }
    
    //Home clicked
    else if (index == 4) {
        [self performSegueWithIdentifier:@"Gross3DToHomeSegue" sender:self];
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
