//
//  DownloadManager.m
//  Wibrary
//
//  Created by Sprint on 22/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "DownloadManager.h"
#import "Download.h"

@interface DownloadManager () <DownloadDelegateProtocol>

@end

@implementation DownloadManager

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _downloads = [[NSMutableArray alloc] init];
        _maxConcurrentDownloads = 4;
    }
    
    return self;
}

- (void)addDownload:(NSString *)filename fromUrl:(NSURL *)url
{
    Download *download = [[Download alloc] init];
    download.filename = filename;
    download.url = url;
    download.delegate = self;
    
    [self.downloads addObject:download];
    
    [self tryDownloading];
}

- (void)downloadDidFinishLoading:(Download *)download
{
    [self.downloads removeObject:download];
    [self tryDownloading];
    [self.delegate downloadManager:self downloadDidFinishLoading:download];
}

- (void)downloadDidFail:(Download *)download
{
    [self.downloads removeObject:download];
    [self tryDownloading];
    [self.delegate downloadManager:self downloadDidFail:download];
}

- (void)tryDownloading
{
    NSInteger activeDownloads = [self countActiveDownloads];
    NSInteger awaitingDownloads = self.downloads.count - activeDownloads;
    
    if (awaitingDownloads > 0 && activeDownloads < self.maxConcurrentDownloads)
    {
        for (Download *download in self.downloads)
        {
            if (!download.downloading)
            {
                [download download];
                return;
            }
        }
    }
}

- (NSInteger)countActiveDownloads
{
    NSInteger activeDownloadCount = 0;
    
    for (Download *download in self.downloads)
    {
        if (download.downloading)
            activeDownloadCount++;
    }
    
    return activeDownloadCount;
}

@end
