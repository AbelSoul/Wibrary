//
//  GOAGridViewController.h
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface GOAGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) IBOutlet AQGridView * gridView;
@property (nonatomic, retain) NSArray * myDocumentViews;

@end
