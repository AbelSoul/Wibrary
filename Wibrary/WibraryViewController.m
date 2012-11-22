//
//  WibraryViewController.m
//  Wibrary
//
//  Created by Robert Wilson on 13/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "WibraryViewController.h"
#import "WibraryConstants.h"

// HTML parsing files
#import "GBRFDocument.h"
#import "TFHpple.h"

@interface WibraryViewController ()
{
    // a few ivars to keep track of the download
    NSOutputStream *downloadStream;
    NSURLConnection *connection;
}
@end


@implementation WibraryViewController

@synthesize docManagerButton = _docManagerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self alertOKCancelAction];
    
    // call method to log into server
    [self loginToServer];
    
    // call methods to retrieve documents
//    [self getAppendicesFiles];
//    [self getDiagramsFiles];
//    [self getGOAFiles];
//    [self getManualFiles];
//    [self getNoticesMonsFiles];
//    [self getNoticesPonsFiles];
//    [self getNoticesUonsFiles];
//    [self getNoticesWonsFiles];
//    [self getPinkFiles];
//    [self getRosteringFiles];
//    [self getRuleBookFiles];
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
    NSString *line1 = lines[0];
    NSString *line2 = lines[1];
    NSString *line3 = lines[2];
    NSString *lastLine = lines.lastObject;
    NSLog(@"the first 3 lines are = \n%@\n%@\n%@", line1, line2, line3);
    NSLog(@"last line = \n%@", lastLine);
    
    // create sub array without xml nodes
    NSRange theRange;
    theRange.location = 2;
    theRange.length = [lines count] -3;
    NSArray *subArray = [lines subarrayWithRange:theRange];
    
    
//    NSLog(@"CHECK FILES RESULT = %@", subArray);
    [self getFilesFromServer:sessionID withFilesList:subArray];
}

- (void)getFilesFromServer:(NSString *)sessionID withFilesList:(NSArray *)theRequiredFilesList
{
    // try connecting to server
    NSString *seshID = @"test";
    NSString *fileName = @"test string representing file name parameter";
    NSLog(@"req. files = %@", theRequiredFilesList);
    
    NSString *post = [NSString stringWithFormat:@"sessionID=%@&fileNAME=%@", seshID, fileName];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *comparisonURLString = SERVER_GET_FILE_URL_STRING;
    NSURL *comparisonURL = [NSURL URLWithString:comparisonURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:comparisonURL];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *getFilesResponse = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"getFilesFromServer RESULT = %@", getFilesResponse);
    // ^ end try connecting to server ^
    
    [self getAllFiles];
}

- (void) getAllFiles
{
    // try connecting to server
    NSString *seshID = @"test";
    
    NSString *post = [NSString stringWithFormat:@"sessionID=%@", seshID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *comparisonURLString = SERVER_GET_ALL_FILES_URL_STRING;
    NSURL *comparisonURL = [NSURL URLWithString:comparisonURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:comparisonURL];
    [request setHTTPMethod:@"POST"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *sessionID = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"get all files result = %@", sessionID);
    // ^ end try connecting to server ^
}

- (void)getAppendicesFiles
{
    // create path to appendix folder by combining URL with folder name
    NSURL *appendixPathURL =[NSURL URLWithString:DOCUMENTS_URL APPENDICES_FOLDER];
    
    // retrieve HTML data from url
    NSData *appendixHTMLData = [NSData dataWithContentsOfURL:appendixPathURL];
    
    // create parser with download data
    TFHpple *appendixParser = [TFHpple hppleWithHTMLData:appendixHTMLData];
    
    // set up xpath query and have parser search using that query
    NSArray *appendixNodes = [appendixParser searchWithXPathQuery:X_PATH_QUERY_STRING];
    
    // create array to hold document objects and loop through obtained nodes
    NSMutableArray *appendixDocumentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in appendixNodes) {
        
        // create new documentItem object and add to array
        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
        [appendixDocumentsArray addObject:documentItem];
        
        // retrieve document title from node's first child's contents
        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
        
        // create substring to remove space character
        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
        
        // call method to download files and save to folder
        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:APPENDICES_FOLDER];
    }
}


