//
//  LoginViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 6..
//  Copyright © 2016년 david. All rights reserved.
//

#import "LoginViewController.h"
#import "RoundButton.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet RoundButton *loginButton;

@end

@implementation LoginViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setLoginButtonState];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeTextFiledText:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.idTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - custom method
- (void)setLoginButtonState
{
    self.loginButton.enabled = NO;
    [_loginButton setBackgroundColor:UIColorFromRGB(0xE0E0E0)];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"should return");
    if (textField == _idTextField)
    {
        [_pwTextField becomeFirstResponder];
    }
    return YES;
}

#pragma mark - did notification method
- (void)didChangeTextFiledText:(NSNotification *)noti
{
    if (![_idTextField.text containsString:@" "] &&
        ![_pwTextField.text containsString:@" "] &&
        _idTextField.text.length != 0 &&
        _pwTextField.text.length != 0 &&
        _loginButton.enabled == NO)
    {
        [_loginButton setBackgroundColor:[FIUtilities createKeyColor]];
        _loginButton.enabled = YES;
    } else if ([_idTextField.text containsString:@" "] ||
               [_pwTextField.text containsString:@" "] ||
               _idTextField.text.length == 0 ||
               _pwTextField.text.length == 0)
    {
        if (_loginButton.enabled == YES)
        {
            [_loginButton setBackgroundColor:UIColorFromRGB(0xE0E0E0)];
            _loginButton.enabled = NO;
        }
    }
}

#pragma mark - click button
- (IBAction)clickLoginButton:(UIButton *)sender
{
    __weak LoginViewController *weakSelf = self;
    
    id successBlcok = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    id failedBlcok = ^{
        [weakSelf showAlert];
    };
    
    [FIRequestObject requestLoginTokenWithUserId:self.idTextField.text
                                          userPw:self.pwTextField.text
                                         success:successBlcok
                                          failed:failedBlcok];
}

- (void)showAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"오류"
                                                                   message:@"아이디 혹은 비밀번호가 틀렸습니다"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
