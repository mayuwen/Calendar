//
//  MYWCalendarController.m
//  MYWCalendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MYWCalendarController.h"
#import "CollectionViewCell.h"
#import "NSString+LunarForSolarString.h"
#import "MYWCalendarDate.h"



#define  kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MYWCalendarController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    
    NSArray *_allDayWeeksArray;//当月里所有天数是周几的数组
    NSInteger _month;
    NSInteger _year;
    NSInteger _day;
    UILabel *_titleMonth;//月份label
    
    
}

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)NSCalendar *calendar;

@property (strong, nonatomic)NSDate *date;

@property (strong, nonatomic)MYWCalendarDate *calendarDate;



@end

@implementation MYWCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"日历";
    
    [self loadData];
    [self createTopView];
    
    [self.view addSubview:self.collectionView];
    
}

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

- (MYWCalendarDate*)calendarDate {
    if (_calendarDate == nil) {
        _calendarDate = [[MYWCalendarDate alloc]init];
    }
    return _calendarDate;
}
- (void)loadData {
    //获取当前月份
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    _month = comps.month;
    _year = comps.year;
    //默认是当前月份
    _allDayWeeksArray = [self.calendarDate getAllDayWeeksWithCalendarWithMonth:_month withYear:_year];
    
    
}



#pragma mark- 创建顶部年月 2017年9月
- (void)createTopView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 65, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    //2017年9月
    _titleMonth = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 50, 10, 100, 20)];
    NSString *text = [NSString stringWithFormat:@"%ld年%ld月",_year,_month];
    _titleMonth.text = text;
    _titleMonth.textColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1];
    _titleMonth.textAlignment = NSTextAlignmentCenter;
    _titleMonth.font = [UIFont systemFontOfSize:18];
    [view addSubview:_titleMonth];
    
    //下一个月按钮
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake( kScreenWidth - 60, 12, 11, 15)];
    [nextBtn setImage:[UIImage imageNamed:@"my_arrow_calendar_right"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
    
    //上一个月按钮
    UIButton *lastBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 12, 11, 15)];
    [lastBtn setImage:[UIImage imageNamed:@"my_arrow_calendar_left"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:lastBtn];
    
    [self.view addSubview:view];
    
}
- (void)nextBtnAction:(UIButton*)sender {
    //每点击一次月份加一，当月份大于12，年份加一，月份等于一
    _month ++;
    if (_month > 12) {
        _month = 1;
        _year ++;
    }
    //获取次年份的月信息
    _allDayWeeksArray = [self.calendarDate getAllDayWeeksWithCalendarWithMonth:_month withYear:_year];
    NSString *text = [NSString stringWithFormat:@"%ld年%ld月",_year,_month];
    _titleMonth.text = text;
    [self.collectionView reloadData];
}
- (void)lastBtnAction:(UIButton*)sender {
    
    _month --;
    if (_month < 1) {
        _month = 12;
        _year --;
    }
    _allDayWeeksArray = [self.calendarDate getAllDayWeeksWithCalendarWithMonth:_month withYear:_year];
    NSString *text = [NSString stringWithFormat:@"%ld年%ld月",_year,_month];
    _titleMonth.text = text;
    [self.collectionView reloadData];
    
}
#pragma mark- 返回单元格的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //当月天数 + 第一个天周几。（美国的星期是从周日开始，所以这里获取的星期几比中国的多一，这里要减一）
    return _allDayWeeksArray.count + [_allDayWeeksArray[0] integerValue] - 1;
    
}
#pragma mark- 定制单元格
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    //获取第一天是周几
    NSInteger firstDayNum = [_allDayWeeksArray[0] integerValue] - 1 ;
    
    //算出日历，indepath.item 是从零开始的，这里加一，从一开始算日期
    NSInteger indexNum = 1  + indexPath.item;
    //从第一行第一个就已经开始计算日历，这里就是用当前的数字 减去 第一天，小于1的数据将cell显示空，然后就能与日历的日期一一对应。
    NSInteger textIntrger = indexNum - firstDayNum;
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionItem" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.title.textColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1];
    cell.subTitle.textColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1];
    //周日周六的日期显示红色
    if (indexPath.item %7 == 6 || indexPath.item %7 == 0) {
        cell.title.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
        cell.subTitle.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
    }
    
    if (textIntrger < 1) {//计算后的数字小于1,用空字符串代替
        cell.title.text = @"";
        cell.subTitle.text = @"";
    } else{
        //阳历
        cell.title.text = [NSString stringWithFormat:@"%ld",textIntrger];
        //农历
        NSString *str;
        if (_month < 10) {
            str = [NSString stringWithFormat:@"%ld-0%ld-%ld",_year,_month,textIntrger];
        } else {
            str = [NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,textIntrger];
        }
        //2017-09-10 or 2017-10-10 传入年月日
        NSDate *date = [self theTargetStringConversionDate:str];
        //将公历日期传入计算农历日期
        NSString *lunarDate = [NSString LunarForSolar:date];//农历日期  月日
        NSString *month;
        NSString *day;
        
        if (lunarDate.length == 4) {
            month = [lunarDate substringToIndex:2];//月份
            day = [lunarDate substringFromIndex:2];//日期
        } else {//闰月  例如：闰四月初一
            month = [lunarDate substringToIndex:3];//月份
            day = [lunarDate substringFromIndex:3];//日期
        }
        
        //在初一的时候，日历上显示当前是几月
        if ([day isEqualToString:@"初一"]) {
            cell.subTitle.text = month;
        } else {
            cell.subTitle.text = day;
        }
        
    }
    //设置cell的背景圆圈
    CGFloat itemW = (kScreenWidth - 3) / 7;
    cell.layer.cornerRadius = itemW/2;
    cell.clipsToBounds = YES;
    
    return cell;
}


