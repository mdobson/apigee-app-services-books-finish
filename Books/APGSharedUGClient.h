//
//  APGSharedUGClient.h
//  Books
//
//  Created by Matthew Dobson on 6/18/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGClient.h"

@interface APGSharedUGClient : NSObject

+ (UGClient *) sharedClient;

@end
