//
//  ClockView.m
//  Printer3D
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "ClockView.h"

//最大错误次数
#define kMaxError 3

@interface ClockView ()

@property (nonatomic, strong) NSMutableArray *selectedBtnArray;
//当前手指所在的点
@property (nonatomic, assign) CGPoint curP;
@property(nonatomic,strong) CAShapeLayer * pCurrentLayer;

@end


@implementation ClockView
//绑定
@synthesize mddDelegate=_mddDelegate;
-(id) init
{
    if (self=[super init]) {
        // 添加子控件
        [self setUp];
        [self doLoadConfig];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        // 添加子控件
        [self setUp];
        [self doLoadConfig];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super initWithCoder:aDecoder]) {
        // 添加子控件
        [self setUp];
        [self doLoadConfig];
    }
    return self;
}

- (NSMutableArray *)selectedBtnArray{
    if (_selectedBtnArray == nil) {
        _selectedBtnArray = [NSMutableArray array];
    }
    return _selectedBtnArray;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];

}

// 开始触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 获取到第一次触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point =[touch locationInView:self];
    
    // 取出按钮
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
            [self.selectedBtnArray addObject:btn];
        }
    }
    
}
// 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 取出当前触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.curP = point;
    
    // 取出按钮
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point) && btn.selected == NO) {
            btn.selected = YES;
            [self.selectedBtnArray addObject:btn];
        }
    }
    
    // 重绘
    [self setNeedsDisplay];
}
// 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableString *str = [NSMutableString string];
    // 取消所有选中的按钮
    for(int i = 0; i < self.selectedBtnArray.count; i++){
        
        UIButton *btn = self.selectedBtnArray[i];
        btn.selected = NO;
        NSLog(@"%ld", (long)btn.tag);
        [str appendFormat:@"%ld", (long)btn.tag];
    }
    
    // 移除所有线
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
    
    if (![str isEqualToString:self.mPassWord]) {
        [self.mddDelegate MddClockViewCallBackWithView:self IsOk:NO UserStr:str];
    }else{
        [self.mddDelegate MddClockViewCallBackWithView:self IsOk:YES UserStr:str];
    }

    /*
    NSLog(@"%@", str);
    switch (self.mState) {
        case MddClockViewStateCreatePwd:
        {
            NSLog(@"新建密码");
            
            break;
        }
        case MddClockViewStateSurePwd:
        {
            NSLog(@"确定密码");
            
            break;
        }
        case MddClockViewStateInputPwd:
        {
            NSLog(@"输入密码");
            
            break;
        }
        case MddClockViewStateInputError:
        {
            NSLog(@"密码错误");
            if (self.mErrorCount>=kMaxError) {
                [self doClear];
            }
            break;
        }
        case MddClockViewStateInputOk:
        {
            NSLog(@"密码正确");
            
            break;
        }
        case MddClockViewStateInputErrorToMore:
        {
            NSLog(@"错误太多次密码");
            
            break;
        }
        default:
        {
            
            break;
        }
    }
    
    if (![str isEqualToString:self.mPassWord]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您输入的密码有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        [self doClear];
    }else{
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"密码正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
    }
     */
    
}


- (void)drawRect:(CGRect)rect {
    
    if (self.selectedBtnArray.count) {
        if (self.pCurrentLayer!=nil) {
            [self.pCurrentLayer removeFromSuperlayer];
        }
        // 画线
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        // 绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // 取出每个按钮
        for(int i = 0; i < self.selectedBtnArray.count; i++){
            UIButton *btn = self.selectedBtnArray[i];
            // 判断是不是第一个按钮
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                [path addLineToPoint:btn.center];
            }
        }
        
        [path addLineToPoint:self.curP];
        
        [path setLineWidth:10];
        [[UIColor redColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        //[path stroke];
        
        shapeLayer.path=[path CGPath];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor redColor] CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        self.pCurrentLayer=shapeLayer;
        [self.layer addSublayer:self.pCurrentLayer];
    }
    
    
    
}


// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //    NSLog(@"%@", self.btn);
    int colnum = 3;
    //    int row = 3;
    int btnWH = 74;
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat margin = (self.bounds.size.width - (btnWH * colnum)) / (colnum + 1);
    
    int curC = 0;
    int curR = 0;
    
    for(int i = 0; i < self.subviews.count; i++){
        
        // 求出当前所在列
        curC = i % colnum;
        curR = i / colnum;
        x = margin + curC * (margin + btnWH);
        y = margin + curR * (margin + btnWH);
        
        // 取出每个按钮
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
        
        
        
    }
}
-(void) doClear
{
    if (self.selectedBtnArray !=nil) {
            [self.selectedBtnArray removeAllObjects];
    }
    if (self.pCurrentLayer!=nil) {
        [self.pCurrentLayer removeFromSuperlayer];
    }
}
//消失
-(void) doDismissView
{
    [self doSaveConfig];
    [self removeFromSuperview];
}
-(void) doLoadConfig
{
    self.isOpen=[@"Y" isEqualToString:[ConfigService valueForName:@"NightLockOpen"]];
    self.mPassWord=[ConfigService valueForName:@"NightLockPassword"];
    self.mErrorCount=[[ConfigService valueForName:@"NightLockErrorCount"] intValue];
    self.mState=[[ConfigService valueForName:@"NightLockState"] intValue];
}
//保存状态
-(void) doSaveConfig
{
    if (self.isOpen) {
        [ConfigService editWithName:@"NightLockOpen" value:kStrDef_Y];
    }else{
        [ConfigService editWithName:@"NightLockOpen" value:kStrDef_N];
    }
    [ConfigService editWithName:@"NightLockPassword" value:self.mPassWord];
    [ConfigService editWithName:@"NightLockErrorCount" value:[NSString stringWithFormat:@"%d",self.mErrorCount]];
    [ConfigService editWithName:@"NightLockState" value:[NSString stringWithFormat:@"%lu",(unsigned long)self.mState]];
}
-(void) doResetDef
{
    [ConfigService editWithName:@"NightLockOpen" value:kStrDef_N];
    [ConfigService editWithName:@"NightLockPassword" value:@""];
    [ConfigService editWithName:@"NightLockErrorCount" value:@"0"];
    [ConfigService editWithName:@"NightLockState" value:[NSString stringWithFormat:@"%lu",(unsigned long)MddClockViewStateCreatePwd]];
}
-(void) doResetError
{
    [ConfigService editWithName:@"NightLockErrorCount" value:@"0"];
    [ConfigService editWithName:@"NightLockState" value:[NSString stringWithFormat:@"%lu",(unsigned long)MddClockViewStateInputPwd]];
}

- (void)setUp{
    
    for(int i = 0; i < 9; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:@"rb_unselected"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"rb_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}
+(instancetype) initForNib
{
    return [[ClockView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH)];
}
+(instancetype) initForNibWithRect:(CGRect)pRect
{
    return [[ClockView alloc] initWithFrame:pRect];
}

+(instancetype) initForNibWithDelegate:(id<ClockViewDelegate>)pmddDelegate
{
    ClockView * v=[[self class]initForNib];
    v.mddDelegate=pmddDelegate;
    return v;
}
+(instancetype) initForNibWithRect:(CGRect)pRect WithDelegate:(id<ClockViewDelegate>)pmddDelegate
{
    ClockView * v=[[self class]initForNibWithRect:pRect WithDelegate:pmddDelegate];
    return v;
}
@end
