//
//  GridViewController.m
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "GridViewController.h"
#import "GridViewCell.h"
#import "DocumentService.h"

@implementation GridViewController

@synthesize gridView = _gridView;
@synthesize myDocumentViews = _myDocumentViews;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    self.myDocumentViews = [DocumentService getDocumentData];
    
    [self.view addSubview:_gridView];
    [self.gridView reloadData];
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
    return [_myDocumentViews count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    GridViewCell * cell = (GridViewCell *)[aGridView dequeueReusableCellWithIdentifier:@"PlainCellIdentifier"];
    if ( cell == nil )
    {
        cell = [[GridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 160, 123)
                                   reuseIdentifier: PlainCellIdentifier];
    }
    DocumentService *service = [_myDocumentViews objectAtIndex:index];
    
    [cell.imageView setImage:service.image];
    [cell.captionLabel setText:service.caption];
    return cell;
}

@end
