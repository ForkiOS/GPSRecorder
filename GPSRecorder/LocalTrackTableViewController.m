//
//  LocalTrackTableViewController.m
//  GPSRecorder
//
//  Created by zhangchao on 14/11/19.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "LocalTrackTableViewController.h"

@interface LocalTrackTableViewController ()

@end

@implementation LocalTrackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _mLocalTrackTableView.delegate = self;
    _mLocalTrackTableView.dataSource = self;
    _trackFiles = [NSMutableArray array];

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Documents directory
        NSString *documentsDir = [FileHelper getDocumentsDirectory];
        NSArray *filesArray = [FileHelper getFilesListInDirectory:documentsDir filterSuffix:@".gpx"];

        [_trackFiles addObjectsFromArray:filesArray];

        // call back on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mLocalTrackTableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData *)loadDataFromURL:(NSURL *)fileURL {
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    if (data == nil) {
        NSLog(@"loadDataFromURL data is NULL !!!");
    }
    return data;
}

- (NSData *)loadDataFromPath:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        NSLog(@"loadDataFromPath data is NULL !!!");
    }
    return data;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _trackFiles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LocalTrackTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    NSURL *fileURL = _trackFiles[indexPath.row];
    NSString *filePath = _trackFiles[indexPath.row];
    // juse use file name, not include suffix.
    cell.textLabel.text = [FileHelper getFilesName:filePath];
//    cell.textLabel.text = [fileURL lastPathComponent];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MapViewController *mapViewController = [story instantiateViewControllerWithIdentifier:@"mapViewControler"];

//    NSURL *fileURL = _trackFiles[indexPath.row];
    NSString *filePath = _trackFiles[indexPath.row];

//    NSData *data = [self loadDataFromURL:fileURL];
    NSData *data = [self loadDataFromPath:filePath];
    if (data != nil) {
        mapViewController.gpxData = data;
    }

    mapViewController.title = [FileHelper getFilesName:filePath];
    mapViewController.isRealTimeMode = false;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger row = [indexPath row];
        [FileHelper removeFile:_trackFiles[row]];
        [_trackFiles removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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
