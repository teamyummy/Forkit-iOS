//
//  SearchViewController.m
//  Forkit
//
//  Created by david on 2016. 11. 28..
//  Copyright © 2016년 david. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTextField];
}
- (void)createTextField
{
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor whiteColor];
    textField.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = textField;
    
    [textField becomeFirstResponder];
}
- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clcikSearchButton:(UIBarButtonItem *)sender {
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
