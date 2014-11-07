//
//  LocationsTable.m
//  Hw3
//
//  Created by Jeffrey Shih on 10/14/14.
//  Copyright (c) 2014 JeffreyShih. All rights reserved.
//

#import "LocationsTable.h"
#import "FlickrFetcher.h"
#import "PhotosTable.h"

@interface LocationsTable ()

@end

@implementation LocationsTable

@synthesize placesList = _placesList;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocations];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getLocations{
        [self.refreshControl beginRefreshing];
        
        dispatch_queue_t fetchQueue = dispatch_queue_create("fetch queue", NULL);
        dispatch_async(fetchQueue, ^{
            
            // Asynch go off and get place list from Flickr
            NSArray * newPlaces = [FlickrFetcher topPlaces];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.placesList = newPlaces;
                [self.tableView reloadData];
            });
        });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.placesList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoLocations";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * city = self.placesList[indexPath.row];
    cell.textLabel.text = [city valueForKey:FLICKR_PLACE_NAME];
    NSLog(@"%@", cell.textLabel);
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    PhotosTable * pt = [segue destinationViewController];
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    pt.loc = [self.placesList objectAtIndex:path.row];
    NSLog(@"%@", pt.loc);
}


@end
