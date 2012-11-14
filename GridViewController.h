//
//  GridViewController.h
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridView.h"

@interface GridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) IBOutlet AQGridView * gridView;
@property (nonatomic, retain) NSArray * myDocumentViews;

@end
