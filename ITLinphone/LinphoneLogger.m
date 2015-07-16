//
//  LinphoneLogger.m
//  ITLinphone
//
//  Created by Hung Bui on 7/16/15.
//  Copyright (c) 2015 Hung. All rights reserved.
//

#import "LinphoneLogger.h"

@implementation LinphoneLogger

+ (void)logv:(OrtpLogLevel)severity
        file:(const char *)file
        line:(int)line
      format:(NSString *)format
        args:(va_list)args {
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    int filesize = 20;
    if (severity <= ORTP_DEBUG) {
        // lol: ortp_debug(XXX) can be disabled at compile time, but ortp_log(ORTP_DEBUG, xxx) will always be valid even
        //      not in debug build...
        ortp_debug("%*s:%3d - %s", filesize, file + MAX((int)strlen(file) - filesize, 0), line, [str UTF8String]);
    } else {
        ortp_log(severity, "%*s:%3d - %s", filesize, file + MAX((int)strlen(file) - filesize, 0), line,
                 [str UTF8String]);
    }
}

+ (void)log:(OrtpLogLevel)severity file:(const char *)file line:(int)line format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    [LinphoneLogger logv:severity file:file line:line format:format args:args];
    va_end(args);
}

#pragma mark - Logs Functions callbacks

void linphone_iphone_log_handler(int lev, const char *fmt, va_list args) {
    NSString *format = [[NSString alloc] initWithUTF8String:fmt];
    NSString *formatedString = [[NSString alloc] initWithFormat:format arguments:args];
    char levelC = 'I';
    switch ((OrtpLogLevel)lev) {
        case ORTP_FATAL:
            levelC = 'F';
            break;
        case ORTP_ERROR:
            levelC = 'E';
            break;
        case ORTP_WARNING:
            levelC = 'W';
            break;
        case ORTP_MESSAGE:
            levelC = 'I';
            break;
        case ORTP_TRACE:
        case ORTP_DEBUG:
            levelC = 'D';
            break;
        case ORTP_LOGLEV_END:
            return;
    }
    // since \r are interpreted like \n, avoid double new lines when logging packets
    NSLog(@"%c %@", levelC, [formatedString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"]);
}

@end
