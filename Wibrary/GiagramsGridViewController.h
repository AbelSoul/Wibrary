//
//  GiagramsGridViewController.h
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface GiagramsGridViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate>

@property (nonatomic, retain) AQGridView *gridView;
@property (nonatomic, retain) NSArray *myDocumentViews;


@end
