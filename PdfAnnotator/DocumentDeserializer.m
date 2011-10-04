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
        return [annotation autorelease];
    }
    
    BOOL fileNode = false;
    BOOL pageNode = false;
    BOOL markerNode = false;
    BOOL pointNode = false;
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
                
                    if(!strcmp(temp, "number") && pageNode) {
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
                        currentMark.loadedFromFile = YES;
                        [currentMark addPoint:currentPoint];
                    }
                    
                }
                
                xmlTextReaderMoveToElement(reader);
                
                continue;
                
        }
    }
    
    xmlFreeTextReader(reader);
    xmlCleanupParser();
    
    return [annotation autorelease];
}

@end
