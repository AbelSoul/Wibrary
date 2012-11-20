//
//  DetailViewController.h
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentService.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) UIWebView* documentWebView;

@property (nonatomic, retain) DocumentService *service;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *articleImageView;
@property (nonatomic, strong) UILabel* metaLabel;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIWebView* articleWebView;
@property (nonatomic, strong) UIScrollView* scrollView;

@end
