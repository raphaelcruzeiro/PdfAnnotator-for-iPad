//
//  PDFDocument.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDFDocument : NSObject {
    
}

- (id)initWithDocument:(NSURL *)documentPath;

- (NSInteger) pageCount;

@property (readwrite, nonatomic, assign) CGPDFDocumentRef document;
@property (readwrite, nonatomic, assign) CGPDFPageRef page;

@end
