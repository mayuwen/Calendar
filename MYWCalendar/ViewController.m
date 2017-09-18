//
//  ViewController.m
//  MYWCalendar
//
//  Created by apple on 2017/9/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "MYWCalendarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)action:(UIButton*)sender {
    MYWCalendarController *calendarVC = [[MYWCalendarController alloc]init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
