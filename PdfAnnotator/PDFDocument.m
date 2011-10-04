// Copyright (C) 2011 by Raphael Cruzeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
