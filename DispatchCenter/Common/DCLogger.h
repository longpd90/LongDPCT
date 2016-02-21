//
//  DCLogger.h
//  
//
//  Created on 4/8/15.
//

#import <Foundation/Foundation.h>
#define LOG_LEVEL_INF    0
#define LOG_LEVEL_ERR    1

#define LOGGING_LEVEL   LOG_LEVEL_INF

#define MyLog(level, fmt, ...) {\
    if (level >= LOGGING_LEVEL) {\
        char *levelStr = "";\
        switch (level) {\
            case LOG_LEVEL_INF:\
                levelStr = "[INF]";\
                break;\
            case LOG_LEVEL_ERR:\
                levelStr = "[ERR]";\
                break;\
            default:\
                break;\
        }\
        NSLog((@"%s [%s:%d] " fmt), levelStr, strrchr("/" __FILE__, '/') + 1, __LINE__, ##__VA_ARGS__);\
    }\
}

#define DLogError(f, ...) MyLog(LOG_LEVEL_ERR, f, ##__VA_ARGS__)
#define DLogInfo(f, ...) MyLog(LOG_LEVEL_INF, f, ##__VA_ARGS__)