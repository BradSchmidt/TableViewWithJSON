//
//  TableViewCell.h
//  CodingChallenge
//
//  Created by Bradley Robert Schmidt on 11/16/14.
//  Copyright (c) 2014 Bradley Robert Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
