//
//  NSDate+PHCalender.h
//  HPDate
//
//  Created by PuhuiMac01 on 16/5/20.
//  Copyright © 2016年 PuHuiFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PHCalender)
// 获取当天月数
- (NSInteger)numberOfDaysInCurrentMonth;
// 获取本月第一天
- (NSDate*)firstDayOfCurrentMonth;
// 确定某天是周几
- (int)weekOfDay;
// 年  月  日
- (int)getYear;
- (int)getMonth;
- (int)getDay;
@end
