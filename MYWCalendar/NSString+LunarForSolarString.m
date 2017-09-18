//
//  NSString+LunarForSolarString.m
//  Calendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSString+LunarForSolarString.h"

@implementation NSString (LunarForSolarString)


/*
 * 日期转字符串
 * date : 需要转换的日期
 */
+ (NSString * )theTargetDateConversionStr:(NSDate * )date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    // 根据自己需求处理字符串
    return [currentDateStr substringToIndex:10];
}


+ (NSString *)LunarForSolar:(NSDate *)solarDate{
    
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"冬",@"腊",nil];
    
    //公历每月前面的天数const
    int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438,3402,3749,331177,1453,694,201326,2350,465197,3221,3402,400202,2901,1386,267611,605,2349,137515,2709,464533,1738,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222,268949,3402,3493,133973,1386,464219,605,2349,334123,2709,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static NSInteger wCurYear,wCurMonth,wCurDay;
    static NSInteger nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:solarDate];
    
    wCurYear =  components.year ;
    wCurMonth = components.month;
    wCurDay = components.day;
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear  - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2)) {
        nTheDate = nTheDate + 1;
    }
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    
    while(nIsEnd != 1) {
        if(wNongliData[m] < 4095) {
            k = 11;
        } else {
            k = 12;
        }
        
        n = k;
        
        while(n>=0) {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            
            for (i = 1; i < n+1; i++) {
                nBit = nBit / 2;
            }
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit)) {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        
        if (nIsEnd)
            break;
        
        m = m + 1;
    }
    
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    
    if (k == 12) {
        if (wCurMonth == wNongliData[m]/65536 + 1) {
            wCurMonth = 1 - wCurMonth;
        } else if (wCurMonth > wNongliData[m]/65536 + 1) {
            wCurMonth = wCurMonth - 1;
        }
    }
    
    //生成农历月、日
    
    NSString *szNongliDay;
    
    if (wCurMonth < 1){ //闰月
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    } else {
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@月%@",szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
    
}

@end
