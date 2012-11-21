//
//  DocumentService.m
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "DocumentService.h"
#import "WibraryConstants.h"

@implementation DocumentService

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
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSLog(@"contents of app's document folder = %@", directoryContent);
    
    // create string to folder
    NSString *myFolder = [documentsDirectory stringByAppendingPathComponent:@"Rostering"];
    NSLog(@"rostering at: %@", myFolder);
    
    NSArray *folderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFolder error:&error];
    NSLog(@"contetns of rostering folder: %@", folderContents);
    
    NSString *docPath;
    
    for (docPath in folderContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
        
        // create path to file by appending file name to folder path
        NSString *myFilePath = [myFolder stringByAppendingPathComponent:theFileName];
       
        NSLog(@"my fp: %@", myFilePath);
        
        NSLog(@"filename: '%@' of extension type '%@'", theFileName, extensionType);
    
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
            NSMutableString *folderURLString = [NSMutableString stringWithString:myFolder];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            // concatenate folder and document strings
            NSString *fullPathURLString = [folderURLString stringByAppendingString: fileNameURLString];
//            NSLog(@"fps: %@", fullPathURLString);
            
            // get file attributes including modified time
            NSLog(@"doc path: %@", fullPathURLString);
           
//            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
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
            
            
            // create url to document
//            NSURL *folderURL = [NSURL URLWithString:folderURLString];            
//            NSURL *documentURLWithExtension = [NSURL fileURLWithPath:fullPathURLString];
            NSURL *documentsDirectoryURL = [NSURL URLWithString:folderURLString];
            NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:theFileName];
            NSURL *documentURLWithExtension = [documentURL URLByAppendingPathExtension:extensionType];
           
            // create URL request object
            NSURLRequest *requestObject = [NSURLRequest requestWithURL:documentURLWithExtension];
            
            // initialise document icon for display
            DocumentService *diagramsIcon = [[DocumentService alloc] initWithCaption:theFileName
                                                                            andImage:[UIImage imageNamed:iconIdentifier]
                                                                       andURLRequest:requestObject];
//            NSLog(@"req obj: %@", requestObject);

            [documentData addObject:diagramsIcon];
        }
    }
    return documentData;
}

@end
