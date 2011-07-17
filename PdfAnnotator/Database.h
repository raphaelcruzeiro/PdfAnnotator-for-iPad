//
//  Database.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/17/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface Database : NSObject {
    sqlite3 *db;
}

- (NSString*)filePath;
- (void)open;
- (void)createTable:(NSString*)name WithFields:(NSArray*)fields;
- (void)insertInto:(NSString*)tableName Fields:(NSArray*)fields Values:(NSArray*)values;
- (NSArray*)selectFrom:(NSString*)table;
- (NSInteger)getLastIdFromTable:(NSString*)table;

@end
