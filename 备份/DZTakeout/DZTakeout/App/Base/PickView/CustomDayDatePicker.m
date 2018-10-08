//
//  CustomDayDatePicker.m
//  IntelligentRestaurant
//
//  Created by xgm on 17/5/5.
//  Copyright © 2017年 xiegm. All rights reserved.
//

#import "CustomDayDatePicker.h"

@interface CustomDayDatePicker()
@property (nonatomic,strong) NSMutableArray *monthArray;//月
@property (nonatomic,strong) NSMutableArray *dayArray;//日
@property (nonatomic,strong) NSMutableArray *hourArray;//小时
@property (nonatomic,strong) NSArray *norHourArray;//非第一天小时
@property (nonatomic,strong) NSMutableArray *minuteArray;//分
@property (nonatomic,strong) NSMutableArray *dateArray;//日期的数组

@property (nonatomic,strong) NSMutableDictionary *dateDict; //日期对应的数组字典
@property (nonatomic,assign) int divideIndex;               //分隔的位子
@property (nonatomic,assign) BOOL needReload;          //手动改的月份需要重置所有
@end

@implementation CustomDayDatePicker
{
    UIPickerView *picker;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDateView];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupDateView];
}

-(void)setupDateView{
    self.needReload = YES;
    picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self addSubview:picker];
    //当前时间往后推30分钟
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:30*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    
//    //假的时间
//    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss-ZZZZ"];
//    NSString *time = [formatter stringFromDate:date];
//    time = [time stringByReplacingCharactersInRange:NSMakeRange(5, 14) withString:@"08-16-20:59:00"];
//    date = [formatter dateFromString:time];
//    
    //如果当前时间过了8.30,只能从第二天开始预订
    [formatter setDateFormat:@"HH"];
    int hour = [[formatter stringFromDate:date] intValue];
    if (hour>=21) {
        //从第二天开始预订 ps:以当前时间往后推4个小时即可
        date = [NSDate dateWithTimeIntervalSinceNow:60*60*4];
    }else{
        //半小时后开始预订 ,判断是否在预定时区内,非预定时区的分钟重置成00
        if ([self.norHourArray containsObject:[formatter stringFromDate:date]]) {
            NSLog(@"___预定时间内");
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss-ZZZZ"];
            NSString *time = [formatter stringFromDate:date];
            time = [time stringByReplacingCharactersInRange:NSMakeRange(14, 2) withString:@"00"];
            date = [formatter dateFromString:time];
        }
    }
    //当前所在月日
    self.dayArray = [NSMutableArray array];
    [formatter setDateFormat:@"MM-dd"];
    
    self.day = [[formatter stringFromDate:date] intValue];
    NSString *curMonth;
    for (int i = 0; i<6; i++) {//往后7天

        NSDate *newDate = [NSDate dateWithTimeInterval:24*60*60*i sinceDate:date];

        NSString *mmdd = [formatter stringFromDate:newDate];
        NSArray *mmddArray = [mmdd componentsSeparatedByString:@"-"];
        NSString *mm = [mmddArray firstObject];
        NSString *dd = [mmddArray lastObject];
        if (i == 0) {
            self.month = [mm intValue];
            curMonth = mm;
            [self.monthArray addObject:mm];
        }else{
            if (![curMonth isEqualToString:mm]) {
                if (![self.monthArray containsObject:mm]) {
                    self.divideIndex = i;
                    [self.monthArray addObject:mm];
                }
            }
        }
        
        [self.dayArray addObject:dd];
        [self.dateArray addObject:newDate];
    }
    
    [formatter setDateFormat:@"HH"];
    self.hour = [[formatter stringFromDate:date] intValue];
    self.hourArray = [NSMutableArray array];
    for (int i = self.hour; i<21; i++) {
        if ((i>=12 && i<14)||(i >=18 && i<21)) {
            NSString *newHourStr = [NSString stringWithFormat:@"%02d",i];
            [self.hourArray addObject:newHourStr];
        }
    }
    [formatter setDateFormat:@"mm"];
    
    self.minute = [[formatter stringFromDate:date] intValue];
    self.minuteArray = [NSMutableArray array];
    for (int i = self.minute; i<60; i++) {
        NSString *newMinuteStr = [NSString stringWithFormat:@"%02d",i];
        [self.minuteArray addObject:newMinuteStr];
        
    }
    
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker selectRow:0 inComponent:1 animated:YES];
    [picker selectRow:0 inComponent:2 animated:YES];
    [picker selectRow:0 inComponent:3 animated:YES];
}
#pragma mark - PickerView Datadelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.monthArray.count;
    }else if (component == 1) {
        return self.dayArray.count;
    }else if (component == 2){
        //获取前一个滚轮的当前所选行的索引
        int row = (int)[picker selectedRowInComponent:1];
        if (row == 0) {
            return self.hourArray.count;
        }else{
            return self.norHourArray.count;
        }
    }else{
        //获取前二个滚轮的当前所选行的索引
        int rowDay = (int)[picker selectedRowInComponent:1];
        int rowHour = (int)[picker selectedRowInComponent:2];
        if (rowDay == 0 && rowHour == 0) {
            return self.minuteArray.count;
        }else{
            return 60;
        }
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *curLab = [[UILabel alloc] init];
    curLab.textAlignment = NSTextAlignmentCenter;
    curLab.backgroundColor = [UIColor clearColor];
    curLab.frame = CGRectMake(0, 0, self.frame.size.width/4.0, 50);
    [curLab setFont:[UIFont boldSystemFontOfSize:16]];
    if (component == 0) {
        //日期
        curLab.text = [NSString stringWithFormat:@"%@ 月",[self.monthArray objectAtIndex:row]];
        
    }else if (component == 1) {
    //日期
        curLab.text = [NSString stringWithFormat:@"%@ 日",[self.dayArray objectAtIndex:row]];
        
    }else if (component == 2){
    //小时
        int rowDay = (int)[picker selectedRowInComponent:1];
        if (rowDay == 0) {
            curLab.text = [NSString stringWithFormat:@"%@ 时",[self.hourArray objectAtIndex:row]];
        }else{
            curLab.text = [NSString stringWithFormat:@"%@ 时",[self.norHourArray objectAtIndex:row]];
        }
        
    }else if (component == 3){
        //分
        int rowDay = (int)[picker selectedRowInComponent:1];
        int rowHour = (int)[picker selectedRowInComponent:2];
        if (rowDay == 0 && rowHour == 0) {
            curLab.text = [NSString stringWithFormat:@"%@ 分",[self.minuteArray objectAtIndex:row]];
        }else{
            curLab.text = [NSString stringWithFormat:@"%02ld 分",row];
        }
    }
    return curLab;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width/4.0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int rowMonth = (int)[pickerView selectedRowInComponent:0];
    int rowDay = (int)[pickerView selectedRowInComponent:1];
    int rowHour = (int)[pickerView selectedRowInComponent:2];
//    int rowMinut = (int)[pickerView selectedRowInComponent:3];
    if (component == 0)
    {
        int curMonth = [self.monthArray[rowMonth] intValue];
        if (self.month != curMonth) {
            self.month = curMonth;
            [picker reloadComponent:1];
            
            NSInteger newDayRow = 0;
            if (row == 1) {
                newDayRow = self.divideIndex;
            }else{
                newDayRow = self.divideIndex-1;
            }
            //月份做了调整,默认跳到那个月的第一天
            [pickerView selectRow:newDayRow inComponent:1 animated:YES];
            [picker reloadComponent:2];
            if (row == 0) {
                //如果第一个月刚好只有一天,需要判断时间做重置
                
                if (newDayRow == 0) {
                    NSString *curHourStr = [NSString stringWithFormat:@"%02d",self.hour];
                        NSInteger row = 0;
                        if ([self.hourArray containsObject:curHourStr]) {
                            row = [self.hourArray indexOfObject:curHourStr];
                        }
                        [pickerView selectRow:row inComponent:2 animated:NO];
                    [picker reloadComponent:3];
                        if (row == 0) {
                            //小时是第一个要重置分钟
                            NSString *curMinuteStr = [NSString stringWithFormat:@"%02d",self.minute];
                            NSInteger rowMin = 0;
                            if ([self.minuteArray containsObject:curMinuteStr]) {
                                rowMin = [self.minuteArray indexOfObject:curMinuteStr];
                            }
                            [pickerView selectRow:rowMin inComponent:3 animated:NO];
                        }
                }
            }

        }
    }
    if (component == 1)
    {
        NSDate *curDate = self.dateArray[rowDay];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //如果当前时间过了8.30,只能从第二天开始预订
        [formatter setDateFormat:@"MM"];
        int curMonth = [[formatter stringFromDate:curDate]intValue];
        if (self.month > curMonth) {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }else if (self.month < curMonth){
            [pickerView selectRow:1 inComponent:0 animated:YES];
        }
        self.month = curMonth;
        [picker reloadComponent:2];
        NSString *curHourStr = [NSString stringWithFormat:@"%02d",self.hour];
        if (rowDay == 0) {
            NSInteger row = 0;
            if ([self.hourArray containsObject:curHourStr]) {
                row = [self.hourArray indexOfObject:curHourStr];
            }
            [pickerView selectRow:row inComponent:2 animated:NO];
        }else{
            NSInteger row = 0;
            if ([self.norHourArray containsObject:curHourStr]) {
                row = [self.norHourArray indexOfObject:curHourStr];
            }
            [pickerView selectRow:row inComponent:2 animated:NO];
        }
        [picker reloadComponent:3];
        //刷新后保持当前的时间不变
        NSString *curMinuteStr = [NSString stringWithFormat:@"%02d",self.minute];
        if (rowDay == 0 && rowHour == 0) {
            NSInteger row = 0;
            if ([self.minuteArray containsObject:curMinuteStr]) {
                row = [self.minuteArray indexOfObject:curMinuteStr];
            }
            [pickerView selectRow:row inComponent:3 animated:NO];
            
        }else{
            [pickerView selectRow:self.minute inComponent:3 animated:NO];
        }
    }
    if (component == 2)
    {
        //当第二个滚轮发生变化时,刷新第三个滚轮的数据
        [picker reloadComponent:3];
        //刷新后保持当前的时间不变
        NSString *curMinuteStr = [NSString stringWithFormat:@"%02d",self.minute];
        if (rowDay == 0 && rowHour == 0) {
            NSInteger row = 0;
            if ([self.minuteArray containsObject:curMinuteStr]) {
                row = [self.minuteArray indexOfObject:curMinuteStr];
            }
            [pickerView selectRow:row inComponent:3 animated:NO];
            
        }else{
            [pickerView selectRow:self.minute inComponent:3 animated:NO];
        }
    }
    int rowDayEnd = (int)[picker selectedRowInComponent:1];
    int rowHourEnd = (int)[picker selectedRowInComponent:2];
    int rowMinutEnd = (int)[picker selectedRowInComponent:3];
    self.day = [[self.dayArray objectAtIndex:rowDayEnd] intValue];
    
    if (rowDay == 0) {
        self.hour = [[self.hourArray objectAtIndex:rowHourEnd] intValue];
    }else{
        self.hour = [[self.norHourArray objectAtIndex:rowHourEnd] intValue];
    }
    
    if (rowDay == 0 && rowHour == 0) {
        self.minute = [[self.minuteArray objectAtIndex:rowMinutEnd] intValue];
    }else{
        self.minute = rowMinutEnd;
    }
    if (self.didSelectFinishBlock) {
        self.didSelectFinishBlock(self.month, self.day, self.hour, self.minute);
    }
}

#pragma mark 懒加载
-(NSMutableArray *)monthArray{
    if (_monthArray == nil) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

-(NSMutableArray *)dayArray{
    if (_dayArray == nil) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

-(NSMutableArray *)hourArray{
    if (_hourArray == nil) {
        _hourArray = [NSMutableArray array];
    }
    return _hourArray;
}

-(NSMutableArray *)minuteArray{
    if (_minuteArray == nil) {
        _minuteArray = [NSMutableArray array];
    }
    return _minuteArray;
}
-(NSMutableArray *)dateArray{
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

-(NSMutableDictionary *)dateDict{
    if (_dateDict == nil) {
        _dateDict = [NSMutableDictionary dictionary];
    }
    return _dateDict;
}
-(NSArray *)norHourArray{
    if (_norHourArray == nil) {
        _norHourArray = [NSArray arrayWithObjects:@"12",@"13",@"18",@"19",@"20",nil];
    }
    return _norHourArray;
}

@end
