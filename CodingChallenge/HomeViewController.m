//
//  HomeViewController.m
//  CodingChallenge
//
//  Created by Bradley Robert Schmidt on 11/16/14.
//  Copyright (c) 2014 Bradley Robert Schmidt. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kChallengeURL [NSURL URLWithString:@"https://keith.fanfareentertainment.com/api/v4/games/matching.json"]
#import "HomeViewController.h"

#import "TableViewCell.h"

/*
@interface HomeViewController ()

@end
 */

@implementation HomeViewController

@synthesize thumbnailData, thumbnail;
@synthesize peopleDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:@"Matching Game"];
    //[[self navigationItem] setRightBarButtonItem:UIBarButtonSystemItemDone];
    
    int x = 10;
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(x, 75, self.view.frame.size.width - 2*x, 80)];
    userView.layer.cornerRadius = 5;
    userView.backgroundColor = [UIColor blackColor];
    int xLabel = 100;
    int yLabel = 10;
    int xWidth = 200;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, yLabel, xWidth, 20)];
    nameLabel.text = @"Brad Schmidt";
    nameLabel.textColor = [UIColor whiteColor];
    [userView addSubview:nameLabel];
    
    highScore = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, yLabel + 20, xWidth, 20)];
    highScore.textColor = [UIColor whiteColor];
    highScore.font = [UIFont systemFontOfSize:10];
    [userView addSubview:highScore];
    
    yourRank = [[UILabel alloc] initWithFrame:CGRectMake(xLabel, yLabel + 40, xWidth, 20)];
    yourRank.textColor = [UIColor whiteColor];
    yourRank.font = [UIFont systemFontOfSize:10];
    [userView addSubview:yourRank];
    
    /*
    yourImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
    yourImage.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
    yourImage.layer.borderWidth = 10;
    yourImage.backgroundColor = [UIColor clearColor];
    [userView addSubview:yourImage];
     */
    
    [[self view] addSubview:userView];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    //[tableView registerNib:nib forCellReuseIdentifier:@"TableViewCell"];
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:kChallengeURL];
        [self performSelectorOnMainThread:@selector(userInfo:) withObject:data waitUntilDone:YES];
    });
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 175, self.view.frame.size.width, self.view.frame.size.height - 175) style:UITableViewStyleGrouped];
    [tableView registerNib:nib forCellReuseIdentifier:@"TableViewCell"];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [tableView setSeparatorStyle:UITableViewCellSelectionStyleNone];
    
    [[self view] addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userInfo:(NSData *)responseData {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *people = [json objectForKey:@"leaders"];

    peopleDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    //NSLog(@"leaders: %@", people);  //prints everything
    
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    [number setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *yourScore = [number stringFromNumber:[json objectForKey:@"your_score"]];
    NSString *myRank = [number stringFromNumber:[json objectForKey:@"your_rank"]];
    
    highScore.text = [NSString stringWithFormat:@"High Score: %@", yourScore];//[json objectForKey:@"your_score"]];
    yourRank.text = [NSString stringWithFormat:@"Rank: %@", myRank];
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *people = [peopleDictionary objectForKey:@"leaders"];
    return [people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //CustomHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    /*
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
     */
    
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *people = [peopleDictionary objectForKey:@"leaders"];
    NSDictionary *person = [people objectAtIndex:indexPath.row];
    NSNumber *score = [person objectForKey:@"score"];
    NSString *urlString = [person objectForKey:@"image_url"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    [self setThumbnailDataFromImage:image];
    
    [[cell userImage] setImage:thumbnail];
    cell.rank.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.nameLabel.text = [person objectForKey:@"name"];
    
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    [number setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *scoreString = [number stringFromNumber:score];
    cell.socreLabel.text = [NSString stringWithFormat:@"Score: %@", scoreString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}

- (UIView *)backgroundCell
{
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, self.view.frame.size.width - 20, 60)];
    userView.layer.cornerRadius = 5;
    userView.backgroundColor = [UIColor greenColor];
    return userView;
}

- (UIImage *)thumbnail
{
    if (!thumbnailData) {
        return nil;
    }
    if (!thumbnailData) {
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 70, 70);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    UIGraphicsEndImageContext();
}

@end
