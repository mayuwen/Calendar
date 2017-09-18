//
//  MYWCalendarDate.m
//  MYWCalendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MYWCalendarDate.h"

@implementation MYWCalendarDate


- (NSCalendar*)calendar {
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
        
    }
    return _calendar;
}
- (NSDate*)date {
    if (_date == nil) {
        _date = [NSDate date];
    }
    return _date;
}

/**
 *  获取当月中所有天数是周几
 */
- (NSArray*) getAllDayWeeksWithCalendarWithMonth:(NSInteger)number withYear:(NSInteger)year
{
    //一个月的总天数
    NSUInteger dayCount = [self getNumberOfDaysInMonthWithMonth:number withYear:year];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * str = [formatter stringFromDate:[self getPriousorLaterDateFromDate:self.date withMonth:number withYear:year]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray * allDayWeeksArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 1; i <= dayCount; i++) {
        
        NSString * sr = [NSString stringWithFormat:@"%@-%ld",str,i];
        NSDate *suDate = [formatter dateFromString:sr];
        [allDayWeeksArray addObject:[self getweekDayWithDate:suDate]];
        
    }
    
    
    return allDayWeeksArray;
}


/**
 *  获得某天的数据
 *
 *  获取指定的日期是星期几
 */
- (id) getweekDayWithDate:(NSDate *) date
{
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitWeekday fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday]);
    
}


// 获取该月的天数
- (NSInteger)getNumberOfDaysInMonthWithMonth:(NSInteger)number withYear:(NSInteger)year
{
    NSDate * currentDate = [self getPriousorLaterDateFromDate:self.date withMonth:number withYear:year];
    // 这个日期可以你自己给定
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                        inUnit: NSCalendarUnitMonth
                                       forDate:currentDate];
    return range.length;
}




//获取指定某个月的date数据
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month withYear:(NSInteger)year
{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:month];
    [comp setYear:year];
    
    NSDate *currentDate = [self.calendar dateFromComponents:comp];
    return currentDate;
}



@end
