//
//  DocumentService.h
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentService : NSObject

@property (nonatomic, copy) NSString* caption;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain)NSURLRequest* myURLRequest;


-(id)initWithCaption:(NSString*)theCaption andImage:(UIImage*)theImage andURLRequest:(NSURLRequest *) theURLRequest;

+(NSArray*)getDocumentData;

@end
