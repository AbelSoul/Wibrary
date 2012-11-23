//
//  NoticesDocumentService.h
//  Wibrary
//
//  Created by Sprint on 23/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SUB_FOLDER @"Notices/"
#define MFOLDER @"MONS"
#define PFOLDER @"PONS"
#define UFOLDER @"UONS"
#define WFOLDER @"WONS"

@interface NoticesDocumentService : NSObject

@property (nonatomic, copy) NSString* caption;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain)NSURLRequest* myURLRequest;


-(id)initWithCaption:(NSString*)theCaption andImage:(UIImage*)theImage andURLRequest:(NSURLRequest *) theURLRequest;

+(NSArray*)getDocumentData;


@end
