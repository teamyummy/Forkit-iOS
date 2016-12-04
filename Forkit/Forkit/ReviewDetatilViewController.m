//
//  ReviewDetatilViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 2..
//  Copyright © 2016년 david. All rights reserved.
//

#import "ReviewDetatilViewController.h"

@interface ReviewDetatilViewController ()

@end

@implementation ReviewDetatilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
