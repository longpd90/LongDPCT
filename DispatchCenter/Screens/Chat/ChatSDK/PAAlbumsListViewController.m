//
//  PAAlbumsListViewController.m
//  PostApp
//
//  Created by NghiaNH on 10/8/15.
//
//

#import "PAAlbumsListViewController.h"
#import "PAAlbumCell.h"
#import "UIAlertView+Utils.h"

@interface PAAlbumsListViewController ()

@end

@implementation PAAlbumsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"PAAlbumCell" bundle:nil] forCellReuseIdentifier:@"PAAlbumCell"];
    CGSize popoverContentSize = CGSizeMake(PAScreenSize.width - 20, MIN(self.groups.count * 60, PAScreenSize.height - 200));
    self.preferredContentSize = popoverContentSize;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAAlbumCell *cell = (PAAlbumCell *) [tableView dequeueReusableCellWithIdentifier:@"PAAlbumCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *groupForCell = self.groups[indexPath.row];
    if ([groupForCell isEqual:self.selectedGroup]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.firstImageView.image = posterImage;
    cell.albumTitleLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.albumNumberOfAssetsLabel.text = [@(groupForCell.numberOfAssets) stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *groupForCell = self.groups[indexPath.row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedGroup:)]) {
        [self.delegate didSelectedGroup:groupForCell];
    }
}


@end
