//
//  AlbumTableViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-1-23.
//
//

#import "AlbumTableViewController.h"

@interface AlbumTableViewController ()

@end

@implementation AlbumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if ([_mark isEqualToString:@"picture"]) {
            self.title = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Picture", @STR_LOCALIZED_FILE_NAME, nil)];
        }else if ([_mark isEqualToString:@"record"]){
            self.title = [NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"Local", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil)];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    _cameraListMgt = nil;
    _m_strDID = nil;
    _delegate  = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_cameraListMgt GetCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.imageView.image = ([[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_IMG] == nil) ? ([UIImage imageNamed:@"back"]) : ([[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_IMG]);
    cell.textLabel.text = [[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_NAME];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_delegate reloadData:[[_cameraListMgt GetCameraAtIndex:indexPath.row] objectForKey:@STR_DID]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

@end
