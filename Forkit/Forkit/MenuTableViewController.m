//
//  MenuTableViewController.m
//  Forkit
//
//  Created by david on 2016. 12. 2..
//  Copyright © 2016년 david. All rights reserved.
//

#import "MenuTableViewController.h"
#import "RestaurantDetailCell.h"


@interface MenuTableViewController ()

@property NSArray *menuList;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    MenuTableViewController * __weak weakSelf = self;
    [FIRequestObject requestMenuListWithRestaurantPk:_restaurnatPk
                           didReceiveUpdateDataBlock:^{

                               [weakSelf didReceiveUpdateMenuList];
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveUpdateMenuList
{
    self.menuList = [[FIMenuDataManager sharedManager] menuDatas];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _menuList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    
//    cell.imageView.image
    if (_menuList.count != 0 && _menuList != nil)
    {
        NSDictionary *menuDict = [_menuList objectAtIndex:indexPath.row];
        if ([menuDict objectForKey:JSONCommonThumbnailImageURLKey] != nil)
        {
            [cell.menuImageView sd_setImageWithURL:[menuDict objectForKey:JSONCommonThumbnailImageURLKey]];
        }
        cell.menuNameLabel.text = [menuDict objectForKey:JSONMenuNameKey];
        cell.menuCostLabel.text = [menuDict objectForKey:JSONMenuPriceKey];
    }
    
    return cell;
}
- (IBAction)clickPopButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
