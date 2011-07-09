//
//  PDFPageView.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFDocument;

@interface PDFPageView : UIView <UIScrollViewDelegate> {
    CGRect pageRect;
    UIView *contentView;
}

@property (nonatomic, retain) PDFDocument *_document;

- (id)initWithDocument:(PDFDocument*)document;

@end
