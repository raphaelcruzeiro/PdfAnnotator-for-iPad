//
//  NSFileManagerExtension.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (NSFileManagerExtension)

- (NSString*)documentsPath;

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url 
includingPropertiesForKeys:(NSArray *)keys 
options:(NSDirectoryEnumerationOptions)mask 
errorHandler:(BOOL (^)(NSURL *url, NSError *error))handler;

@end
