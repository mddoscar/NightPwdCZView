//
//  ClockView.h
//  Printer3D
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mdd.oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

//简直对
@class ClockView;
//传参数协议
@protocol ClockViewDelegate
//结束事件(视图，是否正确,用户输入的字符串)
-(void) MddClockViewCallBackWithView:(ClockView *) mClockView IsOk:(BOOL)pIsOk UserStr:(NSString *)pUserStr;
@end
typedef NS_ENUM(NSUInteger, MddClockViewState) {
    MddClockViewStateCreatePwd=1      //创建密码
    ,MddClockViewStateSurePwd=2      //确定密码
    ,MddClockViewStateInputPwd=3      //输入密码
    ,MddClockViewStateInputError=4      //密码错误
    ,MddClockViewStateInputOk=6      //密码输入正确
    ,MddClockViewStateInputErrorToMore=7      //密码输入错误太多次
};

@interface ClockView : UIView<ClockViewDelegate>
{
    //代理
    id <ClockViewDelegate> mddDelegate;
}
#pragma mark 成员
@property (nonatomic,strong) id<ClockViewDelegate> mddDelegate;
@property(nonatomic,strong)NSString * mPassWord;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign) MddClockViewState mState;
//第一个密码
@property(nonatomic,copy) NSString * mFirstPwd;
//确定密码
@property(nonatomic,copy) NSString * mSurePwd;
//错误次数
@property(nonatomic,assign) int mErrorCount;

#pragma mark
-(void) doClear;
//消失
-(void) doDismissView;
-(void) doLoadConfig;
-(void) doSaveConfig;
-(void) doResetDef;
-(void) doResetError;
- (void)setUp;
#pragma mark ctor
+(instancetype) initForNib;
+(instancetype) initForNibWithRect:(CGRect)pRect;
+(instancetype) initForNibWithDelegate:(id<ClockViewDelegate>)pmddDelegate;
+(instancetype) initForNibWithRect:(CGRect)pRect WithDelegate:(id<ClockViewDelegate>)pmddDelegate;

@end
