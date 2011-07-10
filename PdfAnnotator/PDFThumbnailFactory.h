//
//  PDFThumbnailFactory.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PDFDocument;

@interface PDFThumbnailFactory : NSObject{
}

@property (nonatomic, retain) PDFDocument *_document;

- (id)initWithDocument:(PDFDocument*)document;

- (UIImage*)generateThumbnailForPage:(NSInteger)page withSize:(CGSize)size;

- (CGRect)scaleAndAlign:(CGRect)imageRect destinationRect:(CGRect)destinationRect;

@end
