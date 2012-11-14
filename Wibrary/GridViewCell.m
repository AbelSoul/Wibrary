//
//  GridViewCell.m
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "GridViewCell.h"
#import "AQGridView.h"


@implementation GridViewCell

@synthesize imageView = _imageView;
@synthesize captionLabel = _captionLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier];
    if (self) {
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 123)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 4, 142, 117)];
//        [frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 18, 67, 52)];
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 72, 67, 21)];
        [mainView addSubview:_imageView];
        [mainView addSubview:frameImageView];
        [mainView addSubview:_captionLabel];
        [self.contentView addSubview:mainView];
    }
    return self;
}

@end
