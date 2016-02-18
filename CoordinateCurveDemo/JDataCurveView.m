//
//  JDataCurveView.m
//  CoordinateCurveDemo
//
//  Created by jiangtd on 16/2/18.
//  Copyright © 2016年 jiangtd. All rights reserved.
//

#import "JDataCurveView.h"

@interface JDataCurveView ()

@property(nonatomic,strong)UIImage *coordinateBackgroundImg;
@property(nonatomic,strong)UIImage *dataDispalyImg;

@property(nonatomic,strong)UIImageView *coordinateBackgroundImgView;
@property(nonatomic,strong)UIImageView *dataDispalyImgView;

@property(nonatomic,strong)dispatch_queue_t queue;

@end

@implementation JDataCurveView

+(JDataCurveView*)dataCurveView
{
    return [[JDataCurveView alloc] init];
}

-(id)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    _isNeedDisplayXData = YES;
    _isNeedDisplayYData = YES;
    _coordinateBackgroundImgView = [[UIImageView alloc] init];
    [self addSubview:_coordinateBackgroundImgView];
    
    _dataDispalyImgView = [[UIImageView alloc] init];
    [self addSubview:_dataDispalyImgView];
}

-(void)layoutSubviews
{
    _coordinateBackgroundImgView.frame = self.bounds;
    _dataDispalyImgView.frame = CGRectMake(40 + 1, 35 + 10, self.bounds.size.width - 30 - 41 - 10, self.bounds.size.height - 50 - 35 - 1 - 10);
}

-(void)drawRect:(CGRect)rect
{
    if (!_coordinateBackgroundImg) {
        [self drawCoordinateBackgroundImg];
    }
    if (_isDynamicRefreshData) {
        [self drawDataImg];
    }
    else
    {
        if (!_dataDispalyImg) {
            [self drawDataImg];
        }
    }
}

-(void)resetDataArray:(NSArray *)dataArrary
{
    if (_isDynamicRefreshData) {
        _dataArrary = dataArrary;
        [self drawDataImg];
    }
}

