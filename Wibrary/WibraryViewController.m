//
//  WibraryViewController.m
//  Wibrary
//
//  Created by Robert Wilson on 13/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//
#import "WibraryViewController.h"
#import "WibraryConstants.h"
#import "DownloadManager.h"

@interface WibraryViewController () <DownloadManagerDelegateProtocol>
{
    // a few ivars to keep track of the download
//    NSOutputStream *downloadStream;
//    NSURLConnection *connection;
    
    DownloadManager *downloadManager;
}
@end

@implementation WibraryViewController

@synthesize docManagerButton = _docManagerButton;
@synthesize activityIndicator = _activityIndicator ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self alertOKCancelAction];
    [activityIndicatorView startAnimating];
    
    // call method to log into server
    [self loginToServer];
    
    // call methods to retrieve documents
    
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFinishLoading:(Download *)download;
{
    // You can now do whatever you want as the download manager informs you as
    // the individual downloads are completed, for example:
    //
    // [self.tableView reloadData];
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;
{
    // You can now do whatever you want as the download manager informs you as
    // the individual downloads are have failed, for example:
    //
    // NSLog(@"Download of %@ failed", download.filename);
    // [self.tableView reloadData];
}

- (void)alertOKCancelAction {
    
    // display login panel alert view with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                    message:@"Enter login details"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Done", nil];
    // Display two line alert view
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
//    alert.tag = kAlertTypeSetup;
    UITextField *nameField = [alert textFieldAtIndex:0];
    nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    nameField.placeholder = @"Name"; // Replace the standard placeholder text with something more applicable
//    nameField.delegate = self;
//    nameField.tag = kTextFieldName;
    UITextField *passwordField = [alert textFieldAtIndex:1]; // Capture the Password text field since there are 2 fields
//    passwordField.delegate = self;
//    passwordField.tag = kTextFieldPassword;

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1  ) { // User selected "Done"
        NSLog(@"Done selected");
    } else { // User selected "Cancel"
        [self alertOKCancelAction];
    }
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
      // the user clicked one of the OK/Cancel buttons
      if (buttonIndex == 0)
      {
          NSLog(@"OK");
                
      }
      else
      {
          NSLog(@"cancel");
      }
}

- (void)loginToServer
{
    // try connecting to server
    NSString *userName = @"test";
    NSString *passWord = @"test";
    NSString *post = [NSString stringWithFormat:@"userName=%@&password=%@", userName, passWord];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *serverURLString = SERVER_LOGIN_URL_STRING;
    NSURL *serverURL = [NSURL URLWithString:serverURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];

    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"result = %@", responseString);
    // ^ end try connecting to server ^
    
    // split response string to remove xml nodes
    NSArray *lines = [responseString componentsSeparatedByString: @"\n"];
    NSString *sessionID = lines[2];
    NSLog(@"the session id is = %@", sessionID);

    // call method to create file for sending to server to compare files
    [self checkFiles:sessionID];
}


