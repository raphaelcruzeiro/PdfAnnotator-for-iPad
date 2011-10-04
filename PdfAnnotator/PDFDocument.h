//
//  PDFDocument.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Annotation;

@interface PDFDocument : NSObject {
}

- (id)initWithDocument:(NSString *)documentPath;

- (NSInteger) pageCount;
- (void) loadPage:(NSInteger)number;
- (BOOL)save;
- (void) releaseDocumentRef;
- (void) loadDocumentRef;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *hash;
@property (readwrite, nonatomic, assign) CGPDFDocumentRef document;
@property (readwrite, nonatomic, assign) CGPDFPageRef page;
@property (nonatomic, retain) NSURL *_documentPath;
@property (nonatomic, retain) NSString *rawDocumentPath;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, retain) NSString *version;

@property (nonatomic, assign) BOOL dirty;

@property (nonatomic, retain) Annotation *annotation;

@end
