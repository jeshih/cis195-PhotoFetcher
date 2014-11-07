//
//  PhotosTable.h
//  Hw3
//
//  Created by Jeffrey Shih on 10/14/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTable : UITableViewController

@property (strong, nonatomic) NSDictionary * loc;
@property (nonatomic, strong) NSArray *photos; 

@end
