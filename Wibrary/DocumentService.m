//
//  DocumentService.m
//  Wibrary
//
//  Created by Robert Wilson on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#import "DocumentService.h"

@implementation DocumentService

@synthesize image = _image;
@synthesize caption = _caption;

-(id)initWithCaption:(NSString*)theCaption andImage:(UIImage*)theImage
{
    self = [super init];
    if(self)
    {
        self.caption = theCaption;
        self.image = theImage;
    }
    return self;
}
+(NSArray*)getDocumentData
{
    DocumentService* service1 = [[DocumentService alloc] initWithCaption:@"Litigation" andImage:[UIImage imageNamed:@"gbr-ppt.png"]];
    DocumentService* service2 = [[DocumentService alloc] initWithCaption:@"Family Law" andImage:[UIImage imageNamed:@"gbr-ppt.png"]];
    DocumentService* service3 = [[DocumentService alloc] initWithCaption:@"Conveyancing" andImage:[UIImage imageNamed:@"gbr-ppt.png"]];
    DocumentService* service4 = [[DocumentService alloc] initWithCaption:@"Corporate Law" andImage:[UIImage imageNamed:@"service-4.jpg"]];
    DocumentService* service5 = [[DocumentService alloc] initWithCaption:@"Solicitors" andImage:[UIImage imageNamed:@"service-5.jpg"]];
    DocumentService* service6 = [[DocumentService alloc] initWithCaption:@"Tax Law" andImage:[UIImage imageNamed:@"service-6.jpg"]];
    return [NSArray arrayWithObjects:service1, service2, service3, service4, service5, service6, nil];
}

@end
