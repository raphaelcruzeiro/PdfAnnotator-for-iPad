//
//  PDFDocument.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "PDFDocument.h"
#import "Annotation.h"
#import "HashExtensions.h"
#import "DocumentDeserializer.h"
#import "DocumentSerializer.h"


@implementation PDFDocument

@synthesize document;
@synthesize page;
@synthesize annotation;
@synthesize name;
@synthesize hash;
@synthesize dirty;

@synthesize version;

- (id)initWithDocument:(NSString *)documentPath
{
    if((self = [super init]) != NULL) {
        
        self.name = [documentPath lastPathComponent];
        
        NSURL *_documentPath = nil;
        
        if([documentPath rangeOfString:@"PdfAnnotator.app/"].location != NSNotFound)
            _documentPath = [NSURL  fileURLWithPath:documentPath];
        else
            _documentPath = [NSURL URLWithString:documentPath];
        
        NSLog(@"Opening: %@", _documentPath);
        
        self.document = CGPDFDocumentCreateWithURL((CFURLRef)_documentPath);
        
        self.page = CGPDFDocumentGetPage(document, 1);
        
        self.version = @"0.5";
        
        
        DocumentDeserializer *deserializer = [[[DocumentDeserializer alloc] init] autorelease];
        self.annotation = [deserializer readAnnotation:[self.name stringByDeletingPathExtension]];
    }
    
    return self;
}

- (NSInteger)pageCount
{
    return CGPDFDocumentGetNumberOfPages(self.document);
}

- (void)loadPage:(NSInteger)number
{
    CGPDFPageRelease(self.page);
    self.page = CGPDFDocumentGetPage(document, number);
}

- (BOOL)save
{
    DocumentSerializer *serializer = [[[DocumentSerializer alloc] init] autorelease];
    [serializer serialize:self];
    
    self.dirty = NO;
    return !self.dirty;
}

- (void)dealloc
{
    NSLog(@"Cleaning doc...");
    CGPDFDocumentRelease(self.document);
    
    [super dealloc];
}

@end
