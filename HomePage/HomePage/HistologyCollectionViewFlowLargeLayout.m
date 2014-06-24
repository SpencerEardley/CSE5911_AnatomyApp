//
//  HistologyCollectionViewFlowLargeLayout.m
//  HomePage
//
//  Created by shelton, xavier james on 6/23/14.
//  Copyright (c) 2014 TeamRocket. All rights reserved.
//


#import "HistologyCollectionViewFlowLargeLayout.h"

@implementation HistologyCollectionViewFlowLargeLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(130, 130);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 10.0f;
    
    return self;
}

@end
