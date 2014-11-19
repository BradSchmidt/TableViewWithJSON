//
//  HomeViewController.h
//  CodingChallenge
//
//  Created by Bradley Robert Schmidt on 11/16/14.
//  Copyright (c) 2014 Bradley Robert Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    UILabel *highScore;
    UILabel *yourRank;
    UIImageView *yourImage;
}

@property (nonatomic, strong) NSDictionary *peopleDictionary;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;
- (void)setThumbnailDataFromImage:(UIImage *)image;


@end
