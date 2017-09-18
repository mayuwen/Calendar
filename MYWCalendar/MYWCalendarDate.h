//
//  MYWCalendarDate.h
//  MYWCalendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYWCalendarDate : NSObject {
    NSCalendar *_calendar;//日历参数
    NSDate *_date;//日期参数
}

// 获取当月中所有天数是周几
- (NSArray*) getAllDayWeeksWithCalendarWithMonth:(NSInteger)number withYear:(NSInteger)year;


@end
