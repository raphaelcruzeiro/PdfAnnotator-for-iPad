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
@synthesize _documentPath;
@synthesize rawDocumentPath;
@synthesize currentPage;

@synthesize version;

- (id)initWithDocument:(NSString *)documentPath
{
    if((self = [super init]) != NULL) {
        
        self.name = [documentPath lastPathComponent];
        
        _documentPath = nil;
        rawDocumentPath = documentPath;
        
        self.version = @"0.5";
        self.currentPage = 1;
        
        DocumentDeserializer *deserializer = [[[DocumentDeserializer alloc] init] autorelease];
        self.annotation = [deserializer readAnnotation:[self.name stringByDeletingPathExtension]];
    }
    
    return self;
}

- (NSInteger)pageCount
{
    [self loadDocumentRef];
    NSInteger result = CGPDFDocumentGetNumberOfPages(self.document);
    [self releaseDocumentRef];
    
    return result;
}

- (void)loadPage:(NSInteger)number
{
    if(self.document != nil){
        CGPDFPageRelease(self.page);
        self.page = CGPDFDocumentGetPage(document, number);
    } 
    
    self.currentPage = number;
}

- (BOOL)save
{
    DocumentSerializer *serializer = [[[DocumentSerializer alloc] init] autorelease];
    [serializer serialize:self];
    
    self.dirty = NO;
    return !self.dirty;
}

- (void)loadDocumentRef
{
    if(self.document == nil){
        if([rawDocumentPath rangeOfString:@"PdfAnnotator.app/"].location != NSNotFound)
            _documentPath = [NSURL  fileURLWithPath:rawDocumentPath];
        else
            _documentPath = [NSURL URLWithString:rawDocumentPath];
    
        NSLog(@"Opening: %@", _documentPath);
    
        self.document = CGPDFDocumentCreateWithURL((CFURLRef)_documentPath);
        
        self.page = CGPDFDocumentGetPage(self.document, self.currentPage);
    }
}

- (void)releaseDocumentRef
{
    if(self.document != nil){
        CGPDFDocumentRelease(self.document);
        self.document = nil;
    }
}

- (void)dealloc
{
    NSLog(@"Cleaning doc...");
    [self releaseDocumentRef];
    
    [super dealloc];
}

@end
