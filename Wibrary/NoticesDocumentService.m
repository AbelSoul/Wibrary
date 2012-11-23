//
//  NoticesDocumentService.m
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "NoticesDocumentService.h"
#import "WibraryConstants.h"


@implementation NoticesDocumentService

@synthesize image = _image;
@synthesize caption = _caption;
@synthesize myURLRequest = _myURLRequest;

- (id)initWithURLRequest:(NSURLRequest *)theURLRequest
{
    self = [super init];
    if (self)
    {
        self.myURLRequest = theURLRequest;
    }
    return self;
}

-(id)initWithCaption:(NSString*)theCaption andImage:(UIImage*)theImage andURLRequest:(NSURLRequest *)theURLRequest
{
    self = [super init];
    if(self)
    {
        self.caption = theCaption;
        self.image = theImage;
        self.myURLRequest = theURLRequest;
    }
    return self;
}

+(NSArray*)getDocumentData
{
    
    NSMutableArray *documentData = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
    
    NSError *error = nil;
    //    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    //    NSLog(@"contents of app's document folder = %@", directoryContent);
    
    // create string to folder
    NSString *myFolderMons = [documentsDirectory stringByAppendingPathComponent:@"downloads/Notices/MONS"];
    NSString *myFolderPons = [documentsDirectory stringByAppendingPathComponent:@"downloads/Notices/PONS"];
    NSString *myFolderUons = [documentsDirectory stringByAppendingPathComponent:@"downloads/Notices/UONS"];
    NSString *myFolderWons = [documentsDirectory stringByAppendingPathComponent:@"downloads/Notices/WONS"];
    
    NSArray *monsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFolderMons error:&error];
    NSArray *ponsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFolderPons error:&error];
    NSArray *uonsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFolderUons error:&error];
    NSArray *wonsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFolderWons error:&error];
    
    NSString *docPath;
    
    for (docPath in monsContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
        
        // create path to file by appending file name to folder path
        NSString *myFilePath = [myFolderMons stringByAppendingPathComponent:theFileName];
        
        // assign appropriate icon to extension type
        NSString *iconIdentifier;
        if ([extensionType isEqualToString:@"doc"]) {
            iconIdentifier = DOC_ICON;
        } else if ([extensionType isEqualToString:@"pdf"]) {
            iconIdentifier = PDF_ICON;
        } else if ([extensionType isEqualToString:@"xls"]) {
            iconIdentifier = XLS_ICON;
        } else if ([extensionType isEqualToString:@"ppt"]) {
            iconIdentifier = PPT_ICON;
        } else {
            iconIdentifier = nil;
        }
        
        if (iconIdentifier) {
            
            // create readable URL by first removing spaces from folder path string
            NSMutableString *folderURLString = [NSMutableString stringWithString:myFolderMons];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            NSError *error = nil;
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:myFilePath error:&error];
            
            if (myFilePath != nil) {
                NSDate *date = (NSDate*)[attributes objectForKey: NSFileModificationDate];
                NSLog(@"Date modiifed: %@", [date description]);
            }
            else {
                NSLog(@"Not found");
                NSLog(@"err: %@", error);
            }
            
            NSURL *documentsDirectoryURL = [NSURL URLWithString:folderURLString];
            NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:theFileName];
            NSURL *documentURLWithExtension = [documentURL URLByAppendingPathExtension:extensionType];
            
            // create URL request object
            NSURLRequest *requestObject = [NSURLRequest requestWithURL:documentURLWithExtension];
            
            // initialise document icon for display
            NoticesDocumentService *diagramsIcon = [[NoticesDocumentService alloc] initWithCaption:theFileName
                                                                                  andImage:[UIImage imageNamed:iconIdentifier]
                                                                             andURLRequest:requestObject];
            
            [documentData addObject:diagramsIcon];
        }
    }
    for (docPath in ponsContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
        
        // create path to file by appending file name to folder path
        NSString *myFilePath = [myFolderPons stringByAppendingPathComponent:theFileName];
        
        // assign appropriate icon to extension type
        NSString *iconIdentifier;
        if ([extensionType isEqualToString:@"doc"]) {
            iconIdentifier = DOC_ICON;
        } else if ([extensionType isEqualToString:@"pdf"]) {
            iconIdentifier = PDF_ICON;
        } else if ([extensionType isEqualToString:@"xls"]) {
            iconIdentifier = XLS_ICON;
        } else if ([extensionType isEqualToString:@"ppt"]) {
            iconIdentifier = PPT_ICON;
        } else {
            iconIdentifier = nil;
        }
        
        if (iconIdentifier) {
            
            // create readable URL by first removing spaces from folder path string
            NSMutableString *folderURLString = [NSMutableString stringWithString:myFolderPons];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            NSError *error = nil;
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:myFilePath error:&error];
            
            if (myFilePath != nil) {
                NSDate *date = (NSDate*)[attributes objectForKey: NSFileModificationDate];
                NSLog(@"Date modiifed: %@", [date description]);
            }
            else {
                NSLog(@"Not found");
                NSLog(@"err: %@", error);
            }
            
            NSURL *documentsDirectoryURL = [NSURL URLWithString:folderURLString];
            NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:theFileName];
            NSURL *documentURLWithExtension = [documentURL URLByAppendingPathExtension:extensionType];
            
            // create URL request object
            NSURLRequest *requestObject = [NSURLRequest requestWithURL:documentURLWithExtension];
            
            // initialise document icon for display
            NoticesDocumentService *diagramsIcon = [[NoticesDocumentService alloc] initWithCaption:theFileName
                                                                                          andImage:[UIImage imageNamed:iconIdentifier]
                                                                                     andURLRequest:requestObject];
            
            [documentData addObject:diagramsIcon];
        }
    }
    for (docPath in uonsContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
        
        // create path to file by appending file name to folder path
        NSString *myFilePath = [myFolderUons stringByAppendingPathComponent:theFileName];
        
        // assign appropriate icon to extension type
        NSString *iconIdentifier;
        if ([extensionType isEqualToString:@"doc"]) {
            iconIdentifier = DOC_ICON;
        } else if ([extensionType isEqualToString:@"pdf"]) {
            iconIdentifier = PDF_ICON;
        } else if ([extensionType isEqualToString:@"xls"]) {
            iconIdentifier = XLS_ICON;
        } else if ([extensionType isEqualToString:@"ppt"]) {
            iconIdentifier = PPT_ICON;
        } else {
            iconIdentifier = nil;
        }
        
        if (iconIdentifier) {
            
            // create readable URL by first removing spaces from folder path string
            NSMutableString *folderURLString = [NSMutableString stringWithString:myFolderUons];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            NSError *error = nil;
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:myFilePath error:&error];
            
            if (myFilePath != nil) {
                NSDate *date = (NSDate*)[attributes objectForKey: NSFileModificationDate];
                NSLog(@"Date modiifed: %@", [date description]);
            }
            else {
                NSLog(@"Not found");
                NSLog(@"err: %@", error);
            }
            
            NSURL *documentsDirectoryURL = [NSURL URLWithString:folderURLString];
            NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:theFileName];
            NSURL *documentURLWithExtension = [documentURL URLByAppendingPathExtension:extensionType];
            
            // create URL request object
            NSURLRequest *requestObject = [NSURLRequest requestWithURL:documentURLWithExtension];
            
            // initialise document icon for display
            NoticesDocumentService *diagramsIcon = [[NoticesDocumentService alloc] initWithCaption:theFileName
                                                                                          andImage:[UIImage imageNamed:iconIdentifier]
                                                                                     andURLRequest:requestObject];
            
            [documentData addObject:diagramsIcon];
        }
    }
    for (docPath in wonsContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
        
        // create path to file by appending file name to folder path
        NSString *myFilePath = [myFolderWons stringByAppendingPathComponent:theFileName];
        
        // assign appropriate icon to extension type
        NSString *iconIdentifier;
        if ([extensionType isEqualToString:@"doc"]) {
            iconIdentifier = DOC_ICON;
        } else if ([extensionType isEqualToString:@"pdf"]) {
            iconIdentifier = PDF_ICON;
        } else if ([extensionType isEqualToString:@"xls"]) {
            iconIdentifier = XLS_ICON;
        } else if ([extensionType isEqualToString:@"ppt"]) {
            iconIdentifier = PPT_ICON;
        } else {
            iconIdentifier = nil;
        }
        
        if (iconIdentifier) {
            
            // create readable URL by first removing spaces from folder path string
            NSMutableString *folderURLString = [NSMutableString stringWithString:myFolderWons];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            NSError *error = nil;
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:myFilePath error:&error];
            
            if (myFilePath != nil) {
                NSDate *date = (NSDate*)[attributes objectForKey: NSFileModificationDate];
                NSLog(@"Date modiifed: %@", [date description]);
            }
            else {
                NSLog(@"Not found");
                NSLog(@"err: %@", error);
            }
            
            NSURL *documentsDirectoryURL = [NSURL URLWithString:folderURLString];
            NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:theFileName];
            NSURL *documentURLWithExtension = [documentURL URLByAppendingPathExtension:extensionType];
            
            // create URL request object
            NSURLRequest *requestObject = [NSURLRequest requestWithURL:documentURLWithExtension];
            
            // initialise document icon for display
            NoticesDocumentService *diagramsIcon = [[NoticesDocumentService alloc] initWithCaption:theFileName
                                                                                          andImage:[UIImage imageNamed:iconIdentifier]
                                                                                     andURLRequest:requestObject];
            
            [documentData addObject:diagramsIcon];
        }
    }
    return documentData;
}


@end
