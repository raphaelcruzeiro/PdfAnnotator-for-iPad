//
//  DocumentSerializer.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/19/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDFDocument;

@interface DocumentSerializer : NSObject {
    
}

- (void)serialize:(PDFDocument*)document;
- (NSString*)documentsPath;

@end
