//
//  NightPwdCZView.m
//  Printer3D
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import "NightPwdCZView.h"
#define NIBNAME @"NightPwdCZView"

@implementation NightPwdCZView
- (id)init{
    if(self=[super init]){
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:NIBNAME owner:self options:nil];
        [self addSubview:[views objectAtIndex:0]];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled=YES;
        self.layer.borderWidth=1.0;
        self.layer.borderColor=[UIColor colorWithWhite:0.5 alpha:0.1].CGColor;
        self.clipsToBounds=YES;
        self.layer.cornerRadius=5;
        self.layer.backgroundColor=[UIColor whiteColor].CGColor;
    }
    return self;
}
- (UIColor *)lineColor
{
    if (!_lineColor) {
        
        _lineColor = [UIColor whiteColor];
    }
    
    return _lineColor;
    
}
- (NSMutableArray<UIButton *> *)selectedArray
{
    if (!_selectedArray) {
        
        _selectedArray = [NSMutableArray array];
    }
    
    return _selectedArray;
}

#pragma mark - 3.0画线

//画线
- (void)drawRect:(CGRect)rect {
    
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSInteger i = 0; i < self.selectedArray.count; i++) {
        //起点
        if (i == 0) {
            
            [path moveToPoint:self.selectedArray[i].center];
        }else{
            
            [path addLineToPoint:self.selectedArray[i].center];
        }
        
        //终点
    }
    
    //画多出来的线
    if (self.selectedArray.count > 0) {
        
        [path addLineToPoint:self.destdationPoint];
        
    }
    
    //设置颜色
    [self.lineColor set];
    
    //渲染
    [path stroke];
    
}

#pragma mark - 2.0 设置按钮的高亮
//1. 触摸的位置
//2. 触摸的按钮 高亮
//3. 判断你触摸的点 是否在按钮的范围内: 如果是存在的 设置高亮

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1. 触摸的位置
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    self.destdationPoint = loc;
    
    //2. 触摸的按钮 高亮
    //3. 判断你触摸的点 是否在按钮的范围内: 如果是存在的 设置高亮
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIButton *btn = self.subviews[i];
        //&& !btn.highlighted 避免重复添加 已经高亮的按钮
        if (CGRectContainsPoint(btn.frame, loc) && !btn.highlighted) {//如果是存在的
            
            //设置高亮
            btn.highlighted = YES;
            
            //添加到选中按钮中
            [self.selectedArray addObject:btn];
            
        }
    }
    
    //重绘
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1. 触摸的位置
    UITouch *touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    
    //接收 多出来的点
    self.destdationPoint = loc;
    
    //2. 触摸的按钮 高亮
    //3. 判断你触摸的点 是否在按钮的范围内: 如果是存在的 设置高亮
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIButton *btn = self.subviews[i];
        if (CGRectContainsPoint(btn.frame, loc)&& !btn.highlighted) {//如果是存在的
            
            //设置高亮
            btn.highlighted = YES;
            
            //添加到选中按钮中
            [self.selectedArray addObject:btn];
            
        }
    }
    
    //重绘
    [self setNeedsDisplay];
}

#pragma mark - 4.0 验证密码

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //设置 多出来的点 在 手指抬起的时候为 选中按钮集合的最后一个
    self.destdationPoint = [[self.selectedArray lastObject] center];
    
    //1.获取密码
    NSMutableString *pwd = [NSMutableString string];
    for(UIButton *btn in self.selectedArray){
        
        //拼接密码
        [pwd appendFormat:@"%@",@(btn.tag)];
        
    }
    
    //2. 验证
    
    if([pwd isEqualToString:@"012"]){//正确
        // 正确: 按钮高亮状态消失, 线消失
        
        [self clearPath];
        
    }else{
        
        //不正确: 按钮红色, 线消失: 按钮状态消失
        
        for (UIButton *btn in self.selectedArray) {
            
            //按钮的状态 不能同时存在
            btn.highlighted = NO;
            btn.selected = YES;
            
        }
        
        //设置 线条颜色 为红色
        self.lineColor = [UIColor redColor];
        
        //重绘
        [self setNeedsDisplay];
        
        //关闭 交互
        self.userInteractionEnabled = NO;
        
        //延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self clearPath];
            
            //开启交互
            self.userInteractionEnabled = YES;
            
        });
    }
    
}

//清空画线集合
- (void)clearPath
{
    
    //将原先的红色 在设置为白色
    self.lineColor = [UIColor whiteColor];
    
    //取消按钮的高亮
    for(UIButton *btn in self.selectedArray){
        
        btn.highlighted = NO;
        btn.selected = NO;
        
    }
    
    //清空 画线的集合
    [self.selectedArray removeAllObjects];
    
    //重绘
    [self setNeedsDisplay];
    
}

#pragma mark - 1.0添加9个按钮

//1. aweakformnib
//2. 懒加载
//创建9个按钮
- (void)awakeFromNib
{
    
    [self doAddSubButtons];
}

-(void) doAddSubButtons
{
    for(NSInteger i = 0;i < 9;i++){
        
        //创建按钮
        UIButton *btn = [[UIButton alloc]init];
        
        //设置tag 是为了验证密码
        btn.tag = i;
        
        //关闭按钮的交互 是为了 触摸事件
        btn.userInteractionEnabled = NO;
        
        //设置背景图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        //设置按钮的高亮图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateHighlighted];
        
        //设置按钮的选中状态
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
        
        //添加
        [self addSubview:btn];
    }
}

//设置按钮的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        //九宫格布局
        CGFloat W = self.bounds.size.width;
        CGFloat H = self.bounds.size.height;
        
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        //计算间隔
        //列数
        NSInteger columns = 3;
        // 总宽度 - 3个按钮的宽度 / 2
        CGFloat margW = (W - columns * btnW)/(columns - 1);
        CGFloat margH = margW;
        
        //列的索引
        NSInteger col = i % columns;
        //行的索引
        NSInteger row = i / columns;
        
        CGFloat btnX = col * (margW + btnW);
        CGFloat btnY = row * (margH + btnH);
        
        //设置按钮的frame
        UIButton *btn = self.subviews[i];
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
}

+ (instancetype)initializeForNib
{
    NightPwdCZView *mddV = [[[self class] alloc] init];
    return mddV;
}
@end
