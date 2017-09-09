//
//  NightLockViewController.h
//  Printer3D
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClockView;
/*
 九宫格控制器
 */
@interface NightLockViewController : UIViewController


#pragma mark ui

@property(nonatomic,strong) ClockView * mClockView;
@property(nonatomic,strong) UILabel * mMsgLabel;


@end
