//
//  DownloadManager.h
//  Wibrary
//
//  Created by Sprint on 22/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadManager;
@class Download;

@protocol DownloadManagerDelegateProtocol <NSObject>

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFinishLoading:(Download *)download;
- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;

@end

@interface DownloadManager : NSObject

@property (nonatomic, strong) NSMutableArray *downloads;
@property (nonatomic, weak) id<DownloadManagerDelegateProtocol> delegate;
@property NSInteger maxConcurrentDownloads;

- (void)addDownload:(NSString *)filename fromUrl:(NSURL *)url;


@end