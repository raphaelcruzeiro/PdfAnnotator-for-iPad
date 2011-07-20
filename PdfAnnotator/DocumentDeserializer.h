//
//  DocumentDeserializer.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/19/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>

@class Annotation;

@interface DocumentDeserializer : NSObject {
    
}

- (Annotation*)readAnnotation:(NSString*)filePath;

@end
