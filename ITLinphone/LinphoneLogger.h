//
//  LinphoneLogger.h
//  ITLinphone
//
//  Created by Hung Bui on 7/16/15.
//  Copyright (c) 2015 Hung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ortp/ortp.h>

@interface LinphoneLogger : NSObject {
    
}

+ (void)log:(OrtpLogLevel)severity file:(const char *)file line:(int)line format:(NSString *)format, ...;
void linphone_iphone_log_handler(int lev, const char *fmt, va_list args);
@end
