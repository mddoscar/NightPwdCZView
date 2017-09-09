//
//  NightLockViewController.m
//  Printer3D
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 mdd.oscar. All rights reserved.
//

#import "NightLockViewController.h"
#import "ClockView.h"

@interface NightLockViewController ()<ClockViewDelegate>
{

}
@end

@implementation NightLockViewController
@synthesize mClockView=_mClockView;
@synthesize mMsgLabel=_mMsgLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) myInit
{
    if (_mClockView==nil) {
        _mClockView=[ClockView initForNib];
        [_mClockView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_mClockView];
    }else{
        [_mClockView doDismissView];
        _mClockView=nil;
    }
}

#pragma mark ClockViewDelegate
-(void) MddClockViewCallBackWithView:(ClockView *) mClockView IsOk:(BOOL)pIsOk UserStr:(NSString *)pUserStr
{
    
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
