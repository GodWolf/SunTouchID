//
//  ViewController.m
//  SunTouchID
//
//  Created by 孙兴祥 on 2017/9/13.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SunKeychainTool.h"

@interface ViewController ()

@property (nonatomic,assign) BOOL isCanUseTouchID;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (IBAction)avaliableAction:(UIButton *)sender {
    
    LAContext *context = [[LAContext alloc] init];
    BOOL success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    if(success){
        NSLog(@"can use");
        _isCanUseTouchID = YES;
    }else{
        NSLog(@"can`t user ");
        _isCanUseTouchID = NO;
    }
    
}

- (IBAction)userTouchIDAction:(UIButton *)sender {
    
    if(_isCanUseTouchID == NO){
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"自定义标题";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"为什么使用TouchID写这里" reply:^(BOOL success, NSError * _Nullable error) {
       
        if(success){
            //指纹验证成功
        }else{
        
            switch (error.code) {
                case LAErrorUserFallback:{
                    NSLog(@"用户选择输入密码");
                    break;
                }
                case LAErrorAuthenticationFailed:{
                    NSLog(@"验证失败");
                    break;
                }
                case LAErrorUserCancel:{
                    NSLog(@"用户取消");
                    break;
                }
                case LAErrorSystemCancel:{
                    NSLog(@"系统取消");
                    break;
                }
                //以下三种情况如果提前检测TouchID是否可用就不会出现
                case LAErrorPasscodeNotSet:{
                    break;
                }
                case LAErrorTouchIDNotAvailable:{
                    break;
                }
                case LAErrorTouchIDNotEnrolled:{
                    break;
                }
                    
                default:
                    break;
            }
        }
    }];
}

- (IBAction)savePssword:(UIButton *)sender {
    
    
    if([[SunKeychainTool shareInstance] setAccount:_userName.text password:_password.text]){
        NSLog(@"save success");
    }else{
        NSLog(@"save fail");
    }
}


- (IBAction)getPassword:(UIButton *)sender {
    
    NSString *pwd = [[SunKeychainTool shareInstance] getPasswordWithAccount:_userName.text];
    if(pwd){
        NSLog(@"password %@",pwd);
    }else{
        NSLog(@"not exist");
    }
}


- (IBAction)deleteKeychain:(UIButton *)sender {
    
    if([[SunKeychainTool shareInstance] deletePasswordWithAccount:_userName.text]){
        NSLog(@"delete success");
    }else{
        NSLog(@"delete fail");
    }
}

@end
