//
//  NightPwdCZView.h
//  Printer3D
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>
//1.界面 ,九个按钮 , 设置frame
//2. 设置按钮的高亮状态
//3. 画线
//4. 验证密码是否正确
//5. 正确: 按钮高亮状态消失, 线消失
//6.不正确: 按钮红色, 线消失: 按钮状态消失

//7. 多出来的一截线

@interface NightPwdCZView : UIView
//选中按钮的数组
/**
 *  <#Description#>
 */
@property (nonatomic,strong) NSMutableArray <UIButton *> *selectedArray;

//线条颜色的属性
@property(nonatomic,strong)UIColor *lineColor;

//接收 多余的点
@property(nonatomic,assign)CGPoint destdationPoint;

//构造函数
+ (instancetype)initializeForNib;

@end
