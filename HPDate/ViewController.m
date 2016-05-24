//
//  ViewController.m
//  HPDate
//
//  Created by PuhuiMac01 on 16/5/20.
//  Copyright © 2016年 PuHuiFinancial. All rights reserved.
//

/*
 * 首先获取当年当月的信息
 */

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight  49.0f
#define kNavBar 64.0f

#import "ViewController.h"
#import "NSDate+PHCalender.h"
@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_years;
    NSMutableArray *_months;
    NSMutableArray *_days;
    
    UIPickerView *_datePicker;
    
    NSString *_year;
    NSString *_month;
    NSInteger _dayRow;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDate *date = [NSDate new];
    NSLog(@"%ld",(long)[date numberOfDaysInCurrentMonth]);
    NSLog(@"getYear %ld",(long)[date getYear]);

    NSLog(@"getMonth %ld",(long)[date getMonth]);

    NSLog(@"weekOfDay %ld",(long)[date weekOfDay]);
    
    NSLog(@"getDay %ld",(long)[date getDay]);
    
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    [components setYear:2007];
    [components setMonth:2];
    
    NSInteger iCurYear = [components year];  //当前的年份
    
    NSInteger iCurMonth = [components month];  //当前的月份
    
    NSInteger iCurDay = [components day];  // 当前的号数
    
    NSDate *lastMonDate = [calendar dateFromComponents:components];
    
  int length = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonDate].length;
    
    NSLog(@"获取每个月的天数  包括闰年  %d",length);
    
    NSString  *dateStr = nil;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= iCurDay; i++) {
        dateStr  = [NSString stringWithFormat:@"%d-%d-%d", iCurYear, iCurMonth, i];
        
        NSLog(@"dateStr %@",dateStr);
        [arr addObject:dateStr];
    }
    
    [self _initData];
    [self _initPickerViews];
    
}


- (void)_initPickerViews {
    
    _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,kScreenHeight - kNavBar - kScreenHeight/3 - 60, kScreenWidth,kScreenHeight/3)];
    // 显示选中框
    _datePicker.showsSelectionIndicator=YES;
    _datePicker.dataSource = self;
    _datePicker.delegate = self;
    [self.view addSubview:_datePicker];
    
    // 定位到当月
    NSDate *date = [NSDate new];
    NSLog(@"%ld",(long)[date numberOfDaysInCurrentMonth]);
    NSLog(@"getYear %ld",(long)[date getYear]);
    
    NSLog(@"getMonth %ld",(long)[date getMonth]);
    
    NSLog(@"weekOfDay %ld",(long)[date weekOfDay]);
    
    NSLog(@"getDay %ld",(long)[date getDay]);
    // 年
    [_datePicker selectRow:[date getYear] - 1000 inComponent:0 animated:YES];
    // 月
    [_datePicker selectRow:(1000 * 12 + [date getMonth] - 1) inComponent:1 animated:YES];
    // 日
    _dayRow = 1000 * 31 + [date getDay] - 1;

    [_datePicker selectRow:(1000 * 31 + [date getDay] - 1)inComponent:2 animated:YES];

    
}

- (void)_initData {
    
    //
    _years = [NSMutableArray array];
    
    for (int i = 1000; i < 10000; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",i];
        [_years addObject:year];
    }
    _months = [NSMutableArray array];
    for (int i = 1; i <= 12; i++) {
        NSString *month = [NSString stringWithFormat:@"%d",i];
        [_months  addObject:month];
    }
   
    
    _days = [NSMutableArray array];
    
    for (int i = 1; i <= 31; i ++) {
        NSString *day = [NSString stringWithFormat:@"%d",i];
        [_days  addObject:day];
    }
    
    // 初始化时获取当月的天数
    NSDate *date = [NSDate new];
    NSLog(@"%ld",(long)[date numberOfDaysInCurrentMonth]);
    
    
    
    NSLog(@"getYear %ld",(long)[date getYear]);
    
    NSLog(@"getMonth %ld",(long)[date getMonth]);
    
    NSLog(@"weekOfDay %ld",(long)[date weekOfDay]);
    
    NSLog(@"getDay %ld",(long)[date getDay]);
    
    
    
    
}

