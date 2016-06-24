//
//  NSDate+WSPXUtility.h
//  AngleCare
//
//  Created by MrChens on 14-8-28.
//  Copyright (c) 2014年 Joly. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATE_FORMAT_MMM_DD_YYY_12HOUR @"MMM dd, yyyy hh:mm:ss a"
#define DATE_FORMAT_MMM_DD_YYY_24HOUR @"MMM dd, yyyy HH:mm:ss"
#define DATE_FORMAT_YYYY_MM_DD @"yyyy-MM-dd"
#define DATE_FORMAT_YYYY_MM_DD_HH_MM_SS_24HOUR @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_YYYY_MM @"yyyy-MM"
#define DATE_FORMAT_HH_MM_SS_24HOUR @"HH:mm:ss"
#define DATE_FORMAT_HH_MM_SS_12HOUR @"hh:mm:ss a"
#define DATE_FORMAT_HH_MM_24HOUR @"HH:mm"
@interface NSDate (WSPXUtility)

/**
 *根据指定格式转换NSString为NSDate
 *
 *return NSDate
 **/
+(NSDate *)getDateFromTheDateString:(NSString *)theDateString ByTheFormatString:(NSString *)theFormatString;

/**
 *根据指定格式转换NSDate为NSString
 *
 *return NSString
 **/
-(NSString *)getDateStringByTheFormatString:(NSString *)theFormatString;
/**
 *获取指定日期中的年,月,日,时,分,秒各时间字段的信息(解封)
 *
 *return NSDateComponents(日期组件)
 **/
-(NSDateComponents *)getDateComponents;

/**
 *将指定的年月日时分秒封装到日期组件中(封装)
 *
 *return NSDateComponents(日期组件)
 **/
+(NSDate *)setDateComponentsFromTheYear:(NSString *)theYear andMonth:(NSString *)theMonth Day:(NSString *)theDay Hour:(NSString *)theHour Minute:theMinute Second:(NSString *)theSecond;
/**
 *  将指定的年月日时分秒按照给定的时分改变
 *
 *  @param aDate 被转换的日期
 *  @param aHour 给定的小时数
 *  @param aMin  给定的分钟数
 *
 *  @return 转换后的日期  例如 2012-11-01 10:20:42 给定的参数为 2012-11-01 , 8 , 0 转为了 2012-11-01 08:00:00
 */
-(NSDate *)CovertDateWithHourCount:(int)aHour andMin:(int)aMin;

+(NSInteger)getYearFromDate:(NSDate *)aDate;
+(NSInteger)getMonthFromDate:(NSDate *)aDate;
+(NSInteger)getDayFromDate:(NSDate *)aDate;
+(NSInteger)getHourFromDate:(NSDate *)aDate;
+(NSInteger)getMinuFromDate:(NSDate *)aDate;
+(NSInteger)getSecondFromDate:(NSDate *)aDate;
//获取下一个星期一上午10点
+(NSDate *)getNextMonday10AM;

@end
