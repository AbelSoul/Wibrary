//
//  Download.h
//  Wibrary
//
//  Created by Sprint on 22/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Download;

@protocol DownloadDelegateProtocol <NSObject>

- (void)downloadDidFinishLoading:(Download *)download;
- (void)downloadDidFail:(Download *)download;

@end

@interface Download : NSObject <NSURLConnectionDelegate>

@property (nonatomic, copy)NSString *filename;
@property (nonatomic, copy)NSURL *url;
@property BOOL downloading;

@property (nonatomic, weak) id<DownloadDelegateProtocol> delegate;

- (void)download;

@end