#pragma mark PickerView代理方法
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return _years.count;
        
    }else if (component == 1) {
        
        return  12*10000;
        
    }else {
        
        return 31*10000;
    }
    
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return kScreenWidth/3;
}

// 选中方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        _year = _years[row];
        if ([_days[_dayRow%31] integerValue] == 29 || [_days[_dayRow%31] integerValue] == 30 || [_days[_dayRow%31] integerValue] == 31) {
            if ([self numberOfDataByYeaer:_year withMonth:_month] < [_days[_dayRow%31] integerValue] ) {
                int a = [_days[_dayRow%31] integerValue] - [self numberOfDataByYeaer:_year withMonth:_month];
                if (a <= 0) {
                    
                    a = 0;
                    
                }else {
                    
                [pickerView selectRow:_dayRow - a inComponent:2 animated:YES];
                    _dayRow = _dayRow - a;
                    
                }
            }
        }
    } if (component == 1) {
        _month = _months[row%12];
        
        if ([_days[_dayRow%31] integerValue] == 29 || [_days[_dayRow%31] integerValue] == 30 || [_days[_dayRow%31] integerValue] == 31) {
            if ([self numberOfDataByYeaer:_year withMonth:_month] < [_days[_dayRow%31] integerValue] ) {
                int a = [_days[_dayRow%31] integerValue] - [self numberOfDataByYeaer:_year withMonth:_month];
                
                NSLog(@"a *** --- %d",a);
                if (a <= 0) {
                    
                    a = 0;
                    
                }else {
                    
                [pickerView selectRow:_dayRow - a inComponent:2 animated:YES];
                    NSLog(@"-- _dayRow - a %d",_dayRow - a);
                    _dayRow = _dayRow - a;

                }
            }
        }
    }
    
    if (component == 2) {
        _dayRow = row;

        if ([_days[row%31] integerValue] == 29 || [_days[row%31] integerValue] == 30 || [_days[row%31] integerValue] == 31) {
            
            if ([self numberOfDataByYeaer:_year withMonth:_month] < [_days[row%31] integerValue] ) {
                int a = [_days[row%31] integerValue] - [self numberOfDataByYeaer:_year withMonth:_month];
                if (a <= 0) {
                    
                    a = 0;
                    
                }else {
                _dayRow = row - a;
                [pickerView selectRow:row - a inComponent:2 animated:YES];
                    
                }
            }
        }
    }
    
    [pickerView reloadComponent:2];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        
        return [NSString stringWithFormat:@"%@年",_years[row]];
        
    }else if (component == 1) {
        
        return [NSString stringWithFormat:@"%@月",_months[row%12]];
        
    }else if (component ==2 ) {
        
        return [NSString stringWithFormat:@"%@日",_days[row%31]];
        
    }else {
        return @"";
    }
    
    
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //
    if (component == 0) {
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@年",_years[row]] attributes:attrDic];
        return attrString;
    }else  if (component == 1) {
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@月",_months[row%12]] attributes:attrDic];
        return attrString;
    }else {
        UIColor *color = [UIColor blackColor];
        
        if ([_days[row%31] integerValue] == 29 || [_days[row%31] integerValue] == 30 || [_days[row%31] integerValue] == 31) {
            if ([self numberOfDataByYeaer:_year withMonth:_month] < [_days[row%31] integerValue] ) {
                color = [UIColor lightGrayColor];
            }
        }
        
        NSDictionary * attrDic = @{NSForegroundColorAttributeName:color,
                                   NSFontAttributeName:[UIFont systemFontOfSize:13]
                                   };
        NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@日",_days[row%31]] attributes:attrDic];
        return attrString;
    }
    
}

- (int )numberOfDataByYeaer:(NSString *)year withMonth:(NSString *)month{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];

    [components setYear:[year integerValue]];
    [components setMonth:[month integerValue]];
    
    NSDate *lastMonDate = [calendar dateFromComponents:components];
    
    int length = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastMonDate].length;
    
    NSLog(@"获取每个月的天数  包括闰年  %d",length);
    
    if (length == 28) {
        
    }
    if (length == 29) {
        
    }
    
    return length;
    
}




@end
