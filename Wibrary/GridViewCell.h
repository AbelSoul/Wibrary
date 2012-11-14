//
//  GridViewCell.h
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridView.h"

@interface GridViewCell : AQGridViewCell

@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)UILabel *captionLabel;

@end
