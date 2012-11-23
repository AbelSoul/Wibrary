//
//  WibraryViewController.h
//  Wibrary
//
//  Created by Robert Wilson on 13/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WibraryViewController : UIViewController <UIAlertViewDelegate> {
    
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
}

@property (weak, nonatomic) IBOutlet UIButton *docManagerButton;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