-(void)drawDataImg
{
    if (!_dataArrary || _dataArrary.count <=0) {
        return;
    }
    
    dispatch_queue_t queue = NULL;

    if (_isDynamicRefreshData) {
        //创建串行队列
        _queue = dispatch_queue_create("com.draw.dataImg", DISPATCH_QUEUE_SERIAL);
        queue = _queue;
    }
    else
    {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    dispatch_async(queue, ^{
        
        UIGraphicsBeginImageContext(_dataDispalyImgView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        CGPoint point = [_dataArrary[0] CGPointValue];
        
        CGFloat xLength = _dataDispalyImgView.frame.size.width;
        CGFloat yLength = _dataDispalyImgView.frame.size.height;
        CGFloat xValue = point.x;
        CGFloat yValue = point.y;
        
        [[UIColor clearColor] setFill];
        if (!_curveColor) {
            _curveColor = [UIColor whiteColor];
        }
        [_curveColor setStroke];
        CGContextFillEllipseInRect(context, _dataDispalyImgView.bounds);
        
        [bezierPath moveToPoint:CGPointMake((xValue / _xMaxData) * xLength, yLength - (yValue / _yMaxData ) * yLength)];
        
        for (NSValue *value in _dataArrary)
        {
            point = [value CGPointValue];
            xValue = point.x;
            yValue = point.y;

            [bezierPath addLineToPoint:CGPointMake((xValue / _xMaxData) * xLength, yLength - (yValue / _yMaxData ) * yLength)];
            
        }
        
//        point = [_dataArrary[_dataArrary.count - 1] CGPointValue];
//        xValue = point.x;
//        yValue = point.y;
//        
//        [bezierPath addLineToPoint:CGPointMake((xValue / 70) * xLength, yLength)];
//        [bezierPath addLineToPoint:CGPointMake(0, yLength)];

//        [[UIColor grayColor] setFill];
        
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        CGContextFillPath(context);
        
        
        _dataDispalyImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        dispatch_async(dispatch_get_main_queue(), ^{
            _dataDispalyImgView.image = _dataDispalyImg;
        });
        
    });
}

-(void)drawCoordinateBackgroundImg
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContext(self.bounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (!_unitNameColor) {
            _unitNameColor = [UIColor grayColor];
        }
        CGContextSetRGBFillColor(context, 1, 0, 0, 1);

        if (!_yCoordinateName) {
            _yCoordinateName = @"Y轴";
        }
        
        NSString *yCoordinateName = [NSString stringWithFormat:@"%@:%@",_yCoordinateName,_yCoordinateUnitName?_yCoordinateUnitName:@""];
        [yCoordinateName drawAtPoint:CGPointMake(10,10) withAttributes:@{NSForegroundColorAttributeName:_unitNameColor}];
        
        if (!_xCoordinateName) {
            _xCoordinateName = @"X轴";
        }
        NSString *xCoordinateName = [NSString stringWithFormat:@"%@:%@",_xCoordinateName,_xCoordinateUnitName?_xCoordinateUnitName:@""];
        [xCoordinateName drawAtPoint:CGPointMake(self.bounds.size.width - 30 - 25, self.bounds.size.height - 20) withAttributes:@{NSForegroundColorAttributeName:_unitNameColor}];
        
        
        if (!_coordinateColor) {
            _coordinateColor = [UIColor grayColor];
        }
        
        CGContextSetStrokeColorWithColor(context, _coordinateColor.CGColor);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        //画坐标系
        [bezierPath moveToPoint:CGPointMake(40, 35)];
        [bezierPath addLineToPoint:CGPointMake(40, self.bounds.size.height - 50)];
        [bezierPath addLineToPoint:CGPointMake(self.bounds.size.width - 30, self.bounds.size.height - 50)];
        
        if (!_unitDataDisplayColor) {
            _unitDataDisplayColor = [UIColor whiteColor];
        }
        //画Y坐标刻度
        if (_yDisplayData && _yDisplayData.count > 0) {
            
            CGFloat yMaxData = [_yDisplayData[_yDisplayData.count - 1] floatValue];
            CGFloat yMaxLength = self.bounds.size.height - 35 - 50 - 10;
            CGFloat orgY = self.bounds.size.height - 50;
            
            for (NSNumber *yNum in _yDisplayData) {
                CGFloat length = yMaxLength * ([yNum floatValue] / yMaxData);
                if ([yNum floatValue] != 0) {
                    CGContextMoveToPoint(context, 40, orgY - length);
                    CGContextAddLineToPoint(context, 45, orgY - length);
                }
                
                if (_isNeedDisplayYData) {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",yNum];
                    [dataStr drawAtPoint:CGPointMake(10, orgY - length - 10) withAttributes:@{NSForegroundColorAttributeName:_unitDataDisplayColor}];
                }
               
            }
        }
       
        //画X坐标刻度
        if (_xDisplayData && _xDisplayData.count > 0) {
            
            CGFloat xMaxData = [_xDisplayData[_xDisplayData.count - 1] floatValue];
            CGFloat xMaxLength = self.bounds.size.width - 40 - 30 - 10;
            CGFloat orgX = 40;
            
            for (NSNumber *xNum in _xDisplayData) {
                CGFloat length = xMaxLength * ([xNum floatValue] / xMaxData);
                if ([xNum floatValue] != 0) {
                    CGContextMoveToPoint(context,orgX + length, self.bounds.size.height - 50);
                    CGContextAddLineToPoint(context, orgX + length, self.bounds.size.height - 50 - 5);
                }
                
                if (_isNeedDisplayXData) {
                    NSString *dataStr = [NSString stringWithFormat:@"%@",xNum];
                    [dataStr drawAtPoint:CGPointMake(orgX + length - 8, self.bounds.size.height - 50 + 5) withAttributes:@{NSForegroundColorAttributeName:_unitDataDisplayColor}];
                }
            }
        }

        CGContextAddPath(context, bezierPath.CGPath);
        CGContextStrokePath(context);
        _coordinateBackgroundImg  = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _coordinateBackgroundImgView.image = _coordinateBackgroundImg;
        });
        
    });
}

@end













