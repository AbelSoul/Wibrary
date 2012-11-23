//
//  DiagramsDetailViewController.m
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "DiagramsDetailViewController.h"

@interface DiagramsDetailViewController ()

@end

@implementation DiagramsDetailViewController

@synthesize documentWebView = _documentWebView;
@synthesize service = _service;
@synthesize scrollView = _scrollView;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.documentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, 768, 1024)];
    [_documentWebView loadRequest:_service.myURLRequest];
    [self.view addSubview:_documentWebView];
}

@end
