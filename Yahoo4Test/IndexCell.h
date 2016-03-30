//
//  IndexCell.h
//  Yahoo4Test
//
//  Created by Denis on 30.03.16.
//  Copyright © 2016 KDL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *highestPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowestPriceLabel;

@end
