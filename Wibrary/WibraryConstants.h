//
//  WibraryConstants.h
//  Wibrary
//
//  Created by Sprint on 14/11/2012.
//  Copyright (c) 2012 Robert Wilson. All rights reserved.
//

#ifndef Wibrary_WibraryConstants_h
#define Wibrary_WibraryConstants_h

// define document source URL
#define DOCUMENTS_URL @"http://abelsoul.fav.cc/Dox/FilesGBRF"

// define server URLstrings
#define SERVER_LOGIN_URL_STRING @"http://192.168.0.89/WebService.asmx/login"
#define SERVER_COMPARE_URL_STRING @"http://192.168.0.89/WebService.asmx/checkFiles?"
#define SERVER_GET_FILE_URL_STRING @"http://192.168.0.89/WebService.asmx/getFile"
#define SERVER_GET_ALL_FILES_URL_STRING @"http://192.168.0.89/WebService.asmx/getAllFiles"

// define download URL
#define SERVER_DOWNLOAD_URL_STRING @"http://192.168.0.89/FilesGBRF/"

// define HTML parsing X-Path string
#define X_PATH_QUERY_STRING @"/html/body/ul/li/a"

// define document filenames
#define ROSTERING_FILENAME @"Scotland ATM Roster wc 30.9.12.doc"
#define GOA_FILENAME @"GOA Briefing v2.pdf"

// define document folders
#define APPENDICES_FOLDER @"/Sectional%20Appendices"
#define DIAGRAMS_FOLDER @"/Diagrams"
#define GOA_FOLDER @"/GOA"
#define NOTICES_MONS_FOLDER @"/Notices/MONS"
#define NOTICES_PONS_FOLDER @"/Notices/PONS"
#define NOTICES_UONS_FOLDER @"/Notices/UONS"
#define NOTICES_WONS_FOLDER @"/Notices/WONS"
#define PINK_PAGES_FOLDER @"/Pink%20Pages%20Dec%202011"
#define ROSTERING_FOLDER @"/Rostering"
#define RULE_BOOK_FOLDER @"/Rule%20Book"
#define WORKING_MANUAL_FOLDER @"/Working%20Manual%20for%20Rail%20Staff" // Working Manual For Rail Staff

// define icon types
#define DOC_ICON @"gbr-doc.png"
#define PDF_ICON @"gbr-pdf.png"
#define XLS_ICON @"gbr-xls.png"
#define PPT_ICON @"gbr-ppt.png"

#endif
