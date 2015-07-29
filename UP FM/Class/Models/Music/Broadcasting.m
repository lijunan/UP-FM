//
//  Broadcasting.m
//  UP FM
//
//  Created by liubin on 15/3/1.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "Broadcasting.h"
#import "Mica.h"

@implementation Broadcasting

@synthesize open;
@synthesize column;


+ (Broadcasting *)sharedInstance
{
    static dispatch_once_t onceToken;
    static Broadcasting *broadcasting;
    dispatch_once(&onceToken, ^{
        NSData *udObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"Broadcasting"];
        broadcasting = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
        if (! broadcasting) {
            broadcasting = [[self alloc] init];
            broadcasting.mediaType=mediaBroadcasting;
            broadcasting.open=NO;
        }
    });
    return broadcasting;
}

- (void)save
{
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:[Broadcasting sharedInstance]];
    
    [[NSUserDefaults standardUserDefaults] setObject:udObject forKey:@"Broadcasting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.mediaId = [aDecoder decodeObjectForKey:@"mediaId"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.mediaTag = [aDecoder decodeObjectForKey:@"mediaTag"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.introduction = [aDecoder decodeObjectForKey:@"introduction"];
        self.notice = [aDecoder decodeObjectForKey:@"notice"];
        self.languages = [aDecoder decodeObjectForKey:@"languages"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.column = [aDecoder decodeObjectForKey:@"column"];
        self.open=[aDecoder decodeBoolForKey:@"open"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mediaId forKey:@"mediaId"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.mediaTag forKey:@"mediaTag"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.introduction forKey:@"introduction"];
    [aCoder encodeObject:self.notice forKey:@"notice"];
    [aCoder encodeObject:self.languages forKey:@"languages"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.column forKey:@"column"];
    [aCoder encodeBool:self.open forKey:@"open"];
    
}

-(void)clear{
    self.open=NO;
    [MCFile delete:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",self.cover]];
    [MCFile delete:[DROADASTING_FILE_BATH stringByAppendingFormat:@"/%@",self.icon]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Broadcasting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
