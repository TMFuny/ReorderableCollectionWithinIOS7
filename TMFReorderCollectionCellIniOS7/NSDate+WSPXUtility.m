//
//  NSDate+WSPXUtility.m
//  AngleCare
//
//  Created by MrChens on 14-8-28.
//  Copyright (c) 2014年 Joly. All rights reserved.
//

#import "NSDate+WSPXUtility.h"
@implementation NSDate (WSPXUtility)
#pragma mark - 根据指定格式转换NSString为NSDate
+(NSDate *)getDateFromTheDateString:(NSString *)theDateString ByTheFormatString:(NSString *)theFormatString{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:theFormatString];
  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  NSDate *date = [dateFormatter dateFromString:theDateString];
  return date;
}
#pragma mark - 根据指定格式转换NSDate为NSString
-(NSString *)getDateStringByTheFormatString:(NSString *)theFormatString{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:theFormatString];
  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  NSString *dateString = [dateFormatter stringFromDate:self];
  return dateString;
}


#pragma mark - 获取指定日期中的年,月,日,时,分,秒各时间字段的信息(解封)
-(NSDateComponents *)getDateComponents{
  //    获取代表公历的Calendar对象
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  //    定义一个时间字段的旗标，指定将会获取指定年月日时分秒的信息
  unsigned uintFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSWeekdayCalendarUnit;
  //    获取不同时间字段的信息
  NSDateComponents *comp = [gregorian components:uintFlags fromDate:self];
  return comp;
}
#pragma mark - 将指定的年月日时分秒封装到日期组件中(封装)
+(NSDate *)setDateComponentsFromTheYear:(NSString *)theYear andMonth:(NSString *)theMonth Day:(NSString *)theDay Hour:(NSString *)theHour Minute:(id)theMinute Second:(NSString *)theSecond{
  
  NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comp = [[NSDateComponents alloc] init];
  
  comp.year = [theYear intValue];
  comp.month = [theMonth intValue];
  comp.day = [theDay intValue];
  comp.hour = [theHour intValue];
  comp.minute = [theMinute intValue];
  comp.second = [theSecond intValue];
  //    通过NSDateComponents所包含的时间字段的数值来赋值给date对象
  NSDate *date = [gregorian dateFromComponents:comp];
  return date;
}
#pragma mark - 将指定的日期根据给定的小时，分钟转换
-(NSDate *)CovertDateWithHourCount:(int)aHour andMin:(int)aMin{
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *com = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
  [com setHour:aHour];
  [com setMinute:aMin];
  [com setSecond:0];
  NSDate *date = [gregorian dateFromComponents:com];
  return date;
}

/**
 *  根据日期计算年 月 日 时 分 秒 的具体值
 *
 *  @param aDate   需要计算的日期
 *  @param aOption 1:表示计算年 2:月 3:日 4:时 5:分 6:秒
 *
 *  @return 具体的值
 */
#pragma mark - 根据日期和参数计算对应的具体数值
+(NSInteger)getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:(NSDate *)aDate WithOption:(NSInteger)aOption{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:aDate];
  
  NSInteger returnInteger = -1;
  
  switch (aOption) {
    case 1:
    {
      returnInteger = [components year];
    }
      break;
    case 2:
    {
      returnInteger = [components month];
    }
      break;
    case 3:
    {
      returnInteger = [components day];
    }
      break;
    case 4:
    {
      returnInteger = [components hour];
    }
      break;
    case 5:
    {
      returnInteger = [components minute];
    }
      break;
    case 6:
    {
      returnInteger = [components second];
    }
      break;
    default:
      break;
  }
  return returnInteger;
}

+(NSInteger)getYearFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:1];
}
+(NSInteger)getMonthFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:2];
}
+(NSInteger)getDayFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:3];
}
+(NSInteger)getHourFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:4];
}
+(NSInteger)getMinuFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:5];
}
+(NSInteger)getSecondFromDate:(NSDate *)aDate {
  return [self getYearOrMonthOrDayOrHourOrMinuOrSecondFromDate:aDate WithOption:6];
}
#pragma mark - 获取下一个星期一上午10点
+(NSDate *)getNextMonday10AM{
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *now = [NSDate date];
    BOOL success = [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval:&extends forDate:now];
    if (!success){
        return nil;
    }
    else{
        //从本周第一天(默认星期天为第一天)到现在经过的秒数
        NSTimeInterval secondFromStart = fabs([start timeIntervalSinceNow]);
        //从周日到周一早上10点经过的秒数
        NSTimeInterval gap = (24+10)*60*60;
        if (secondFromStart > gap){
            return [NSDate dateWithTimeInterval:extends - secondFromStart + gap sinceDate:now];
        }else{
            return [NSDate dateWithTimeInterval:gap - secondFromStart sinceDate:now];
        }
    }
}
@end
