//
//  IndexesTableViewController.m
//  Yahoo4Test
//
//  Created by Denis on 30.03.16.
//  Copyright © 2016 KDL. All rights reserved.
//

#import "IndexesTableViewController.h"
#import "IndexClass.h"
#import "IndexCell.h"

@interface IndexesTableViewController ()

@end

@implementation IndexesTableViewController {
    NSMutableArray * indexArray;
    UIActivityIndicatorView *activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showActivityView];
    
    [self retrieveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) retrieveData {
    indexArray = [[NSMutableArray alloc]init];
    
    NSString *resultString= @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22YHOO%22%2C%22AAPL%22%2C%22GOOG%22%2C%22MSFT%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json";
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:resultString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                // 1 YHOO 2 AAPPL 3 GOOG 4 MSFT
                for (int i = 0; i < 4; i++) {
                    IndexClass * newIndex = [[IndexClass alloc] init];
                    newIndex.indexName = [[[[[dataJSON objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:i] objectForKey:@"symbol"];
                    newIndex.highestIndex = [[[[[dataJSON objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:i] objectForKey:@"DaysHigh"];
                    newIndex.lowestIndex = [[[[[dataJSON objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:i] objectForKey:@"DaysLow"];
                    newIndex.currentPrice = [[[[[dataJSON objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:i] objectForKey:@"Ask"];
                    newIndex.dinamycs = [[[[[dataJSON objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"quote"] objectAtIndex:i] objectForKey:@"Change"];
                    
                    [indexArray insertObject:newIndex atIndex:i];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [activityView stopAnimating];
                });
                
            }] resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return indexArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    IndexClass *obj = indexArray[indexPath.row];
    
    cell.nameLabel.text = obj.indexName;
    cell.priceLabel.text = obj.currentPrice;
    cell.highestPriceLabel.text = obj.highestIndex;
    cell.lowestPriceLabel.text = obj.lowestIndex;
    cell.dynamicsLabel.text = obj.dinamycs;
    
    
    return cell;
}

- (void) showActivityView {
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.frame = CGRectMake(20.0, 0.0, 50.0, 50.0);
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
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
