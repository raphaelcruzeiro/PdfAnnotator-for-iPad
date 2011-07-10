//
//  PDFThumbnailFactory.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "PDFThumbnailFactory.h"
#import "PDFDocument.h"

@implementation PDFThumbnailFactory

@synthesize _document;

- (id)initWithDocument:(PDFDocument*)document;
{
    self = [super init];
    if (self) {
        self._document = document;
    }
    
    return self;
}

- (UIImage*)generateThumbnailForPage:(NSInteger)page withSize:(CGSize)size
{
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
