//
//  WibraryViewController.m
//  Wibrary
//
//  Created by Robert Wilson on 13/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "WibraryViewController.h"
#import "WibraryConstants.h"

@interface WibraryViewController ()
{
    // a few ivars to keep track of the download
    NSOutputStream *downloadStream;
    NSURLConnection *connection;
}

@end


@implementation WibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getGOAFiles];
    [self getRosteringFiles];
}

- (void)getGOAFiles
{
    // create path to GOA folder by combining URL with folder name
    NSURL *goaPathURL =[NSURL URLWithString:DOCUMENTS_URL GOA_FOLDER];
    
    // retrieve HTML data from url
    NSData *goaHTMLData = [NSData dataWithContentsOfURL:goaPathURL];
    
    // create parser with download data
    
    [self downloadFile:GOA_FILENAME fromUrl:DOCUMENTS_URL toBeSavedInFolder:GOA_FOLDER];
}

- (void)getRosteringFiles
{
    [self downloadFile:ROSTERING_FILENAME fromUrl:DOCUMENTS_URL toBeSavedInFolder:ROSTERING_FOLDER];
}

// the revised method to initiate the download of the file

- (void)downloadFile:(NSString *)filename fromUrl:(NSString *)urlString toBeSavedInFolder:(NSString *)destinationFolder
{
    // figure out where you want to store the data
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsFolder = [paths objectAtIndex:0];  // or paths[0];
    
    // concatenate folder and file name
    NSString *folderAndFileString = [documentsFolder stringByAppendingString:destinationFolder];
    
    NSString *downloadFilePath = [folderAndFileString stringByAppendingPathComponent:filename];
    NSLog(@"fap = %@", folderAndFileString);
    NSLog(@"dlp = %@", downloadFilePath);
    
    // create the directory if we need to
    
    if (![self createFolderForPath:downloadFilePath])
        return;
    
    // create the download file stream (so we can write the file as we download it
    
    downloadStream = [NSOutputStream outputStreamToFileAtPath:downloadFilePath append:NO];
    [downloadStream open];
    
    NSURL *url            = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    connection            = [NSURLConnection connectionWithRequest:request delegate:self];
    NSAssert(connection, @"Connection creation failed");
}

// a routine to cleanup our ivars upon completion

- (void)cleanupConnectionWithMessage:(NSString *)statusString
{
    if (connection != nil) {
        [connection cancel];
        connection = nil;
    }
    if (downloadStream != nil) {
        [downloadStream close];
        downloadStream = nil;
    }
    
    if (statusString)
        NSLog(@"%s: %@", __FUNCTION__, statusString);
}

// called by NSURLConnection as data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    dataLength = [data length];
    dataBytes  = [data bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [downloadStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
//        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            [self cleanupConnectionWithMessage:@"File write error"];
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
}

// called by NSURLConnection as download is complete

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self cleanupConnectionWithMessage:@"File write succeeded"];
}

// called by NSURLConnection as download failed

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *msg = [NSString stringWithFormat:@"File download failed err = %@", error];
    [self cleanupConnectionWithMessage:msg];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
