//
//  HistologyViewController.h
//  HomePage
//
//  Created by oblena, erika danielle on 5/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"

@interface HistologyViewController : UICollectionViewController

-(void)setImage:(UIImage *)image;

@property (nonatomic, retain) IBOutlet UIImageView* imageView;

@end