//- (void)getDiagramsFiles
//{
//    // create authentication strings
//    NSString *userName = @"test";
////    NSString *password = @"test";
//    
//    // create post string and retrieve length
//    NSString *post = [NSString stringWithFormat:@"username=%@", userName];
//    NSLog(@"post : %@", post);
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    NSLog(@"post length = %@", postLength);
//    
//    
//    // try to connect to asp server
//    NSString *serverURLString = @"http://192.168.0.89/WebService.asmx/login?";
//    NSURL *serverURL = [NSURL URLWithString:serverURLString];
//    NSLog(@"server url : %@", serverURL);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL];
//    [request setHTTPMethod:@"POST"];
//    
////    NSString *json = @"{}";
////    NSMutableData *body = [[NSMutableData alloc] init];
//    
//    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:postData];
//    
//    // get repsonse
//    NSHTTPURLResponse *urlResponse = nil;
//    NSError *error = nil;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    NSLog(@"response data length = %@", responseData);
//    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"response code = %d", [urlResponse statusCode]);
//    
//    
//
//    
//    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] <300)
//    {
//        NSLog(@"Response: %@ - end response", result);
//    }
//    
//    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"http://192.168.0.89/GBRF.aspx/login" forHTTPHeaderField:@"SOAPAction"];
//    
//    
//    
//    //    [request setValue:@"test" forKey:@"userName"];
//    //    [request setValue:@"test" forKey:@"password"];
//    
//    
//    
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL DIAGRAMS_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:DIAGRAMS_FOLDER];
//    }
//}
//
//- (void)getGOAFiles
//{
//    // create path to GOA folder by combining URL with folder name
//    NSURL *goaPathURL =[NSURL URLWithString:DOCUMENTS_URL GOA_FOLDER];
//    NSLog(@"goa url: %@", goaPathURL);    
//    // retrieve HTML data from url
//    NSData *goaHTMLData = [NSData dataWithContentsOfURL:goaPathURL];    
//    // create parser with download data
//    TFHpple *goaParser = [TFHpple hppleWithHTMLData:goaHTMLData];    
//    // set up xpath query and have parser search using that query
//    NSArray *goaNodes = [goaParser searchWithXPathQuery:X_PATH_QUERY_STRING];    
//    // create array to hold document objects and loop through obtained nodes
//    NSMutableArray *goaDocumentsArray = [[NSMutableArray alloc] initWithCapacity:0];    
//    for (TFHppleElement *element in goaNodes) {
//        
//        // create new documentItem object and add to array
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [goaDocumentsArray addObject:documentItem];
//        // retrieve document title from node's first child's contents
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        // create substring to remove space character
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
//        NSLog(@"title: %@", documentTitle);        
//        // call method to download files and save to folder
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:GOA_FOLDER];
//    }
//}
//
//- (void)getManualFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL WORKING_MANUAL_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    NSLog(@"working manual dpURL: %@", docPathURL);
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
//        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:WORKING_MANUAL_FOLDER];
//    }
//}
//
//- (void)getNoticesMonsFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL NOTICES_MONS_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:NOTICES_MONS_FOLDER];
//    }
//}
//
//- (void)getNoticesPonsFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL NOTICES_PONS_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:NOTICES_PONS_FOLDER];
//    }
//}
//
//- (void)getNoticesUonsFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL NOTICES_UONS_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:NOTICES_UONS_FOLDER];
//    }
//}
//
//- (void)getNoticesWonsFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL NOTICES_WONS_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:NOTICES_WONS_FOLDER];
//    }
//}
//
//
//- (void)getPinkFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL PINK_PAGES_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:PINK_PAGES_FOLDER];
//    }
//}

- (void)getRosteringFiles
{
    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL ROSTERING_FOLDER];
    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
    
    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];

    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in doxNodes) {
        
        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
        [documentsArray addObject:documentItem];
        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
        NSLog(@"title: %@", documentTitle);
        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:ROSTERING_FOLDER];
    }
}

//- (void)getRuleBookFiles
//{
//    NSURL *docPathURL =[NSURL URLWithString:DOCUMENTS_URL RULE_BOOK_FOLDER];
//    NSData *docsHTMLData = [NSData dataWithContentsOfURL:docPathURL];
//    
//    TFHpple *doxParser = [TFHpple hppleWithHTMLData:docsHTMLData];
//    
//    NSArray *doxNodes = [doxParser searchWithXPathQuery:X_PATH_QUERY_STRING];
//    NSMutableArray *documentsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    for (TFHppleElement *element in doxNodes) {
//        
//        GBRFDocument *documentItem = [[GBRFDocument alloc] init];
//        [documentsArray addObject:documentItem];
//        documentItem.title = [[element firstChild] content]; // prepends single space character (?)
//        NSString *documentTitle = [documentItem.title substringWithRange:NSMakeRange(1, [documentItem.title length] -1)];
////        NSLog(@"title: %@", documentTitle);
//        [self downloadFile:documentTitle fromUrl:DOCUMENTS_URL toBeSavedInFolder:RULE_BOOK_FOLDER];
//    }
//}

// method to initiate the download of the file
- (void)downloadFile:(NSString *)filename fromUrl:(NSString *)urlString toBeSavedInFolder:(NSString *)destinationFolder
{
    // location to store the data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsFolder = [paths objectAtIndex:0];  // or paths[0];
    
    // concatenate folder and file name
    NSString *folderAndFileString = [documentsFolder stringByAppendingString:destinationFolder];
    
    NSString *downloadFilePath = [folderAndFileString stringByAppendingPathComponent:filename];
//    NSLog(@"dlp = %@", downloadFilePath);
    
    // create the directory if we need to
    if (![self createFolderForPath:downloadFilePath])
        return;
    
    // check if files exist and if not, write them
    if (![[NSFileManager defaultManager] fileExistsAtPath:downloadFilePath]) {
        
        // create the download file stream (so we can write the file as we download it    
        downloadStream = [NSOutputStream outputStreamToFileAtPath:downloadFilePath
                                                           append:NO];
        [downloadStream open];
        
        NSURL *url            = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        connection            = [NSURLConnection connectionWithRequest:request
                                                              delegate:self];
        NSAssert(connection, @"Connection creation failed");
        
    }
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
        NSLog(@"Status string = %s: %@", __FUNCTION__, statusString);
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
