//
//  DocumentDeserializer.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/19/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "DocumentDeserializer.h"
#import "Annotation.h"
#import "NSFileManagerExtension.h"
#import "PageAnnotation.h"
#import "MarkerPath.h"


@implementation DocumentDeserializer

- (Annotation*)readAnnotation:(NSString *)filePath
{
    NSString *_filePath = [[[[NSFileManager defaultManager] documentsPath] stringByAppendingPathComponent:filePath] stringByAppendingPathExtension:@"mrk"];
                        
    NSData *data = [NSData dataWithContentsOfFile:_filePath];
    
    xmlTextReaderPtr reader = xmlReaderForMemory([data bytes], 
                                                 [data length], 
                                                 [_filePath UTF8String], 
                                                 nil,  XML_PARSE_NOCDATA | 
                                                 XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
    
    
    Annotation *annotation = [[Annotation alloc] init];
    
    if(!reader) {
        NSLog(@"Unable to load xmlreader.");
        return annotation;
    }
    
    BOOL fileNode = false;
    BOOL pageNode = false;
    BOOL markerNode = false;
    BOOL pointNode = false;
    NSString *fileName;
    NSString *hash;
    PageAnnotation *currentPageAnnotation = nil;
    MarkerPath *currentMark = nil;
    CGPoint currentPoint = CGPointMake(0, 0);
    
    const char *temp;
    
    while(xmlTextReaderRead(reader)) {
        int nodeType = xmlTextReaderNodeType(reader);
        
        switch (nodeType) {
            case XML_READER_TYPE_ELEMENT:
                temp = (char*)xmlTextReaderConstName(reader);
                fileNode = !(BOOL)strcmp(temp, "File");
                pageNode = !(BOOL)strcmp(temp, "Page");
                markerNode = !(BOOL)strcmp(temp, "Marker");
                pointNode = !(BOOL)strcmp(temp, "Point");
                
                while(xmlTextReaderMoveToNextAttribute(reader)) {
                
                    temp = (char*)xmlTextReaderConstName(reader);
                
                    if(!strcmp(temp, "name") && fileNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        fileName = [NSString stringWithCString:temp encoding:NSStringEncodingConversionAllowLossy];
                    }
                    else if(!strcmp(temp, "hash") && fileNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        hash = [NSString stringWithCString:temp encoding:NSStringEncodingConversionAllowLossy];
                    } 
                    else if(!strcmp(temp, "number") && pageNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        
                        currentPageAnnotation = [[PageAnnotation alloc] initWithPageNumber:strtol(temp, NULL, 10)];
                        [annotation._pageAnnotations addObject:currentPageAnnotation];
                    }
                    else if(!strcmp(temp, "brush") && markerNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        
                        currentMark = [[MarkerPath alloc] initWithBrush:(TextMarkerBrush)strtol(temp, NULL, 10)];
                        [currentPageAnnotation._paths addObject:currentMark];
                    }
                    else if(!strcmp(temp, "x") && pointNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        
                        currentPoint.x = strtof(temp, NULL);
                    }
                    else if(!strcmp(temp, "y") && pointNode) {
                        temp = (char*)xmlTextReaderConstValue(reader);
                        
                        currentPoint.y = strtof(temp, NULL);
                        [currentMark addPoint:currentPoint];
                    }
                    
                }
                
                xmlTextReaderMoveToElement(reader);
                
                continue;
                
        }
    }
    
    xmlFreeTextReader(reader);
    xmlCleanupParser();
    
    return annotation;
}

@end
