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
