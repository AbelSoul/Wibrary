//
//  PinkDetailViewController.h
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinkDocumentService.h"

@interface PinkDetailViewController : UIViewController

@property (nonatomic, strong)UIWebView *documentWebView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *articleImageView;
@property (nonatomic, strong) UILabel* metaLabel;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIWebView* articleWebView;
@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, retain) PinkDocumentService *service;


@end
