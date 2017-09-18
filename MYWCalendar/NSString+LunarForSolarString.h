//
//  NSString+LunarForSolarString.h
//  Calendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LunarForSolarString)

+ (NSString *)theTargetDateConversionStr:(NSDate *)date;
+ (NSString *)LunarForSolar:(NSDate *)solarDate;

@end
