//
//  JDataCurveView.h
//  CoordinateCurveDemo
//
//  Created by jiangtd on 16/2/18.
//  Copyright © 2016年 jiangtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDataCurveView : UIView

//如果显示数据需经常刷新数据,值该值为yes，否则no
@property(nonatomic,assign)BOOL isDynamicRefreshData;
//Y坐标轴名称
@property(nonatomic,copy)NSString* yCoordinateName;
//Y坐标轴的单位名称
@property(nonatomic,copy)NSString* yCoordinateUnitName;
//X坐标轴名称
@property(nonatomic,copy)NSString* xCoordinateName;
//Y坐标轴的单位名称
@property(nonatomic,copy)NSString* xCoordinateUnitName;

//曲线条颜色
@property(nonatomic,strong)UIColor *curveColor;
//单位名称显示颜色
@property(nonatomic,strong)UIColor* unitNameColor;
//单位数据显示的颜色
@property(nonatomic,strong)UIColor* unitDataDisplayColor;
//坐标轴颜色
@property(nonatomic,strong)UIColor* coordinateColor;

//y轴显示数据
@property(nonatomic,strong)NSArray *yDisplayData;
//x轴显示数据
@property(nonatomic,strong)NSArray *xDisplayData;
//中间曲线数据
@property(nonatomic,strong)NSArray *dataArrary;

//是否填充曲线下部分内容
@property(nonatomic,assign)BOOL isNeedFill;
//填充曲线下部分内容颜色值
@property(nonatomic,strong)UIColor *fillColor;

@property(nonatomic,assign)CGFloat xMaxData;
@property(nonatomic,assign)CGFloat yMaxData;

@property(nonatomic,assign)BOOL isNeedDisplayXData;
@property(nonatomic,assign)BOOL isNeedDisplayYData;

+(JDataCurveView*)dataCurveView;
-(void)resetDataArray:(NSArray *)dataArrary;

@end
