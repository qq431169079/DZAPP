//
//  CustomDayDatePicker.m
//  IntelligentRestaurant
//
//  Created by xgm on 17/5/5.
//  Copyright © 2017年 xiegm. All rights reserved.
//

#import "CustomDayDatePicker.h"

@interface CustomDayDatePicker()
@property (nonatomic,strong) NSMutableArray *dayArray;//日期
@property (nonatomic,strong) NSMutableArray *hourArray;//小时
@property (nonatomic,strong) NSMutableArray *minuteArray;//分
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
    picker = [[UIPickerView alloc] initWithFrame:self.bounds];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self addSubview:picker];
    //5分钟后
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5*60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //日
    self.dayArray = [NSMutableArray array];
    [formatter setDateFormat:@"dd"];
    
    self.day = [[formatter stringFromDate:date] intValue];
    for (int i = 0; i<6; i++) {//往后7天
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*i];
        int newDay = [[formatter stringFromDate:newDate] intValue];
        NSString *newDayStr = [NSString stringWithFormat:@"%d",newDay];
        [self.dayArray addObject:newDayStr];
    }
    
    [formatter setDateFormat:@"HH"];
    self.hour = [[formatter stringFromDate:date] intValue];
    self.hourArray = [NSMutableArray array];
    for (int i = self.hour; i<24; i++) {
        NSString *newHourStr = [NSString stringWithFormat:@"%d",i];
        [self.hourArray addObject:newHourStr];
        
    }
    [formatter setDateFormat:@"mm"];
    
    self.minute = [[formatter stringFromDate:date] intValue];
    self.minuteArray = [NSMutableArray array];
    for (int i = self.minute; i<60; i++) {
        NSString *newMinuteStr = [NSString stringWithFormat:@"%d",i];
        [self.minuteArray addObject:newMinuteStr];
        
    }
    
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker selectRow:0 inComponent:1 animated:YES];
    [picker selectRow:0 inComponent:2 animated:YES];
}
#pragma mark - PickerView Datadelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dayArray.count;
    }else if (component == 1){
        //获取前一个滚轮的当前所选行的索引
        int row = (int)[picker selectedRowInComponent:0];
        if (row == 0) {
            return self.hourArray.count;
        }else{
            return 24;
        }
    }else{
        //获取前二个滚轮的当前所选行的索引
        int rowDay = (int)[picker selectedRowInComponent:0];
        int rowHour = (int)[picker selectedRowInComponent:1];
        if (rowDay == 0 && rowHour == 0) {
            return self.minuteArray.count;
        }else{
            return 59;
        }
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *curLab = [[UILabel alloc] init];
    curLab.textAlignment = NSTextAlignmentCenter;
    curLab.backgroundColor = [UIColor clearColor];
    curLab.frame = CGRectMake(0, 0, self.frame.size.width/3.0, 50);
    [curLab setFont:[UIFont boldSystemFontOfSize:16]];
    if (component == 0) {
    //日期
        curLab.text = [NSString stringWithFormat:@"%@ 日",[self.dayArray objectAtIndex:row]];
        
    }else if (component == 1){
    //小时
        int rowDay = (int)[picker selectedRowInComponent:0];
        if (rowDay == 0) {
            curLab.text = [NSString stringWithFormat:@"%@ 时",[self.hourArray objectAtIndex:row]];
        }else{
            curLab.text = [NSString stringWithFormat:@"%ld 时",row];
        }
        
    }else{
        //分
        int rowDay = (int)[picker selectedRowInComponent:0];
        int rowHour = (int)[picker selectedRowInComponent:1];
        if (rowDay == 0 && rowHour == 0) {
            curLab.text = [NSString stringWithFormat:@"%@ 分",[self.minuteArray objectAtIndex:row]];
        }else{
            curLab.text = [NSString stringWithFormat:@"%ld 分",row];
        }
    }
    return curLab;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width/3.0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int rowDay = (int)[pickerView selectedRowInComponent:0];
    int rowHour = (int)[pickerView selectedRowInComponent:1];
    int rowMinut = (int)[pickerView selectedRowInComponent:2];
    if (component == 0)
    {
        [picker reloadComponent:1];

        if (rowDay == 0) {
            int curHour = [[self.hourArray firstObject] intValue];
            NSInteger row = self.hour - curHour;
            if (row <0) {
                row = 0;
            }
                [pickerView selectRow:row inComponent:1 animated:NO];

        }else{
            [pickerView selectRow:self.hour inComponent:1 animated:NO];
        }
        [picker reloadComponent:2];
        //刷新后保持当前的时间不变
        if (rowDay == 0 && rowHour == 0) {
            NSInteger curMinut = [[self.minuteArray firstObject] integerValue];
            NSInteger row = self.minute - curMinut;
            if (row <0) {
                row = 0;
            }
            [pickerView selectRow:row inComponent:2 animated:NO];
            
        }else{
            [pickerView selectRow:self.minute inComponent:2 animated:NO];
        }
    }
    if (component == 1)
    {
        //当第一个滚轮发生变化时,刷新第二个滚轮的数据
        [picker reloadComponent:2];
        //让刷新后的第二个滚轮重新回到第一行
        if (rowDay == 0 && rowHour == 0) {
            NSInteger curMinut = [[self.minuteArray firstObject] integerValue];
            NSInteger row = self.minute - curMinut;
            if (row <0) {
                row = 0;
            }
            [pickerView selectRow:row inComponent:2 animated:NO];
            
        }else{
            [pickerView selectRow:self.minute inComponent:2 animated:NO];
        }
    }
    int rowHourEnd = (int)[picker selectedRowInComponent:1];
    int rowMinutEnd = (int)[picker selectedRowInComponent:2];
    self.day = [[self.dayArray objectAtIndex:rowDay] intValue];
    
    if (rowDay == 0) {
        self.hour = [[self.hourArray objectAtIndex:rowHourEnd] intValue];
    }else{
        self.hour = rowHour;
    }
    
    if (rowDay == 0 && rowHour == 0) {
        self.minute = [[self.minuteArray objectAtIndex:rowMinutEnd] intValue];
    }else{
        self.minute = rowMinut;
    }
    if (self.didSelectFinishBlock) {
        self.didSelectFinishBlock(self.day, self.hour, self.minute);
    }
}




















@end
