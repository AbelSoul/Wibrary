//
//  GBRFDocument.h
//  LonePadDemo
//
//  Created by Sprint on 02/11/2012.
//  Copyright (c) 2012 Sprint. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEBHOST @"http://test:test@abelsoul.fav.cc/Dox/FilesGBRF/"
#define APACHE_WEBHOST @"http://192.168.0.46//FilesGBRF/" // dynamic - may change with each reboot
#define DOC_XPATH_QUERY_STRING @"/html/body/ul/li/a"
#define APACHE_XPATH_STRING    @"//html/body/table/tbody/tr/td/a"

@interface GBRFDocument : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *url;

@end
