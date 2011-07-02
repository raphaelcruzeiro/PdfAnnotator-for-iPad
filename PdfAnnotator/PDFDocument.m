//
//  PDFDocument.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "PDFDocument.h"


@implementation PDFDocument

@synthesize document;
@synthesize page;

- (id)initWithDocument:(NSURL *)documentPath
{
    if((self = [super init]) != NULL) {
        NSLog(@"Opening: %@", documentPath);
        
        self.document = CGPDFDocumentCreateWithURL((CFURLRef)documentPath);
        
        self.page = CGPDFPageRetain(CGPDFDocumentGetPage(document, 1));
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"Cleaning doc...");
    CGPDFDocumentRelease(self.document);
    
    [super dealloc];
}

@end
