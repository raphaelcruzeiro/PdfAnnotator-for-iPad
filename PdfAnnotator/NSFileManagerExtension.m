//
//  NSFileManagerExtension.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "NSFileManagerExtension.h"

@interface CBlockEnumerator : NSEnumerator
@property (readwrite, nonatomic, copy) id (^block)(void);
@end;

@implementation NSFileManager (NSFileManagerExtension)


- (NSString*)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    NSAssert(mask == 0, @"We don't handle masks");
    NSAssert(keys == NULL, @"We don't handle non-null keys");
    
    NSDirectoryEnumerator *innerEnumerator = [self enumeratorAtPath:[url path]];
    
    CBlockEnumerator *enumerator = [[[CBlockEnumerator alloc] init] autorelease];
    enumerator.block = ^id(void) {
        NSString *path = [innerEnumerator nextObject];
        
        if(path != NULL) {
            return [url URLByAppendingPathComponent:path];
        } else {
            return NULL;
        }
    };
    
    return enumerator;
}

@end

@implementation CBlockEnumerator

@synthesize block;

- (void)dealloc
{
    [block release];
    block = NULL;
    
    [super dealloc];
}

- (id)nextObject
{
    id object = self.block;
    return object;
}

@end