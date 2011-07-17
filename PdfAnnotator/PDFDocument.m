//
//  PDFDocument.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "PDFDocument.h"
#import "Annotation.h"


@implementation PDFDocument

@synthesize document;
@synthesize page;
@synthesize annotation;
@synthesize name;

- (id)initWithDocument:(NSURL *)documentPath
{
    if((self = [super init]) != NULL) {
        NSLog(@"Opening: %@", documentPath);
        
        self.name = [documentPath lastPathComponent];
        
        self.document = CGPDFDocumentCreateWithURL((CFURLRef)documentPath);
        
        self.page = CGPDFPageRetain(CGPDFDocumentGetPage(document, 1));
        
        self.annotation = [[Annotation alloc] init];
    }
    
    return self;
}

- (NSInteger)pageCount
{
    return CGPDFDocumentGetNumberOfPages(self.document);
}

- (void)loadPage:(NSInteger)number
{
    self.page = CGPDFPageRetain(CGPDFDocumentGetPage(document, number));
}

- (void)dealloc
{
    NSLog(@"Cleaning doc...");
    CGPDFDocumentRelease(self.document);
    
    [super dealloc];
}

@end