- (void)checkFiles:(NSString *)sessionID
{
    NSLog(@"passed sesh id = \n%@", sessionID);
    // try connecting to server
    NSMutableString *fileList = [[NSMutableString alloc] init];
    
    // get contents of app doc directory
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [directoryPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSLog(@"contents of app's document folder = %@", directoryContent);
    
    // create strings to sub folders
    NSString *myAppendicesFolder = [documentsDirectory stringByAppendingPathComponent:APPENDICES_FOLDER];
    NSString *myDiagramsFolder = [documentsDirectory stringByAppendingPathComponent:DIAGRAMS_FOLDER];
    NSString *myGoaFolder = [documentsDirectory stringByAppendingPathComponent:GOA_FOLDER];
    NSString *myNoticesMonsFolder = [documentsDirectory stringByAppendingPathComponent:NOTICES_MONS_FOLDER];
    NSString *myNoticesPonsFolder = [documentsDirectory stringByAppendingPathComponent:NOTICES_PONS_FOLDER];
    NSString *myNoticesUonsFolder = [documentsDirectory stringByAppendingPathComponent:NOTICES_UONS_FOLDER];
    NSString *myNoticesWonsFolder = [documentsDirectory stringByAppendingPathComponent:NOTICES_WONS_FOLDER];
    NSString *myPinkFolder = [documentsDirectory stringByAppendingPathComponent:PINK_PAGES_FOLDER];
    NSString *myRosteringFolder = [documentsDirectory stringByAppendingPathComponent:ROSTERING_FOLDER];
    NSString *myRuleBookFolder = [documentsDirectory stringByAppendingPathComponent:RULE_BOOK_FOLDER];
    NSString *myManualFolder = [documentsDirectory stringByAppendingPathComponent:WORKING_MANUAL_FOLDER];
    
    // create arrays of sub folder contents
    NSArray *appendixContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myAppendicesFolder error:&error];
    NSArray *diagramsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myDiagramsFolder error:&error];
    NSArray *goaContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myGoaFolder error:&error];
    NSArray *monsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myNoticesMonsFolder error:&error];
    NSArray *ponsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myNoticesPonsFolder error:&error];
    NSArray *uonsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myNoticesUonsFolder error:&error];
    NSArray *wonsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myNoticesWonsFolder error:&error];
    NSArray *pinkContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myPinkFolder error:&error];
    NSArray *rosteringContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myRosteringFolder error:&error];
    NSArray *rulesContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myRuleBookFolder error:&error];
    NSArray *manualContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myManualFolder error:&error];

    // add file names to string to be sent to server
    for (NSString *appendixFile in appendixContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  appendixFile]];
    }
    for (NSString *diagramsFile in diagramsContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  diagramsFile]];
    }
    for (NSString *goaFile in goaContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  goaFile]];
    }
    for (NSString *monsFile in monsContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  monsFile]];
    }
    for (NSString *ponsFile in ponsContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  ponsFile]];
    }
    for (NSString *uonsFile in uonsContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  uonsFile]];
    }
    for (NSString *wonsFile in wonsContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  wonsFile]];
    }
    for (NSString *pinkFile in pinkContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  pinkFile]];
    }
    for (NSString *rosterFile in rosteringContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  rosterFile]];
    }
    for (NSString *rulesFile in rulesContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  rulesFile]];
    }
    for (NSString *manualFile in manualContents)
    {
        [fileList appendString:[NSString stringWithFormat:@"%@,",  manualFile]];
    }

    // send string of iPad file names to server
    NSString *post = [NSString stringWithFormat:@"sessionID=%@&fileList=%@", sessionID, fileList];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString *comparisonURLString = SERVER_COMPARE_URL_STRING;
    NSURL *comparisonURL = [NSURL URLWithString:comparisonURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:comparisonURL];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    // get response - list of files for download
    NSHTTPURLResponse *urlResponse = nil;
    error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *requiredFilesList = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // ^ end try connecting to server ^
    
    // remove xml nodes from list
    NSArray *lines = [requiredFilesList componentsSeparatedByString: @"\n"];
//    NSString *line1 = lines[0];
//    NSString *line2 = lines[1];
//    NSString *line3 = lines[2];
//    NSString *lastLine = lines.lastObject;
//    NSLog(@"the first 3 lines are = \n%@\n%@\n%@", line1, line2, line3);
//    NSLog(@"last line = \n%@", lastLine);
    
    // create sub array without xml nodes
    NSRange theRange;
    theRange.location = 2;
    theRange.length = [lines count] -3;
    NSArray *subArray = [lines subarrayWithRange:theRange];
    
//    NSLog(@"CHECK FILES RESULT = %@", subArray);
    
    [self getFiles:subArray];
}

- (void)getFiles:(NSArray *)filenames
{
    downloadManager = [[DownloadManager alloc] init];
    downloadManager.delegate = self;
    
    NSLog(@"list for dl: %@", filenames);
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
    NSLog(@"dl folder = %@", downloadFolder); // not being created?
    for (NSString *filename in filenames)
    {
        NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:filename];
        NSString *baseUrlString = SERVER_DOWNLOAD_URL_STRING;
        NSString *finalUrlString = [baseUrlString stringByAppendingPathComponent:[filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [downloadManager addDownload:downloadFilename fromUrl:[NSURL URLWithString:finalUrlString] ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
