//
//  Song.m
//  On the 8
//
//  Created by Justin Rhoades on 1/12/15.
//  Copyright (c) 2015 Justin Rhoades. All rights reserved.
//

#import "Song.h"

@implementation Song

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.title = [decoder decodeObjectForKey:@"title"];
    self.key = [decoder decodeObjectForKey:@"key"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.key forKey:@"key"];
}


@end
