//
//  APGSharedUGClient.m
//  Books
//
//  Created by Matthew Dobson on 6/18/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "APGSharedUGClient.h"


@implementation APGSharedUGClient

+ (UGClient *)sharedClient
{
    static UGClient *sharedClient;
    static NSString * orgName = @"mdobson";
    static NSString * appName = @"books";
    
    @synchronized(self)
    {
        if (!sharedClient)
            sharedClient = [[UGClient alloc] initWithOrganizationId:orgName withApplicationID:appName];
        
        return sharedClient;
    }
}

@end
