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
        
        // cell dimensions
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 72, 76)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        
        // 
//        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 15, 72, 74)];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 15, 72, 74)];
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, 104, 35)];
        [_captionLabel setFont:[UIFont systemFontOfSize:14]];
        [_captionLabel setBackgroundColor:[UIColor clearColor]];
        [_captionLabel setTextColor:[UIColor whiteColor]];
        
        [mainView addSubview:_imageView];
        
        // add book shelf line image
        UIImageView *shelfImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, 152, 8)];
        [shelfImageView setImage:[UIImage imageNamed:@"gbr-bookshelf-line.png"]];
        
        // add views to main view
        [mainView addSubview:_captionLabel];
        [mainView addSubview:shelfImageView];
        [self.contentView addSubview:mainView];
    }
    return self;
}

@end
