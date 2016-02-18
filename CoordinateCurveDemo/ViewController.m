//
//  ViewController.m
//  CoordinateCurveDemo
//
//  Created by jiangtd on 16/2/18.
//  Copyright © 2016年 jiangtd. All rights reserved.
//

#import "ViewController.h"
#import "JDataCurveView.h"

@interface ViewController ()

@property(nonatomic,weak)JDataCurveView *dataCurveView;
@property(nonatomic,strong)NSMutableArray *dArray;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testDataCurveView1];
    [self testDataCurveView2];
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

-(void)testDataCurveView1
{
    //随机参数数据
    NSMutableArray *dataArray = [NSMutableArray array];
    for( float i = 0; i<= 70 ;i+=1)
    {
        CGFloat value = arc4random() % 201;
        CGPoint point = CGPointMake(i, value);
        [dataArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    JDataCurveView *dataCurveView = [JDataCurveView dataCurveView];
    dataCurveView.frame = CGRectMake(10, 64, self.view.frame.size.width - 20, 250);
    dataCurveView.yCoordinateName = @"海拔";
    dataCurveView.yCoordinateUnitName = @"米";
    dataCurveView.xCoordinateName = @"时间";
    dataCurveView.xCoordinateUnitName = @"分";
    dataCurveView.yDisplayData = @[@0,@50,@100,@150,@200];
    dataCurveView.xDisplayData = @[@0,@20,@40,@60,@70];
    dataCurveView.dataArrary = dataArray;
    dataCurveView.curveColor = [UIColor blueColor];
    dataCurveView.xMaxData = 70;
    dataCurveView.yMaxData = 200;
    [self.view addSubview:dataCurveView];
}

-(void)testDataCurveView2
{
    _dArray = [NSMutableArray array];
    //随机参数数据
    for( float i = 0; i<= 80 ;i+=1)
    {
        CGFloat value = arc4random() % 45 + 20;
        CGPoint point = CGPointMake(i, value);
        [self.dArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    JDataCurveView *dataCurveView = [JDataCurveView dataCurveView];
    dataCurveView.frame = CGRectMake(10, 340, self.view.frame.size.width - 20, 250);
    dataCurveView.isDynamicRefreshData = YES;
    dataCurveView.yCoordinateName = @"脉搏";
    dataCurveView.yCoordinateUnitName = @"次";
    dataCurveView.xCoordinateUnitName = @"无";
    dataCurveView.yDisplayData = @[@0,@20,@40,@60,@80];
    dataCurveView.xDisplayData = @[@0,@20,@40,@60,@80];
    dataCurveView.isNeedDisplayXData = NO;
    dataCurveView.dataArrary = self.dArray;
    dataCurveView.curveColor = [UIColor brownColor];
    dataCurveView.xMaxData = 80;
    dataCurveView.yMaxData = 80;
    _dataCurveView = dataCurveView;
    [self.view addSubview:dataCurveView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

-(void)timerAction
{
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 1;i<self.dArray.count;i++)
    {
        NSValue *value = self.dArray[i];
        CGPoint point = [value CGPointValue];
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y)]];

    }
    [self.dArray removeAllObjects];
    
    CGFloat value = arc4random() % 45 + 20;
    CGPoint point = CGPointMake(80, value);
    [array addObject:[NSValue valueWithCGPoint:point]];
    self.dArray = array;
    [_dataCurveView resetDataArray:self.dArray];
}


@end











