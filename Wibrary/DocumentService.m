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
    NSLog(@"doc dir = %@", documentsDirectory);
    
    NSError *error = nil;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSLog(@"contents = %@", directoryContent);
    
    // create string to diagrams folder in 1 of 2 ways. This way:
//    NSString *diagramsFolder = [documentsDirectory stringByAppendingPathComponent:(NSString *)[directoryContent objectAtIndex:1]];
    
    // or this way:
    NSString *diagramsFolder = [documentsDirectory stringByAppendingPathComponent:@"Rostering"];
    NSLog(@"diagrms at: %@", diagramsFolder);
    
    NSArray *diagramsFolderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:diagramsFolder error:&error];
    NSLog(@"contetns of diagrams: %@", diagramsFolderContents);
    
    NSString *docPath;
    
    for (docPath in diagramsFolderContents)
    {
        // retrieve the filename
        NSString *theFileName = [docPath stringByDeletingPathExtension];
        NSString *extensionType = [docPath pathExtension];
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
            NSMutableString *folderURLString = [NSMutableString stringWithString:diagramsFolder];
            [folderURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [folderURLString length])];
            
            // then remove spaces from document name string
            NSMutableString *fileNameURLString = [NSMutableString stringWithString:docPath];
            [fileNameURLString replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileNameURLString length])];
            
            // concatenate folder and document strings
            NSString *fullPathURLString = [folderURLString stringByAppendingString: fileNameURLString];
            NSLog(@"fps: %@", fullPathURLString);
            
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
            NSLog(@"req obj: %@", requestObject);

            [documentData addObject:diagramsIcon];
        }
    }
    return documentData;
}

@end
