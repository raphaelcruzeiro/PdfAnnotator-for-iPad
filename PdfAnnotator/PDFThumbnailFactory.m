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

#import "PDFThumbnailFactory.h"
#import "PDFDocument.h"

@implementation PDFThumbnailFactory

@synthesize _document;

- (id)initWithPDFDocument:(PDFDocument*)document;
{
    self = [super init];
    if (self) {
        self._document = document;
    }
    
    return self;
}

- (UIImage*)generateThumbnailForPage:(NSInteger)page withSize:(CGSize)size
{
    [self._document loadDocumentRef];
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(self._document.document, page);
    
    const CGRect mediaBox = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
    const CGRect renderRect = [self scaleAndAlign:mediaBox destinationRect:(CGRect){ .size = size }];
    
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextTranslateCTM(ctx, - (mediaBox.origin.x - renderRect.origin.x), - (mediaBox.origin.y - renderRect.origin.y));
    CGContextScaleCTM(ctx, renderRect.size.width / mediaBox.size.width, renderRect.size.height / mediaBox.size.height);
    
    CGContextDrawPDFPage(ctx, pageRef);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self._document releaseDocumentRef];
    
    return image;
}

- (CGRect)scaleAndAlign:(CGRect)imageRect destinationRect:(CGRect)destinationRect
{
    CGRect scaledRect = {};
    
    CGSize scaledImageSize = imageRect.size;
    
    float scaleFactor = 1.0;
    
    if(destinationRect.size.width / imageRect.size.width < destinationRect.size.height / imageRect.size.height) {
        scaleFactor = destinationRect.size.width / imageRect.size.width;
    } else {
        scaleFactor = destinationRect.size.height / imageRect.size.height;
    }
    
    scaledImageSize.width *= scaleFactor;
    scaledImageSize.height *= scaleFactor;
    
    scaledRect.size = scaledImageSize;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, - destinationRect.size.height);
    
    scaledRect = CGRectApplyAffineTransform(scaledRect, transform);
    
    return scaledRect;
}

@end