// 字符串转date
-(NSDate* )theTargetStringConversionDate:(NSString *)str
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:str];
    return date;
}

#pragma mark- 头视图 显示周几
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    headerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    
    for (int i = 0; i < 7; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.5 + (kScreenWidth - 3)/7 * i, 0, (kScreenWidth - 3)/7, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithRed:144.0/255 green:144.0/255 blue:144.0/255 alpha:1];
        NSString *titleText;
        switch (i) {
            case 0:
                titleText = @"日";
                titleLabel.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
                break;
            case 1:
                titleText = @"一";
                break;
            case 2:
                titleText = @"二";
                break;
            case 3:
                titleText = @"三";
                break;
            case 4:
                titleText = @"四";
                break;
            case 5:
                titleText = @"五";
                break;
            case 6:
                titleText = @"六";
                titleLabel.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
                break;
                
            default:
                break;
                
        }
        
        titleLabel.text = titleText;
        [headerView addSubview:titleLabel];
    }
    
    
    
    return headerView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //为了解决点击前后日期背景图以及颜色变化
    static CollectionViewCell *lastCell;
    
    CollectionViewCell *cell = (CollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell.title.text isEqualToString:@""]) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        if (lastCell != cell) {
            //获取第一天是周几
            NSInteger firstDayNum = [_allDayWeeksArray[0] integerValue] - 1 ;
            
#warning mark-- 各种写法都没有成功解决点击后，周六日颜色变回红色，然后误打误撞就这样解决了。
            if (([lastCell.title.text intValue] + firstDayNum - 1) %7 == 6 || ([lastCell.title.text intValue] + firstDayNum - 1) %7 == 0) {
                lastCell.title.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
                lastCell.subTitle.textColor = [UIColor colorWithRed:239.0/255 green:4.0/255 blue:4.0/255 alpha:1];
            } else {
                
                lastCell.title.textColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1];
                lastCell.subTitle.textColor = [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1];
            }
            
            lastCell.backgroundColor = [UIColor whiteColor];
            lastCell = cell;
            
        }
        
        cell.title.textColor = [UIColor whiteColor];
        cell.subTitle.textColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor colorWithRed:242.0/255 green:100.0/255 blue:50.0/255 alpha:1];
    }
    
}

#pragma mark- 懒加载collectionView
- (UICollectionView*)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth - 3) / 7;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumInteritemSpacing = 0.5;
        flowLayout.minimumLineSpacing = 0.5;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 105, kScreenWidth, self.view.frame.size.height-105) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"collectionItem"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    }
    
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
