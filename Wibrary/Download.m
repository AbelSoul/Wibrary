//
//  Download.m
//  DownloadManager
//
//  Created by Sprint on 22/11/2012.
//  Copyright (c) 2012 Sprint. All rights reserved.
//

#import "Download.h"

@interface Download () <NSURLConnectionDelegate>
{
    NSOutputStream *downloadStream;
    NSURLConnection *connection;
    NSString *tempFilename;
}
@end

@implementation Download

- (BOOL)createFolderForPath:(NSString *)filePath
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folder = [filePath stringByDeletingLastPathComponent];
    BOOL isDirectory;
    
    if (![fileManager fileExistsAtPath:folder isDirectory:&isDirectory])
    {
        // if folder doesn't exist, try to create it
        
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
        
        // if fail, report error
        
        if (error)
        {
            NSLog(@"%s folder create failed; err = %@", __FUNCTION__, error);
            return FALSE;
        }
        
        // directory successfully created
        
        return TRUE;
    }
    else if (!isDirectory)
    {
        NSLog(@"%s create directory as file of that name already exists", __FUNCTION__);
        return FALSE;
    }
    
    // directory already existed
    
    return TRUE;
}

- (void)download
{
    self.downloading = YES;
    
    tempFilename = [self pathForTemporaryFileWithPrefix:@"downloads"];
    
    // create the download file stream (so we can write the file as we download it
    
    downloadStream = [NSOutputStream outputStreamToFileAtPath:tempFilename append:NO];
    [downloadStream open];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    connection            = [NSURLConnection connectionWithRequest:request delegate:self];
    NSAssert(connection, @"Connection creation failed");
}

- (void)cleanupConnectionSuccessful:(BOOL)success
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    // clean up connection and download steam
    
    if (connection != nil)
    {
        if (!success)
            [connection cancel];
        connection = nil;
    }
    if (downloadStream != nil)
    {
        [downloadStream close];
        downloadStream = nil;
    }
    
    self.downloading = NO;
    
    // if successful, move file and clean up, otherwise just cleanup
    
    if (success)
    {
        if (![self createFolderForPath:self.filename])
            return;
        
        if ([fileManager fileExistsAtPath:self.filename])
            [fileManager removeItemAtPath:self.filename error:&error];
        
        [fileManager copyItemAtPath:tempFilename toPath:self.filename error:&error];
        [fileManager removeItemAtPath:tempFilename error:&error];
        
        [self.delegate downloadDidFinishLoading:self];
    }
    else
    {
        [fileManager removeItemAtPath:tempFilename error:&error];
        [self.delegate downloadDidFail:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSInteger       dataLength = [data length];
    const uint8_t * dataBytes  = [data bytes];
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [downloadStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            [self cleanupConnectionSuccessful:NO];
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self cleanupConnectionSuccessful:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cleanupConnectionSuccessful:NO];
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

@end