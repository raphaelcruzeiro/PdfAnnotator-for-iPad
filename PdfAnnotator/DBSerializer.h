//
//  DBSerializer.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/17/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Database;
@class PDFDocument;

@interface DBSerializer : NSObject {
    NSArray *documentFields;
    NSArray *pageFields;
    NSArray *markFields;
    NSArray *pointFields;
}

@property (nonatomic, retain) Database *database;

- (id)init;
- (void)dealloc;

- (void)createSchema;
- (void)insertPDFDocument:(PDFDocument*)document;

@end
