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
#import "DetailViewController.h"
#import "AQGridView.h"

@implementation GridViewController

@synthesize gridView = _gridView;
@synthesize myDocumentViews = _myDocumentViews;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(16, 140, 688, 872)];
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
        cell = [[GridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 80, 192)
                                   reuseIdentifier: PlainCellIdentifier];
    }
    DocumentService *service = [_myDocumentViews objectAtIndex:index];
    
    [cell.imageView setImage:service.image];
    [cell.captionLabel setText:service.caption];
    return cell;
}

// sets grid position constraints
- (CGSize)portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(125, 131) );
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detail = segue.destinationViewController;
    
    DocumentService *service = [_myDocumentViews objectAtIndex:[_gridView indexOfSelectedItem]];
    
    detail.service = service;
}

@end
