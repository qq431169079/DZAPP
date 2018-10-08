//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "DemoTableController.h"
#import "CustomCell.h"
#import "obj_common.h"
@interface DemoTableController ()

@end

@implementation DemoTableController

- (NSString*)PathForDocumentStrDID:(NSString*)strDID{
    NSString* documentPath = nil;
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    documentPath = [path objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:strDID];
}


-(void)imagewritetofile:(int) tag{
    NSData* imagedata = UIImageJPEGRepresentation(_img, 1.0);
    NSFileManager* fileMng = [NSFileManager defaultManager];
    NSString* path = [self PathForDocumentStrDID:_strDID];
    [fileMng createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSString* imgPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",tag]];
    NSLog(@"path %@",path);
    if ([fileMng fileExistsAtPath:imgPath]) {
            [fileMng removeItemAtPath:imgPath error:nil];
    }
    if ([fileMng createFileAtPath:imgPath contents:imagedata attributes:nil]){
       
    }
    //[fileMng createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //[fileMng createFileAtPath:path contents:nil attributes:nil];
//    if ([imagedata writeToFile:path atomically:YES])
//    {
//        NSLog(@"write");
//    }
}

-(void)defaultCell{
    NSFileManager* fileMng = [NSFileManager defaultManager];
   
   // NSLog(@"defaultCell path %@",path);
        UIImage* image = nil;
    for (int i = 50; i < 55; i++) {
         NSString* path = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",i]];
        
        if ([fileMng fileExistsAtPath:path]) {
            image = [UIImage imageWithContentsOfFile:path];
            NSLog(@"fileMng Exists");
            
        }else{
            image = [UIImage imageNamed:@"Camera"];
            NSLog(@"Camera");
        }
        if (nil == image) {
            NSLog(@"fileMng non Exists");
            image = [UIImage imageNamed:@"Camera"];
        }
        [(UIButton*)[self.view viewWithTag:i + 50] setImage:image forState:UIControlStateNormal];
    }
            
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTable(@"Preset", @STR_LOCALIZED_FILE_NAME, nil);
    
    self.tableView.allowsSelection = NO;
    
    _butonTap = NO;
    
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        ///cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    //[cell.resetbutton setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    cell.label.text = [NSString stringWithFormat:@"%@%d",NSLocalizedStringFromTable(@"Preset", @STR_LOCALIZED_FILE_NAME, nil),indexPath.row+1];
    
    
    cell.againbutton.layer.masksToBounds = YES;
    cell.againbutton.layer.cornerRadius = 4.0;
    cell.againbutton.layer.borderWidth = 1.0;
    cell.againbutton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    
    cell.againbutton.tag = indexPath.row + 50;
    cell.resetbutton.tag = indexPath.row + 100;
    _buttontag = cell.againbutton.tag;
    
    [self defaultCell];
    [cell.againbutton addTarget:self action:@selector(againreset:) forControlEvents:UIControlEventTouchUpInside];
    [cell.resetbutton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 4 || indexPath.row == 0) {
        [self performSelector:@selector(setback:) withObject:nil afterDelay:0.0001];
    }
    
    
    
    return cell;
}

-(void)setback:(id)sender{
    NSFileManager* fileMng = [NSFileManager defaultManager];
    UIImage* image = nil;
    
    NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",50]];
    
    if ([fileMng fileExistsAtPath:path1]) {
        image = [UIImage imageWithContentsOfFile:path1];
        NSLog(@"fileMng Exists");
        
    }else{
        image = [UIImage imageNamed:@"Camera"];
        NSLog(@"Camera");
    }
    if (nil == image) {
        NSLog(@"fileMng non Exists");
        image = [UIImage imageNamed:@"Camera"];
    }
    [(UIButton*)[self.view viewWithTag:50 + 50] setImage:image forState:UIControlStateNormal];
    
    NSString* path = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",54]];
    
    if ([fileMng fileExistsAtPath:path]) {
        image = [UIImage imageWithContentsOfFile:path];
        NSLog(@"fileMng Exists");
        
    }else{
        image = [UIImage imageNamed:@"Camera"];
        NSLog(@"Camera");
    }
    if (nil == image) {
        NSLog(@"fileMng non Exists");
        image = [UIImage imageNamed:@"Camera"];
    }
    [(UIButton*)[self.view viewWithTag:104] setImage:image forState:UIControlStateNormal];
}

-(void)againreset:(id)sender{
   // _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET0);
    _button_tag = ((UIButton*)sender).tag;
    _butonTap = YES;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"replace", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    [alert show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSFileManager* fileMng = [NSFileManager defaultManager];
    UIImage* image = nil;

    if (buttonIndex == 0) {
        return;
    }else if (buttonIndex == 1){
        
        [self imagewritetofile:_button_tag];
        switch (_button_tag) {
            case 50:
            {
                _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET0);
                //[(UIButton*)[self.view viewWithTag:100] setImage:_img forState:UIControlStateNormal];
                NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",50]];
                
                if ([fileMng fileExistsAtPath:path1]) {
                    image = [UIImage imageWithContentsOfFile:path1];
                    NSLog(@"fileMng Exists");
                    
                }else{
                    image = [UIImage imageNamed:@"Camera"];
                    NSLog(@"Camera");
                }
                if (nil == image) {
                    NSLog(@"fileMng non Exists");
                    image = [UIImage imageNamed:@"Camera"];
                }
                [(UIButton*)[self.view viewWithTag:50 + 50] setImage:image forState:UIControlStateNormal];
            }
                break;
            case 51:
            {
                _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET1);
                
                //[(UIButton*)[self.view viewWithTag:101] setImage:_img forState:UIControlStateNormal];
                NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",51]];
                
                if ([fileMng fileExistsAtPath:path1]) {
                    image = [UIImage imageWithContentsOfFile:path1];
                    NSLog(@"fileMng Exists");
                    
                }else{
                    image = [UIImage imageNamed:@"Camera"];
                    NSLog(@"Camera");
                }
                if (nil == image) {
                    NSLog(@"fileMng non Exists");
                    image = [UIImage imageNamed:@"Camera"];
                }
                [(UIButton*)[self.view viewWithTag:51 + 50] setImage:image forState:UIControlStateNormal];
            }

                break;
            case 52:
            {
                _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET2);
                //[(UIButton*)[self.view viewWithTag:102] setImage:_img forState:UIControlStateNormal];
                NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",52]];
                
                if ([fileMng fileExistsAtPath:path1]) {
                    image = [UIImage imageWithContentsOfFile:path1];
                    NSLog(@"fileMng Exists");
                    
                }else{
                    image = [UIImage imageNamed:@"Camera"];
                    NSLog(@"Camera");
                }
                if (nil == image) {
                    NSLog(@"fileMng non Exists");
                    image = [UIImage imageNamed:@"Camera"];
                }
                [(UIButton*)[self.view viewWithTag:52 + 50] setImage:image forState:UIControlStateNormal];
            }
                break;
            case 53:
            {
                _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET3);
                //[(UIButton*)[self.view viewWithTag:103] setImage:_img forState:UIControlStateNormal];
                NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",53]];
                
                if ([fileMng fileExistsAtPath:path1]) {
                    image = [UIImage imageWithContentsOfFile:path1];
                    NSLog(@"fileMng Exists");
                    
                }else{
                    image = [UIImage imageNamed:@"Camera"];
                    NSLog(@"Camera");
                }
                if (nil == image) {
                    NSLog(@"fileMng non Exists");
                    image = [UIImage imageNamed:@"Camera"];
                }
                [(UIButton*)[self.view viewWithTag:53 + 50] setImage:image forState:UIControlStateNormal];
                }

                break;
            case 54:
            {
                _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_SET4);
                //[(UIButton*)[self.view viewWithTag:104] setImage:_img forState:UIControlStateNormal];
                NSString* path1 = [[self PathForDocumentStrDID:_strDID] stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d",54]];
                
                if ([fileMng fileExistsAtPath:path1]) {
                    image = [UIImage imageWithContentsOfFile:path1];
                    NSLog(@"fileMng Exists");
                    
                }else{
                    image = [UIImage imageNamed:@"Camera"];
                    NSLog(@"Camera");
                }
                if (nil == image) {
                    NSLog(@"fileMng non Exists");
                    image = [UIImage imageNamed:@"Camera"];
                }
                [(UIButton*)[self.view viewWithTag:54 + 50] setImage:image forState:UIControlStateNormal];
              }

                break;
                
            default:
                break;
        }
    }
    //[self.tableView reloadData];
    _butonTap = NO;
    [_fppopoverCtr dismissPopoverAnimated:YES];
}

-(void)reset:(id)sender{
    switch (((UIButton*)sender).tag) {
        case 100:
            _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_RUN0);
            break;
            case 101:
            _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_RUN1);
            break;
            case 102:
            _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_RUN2);
            break;
            case 103:
            _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_RUN3);
            break;
            case 104:
            _cppppchannelMgt->PTZ_Control([_strDID UTF8String], CMD_PTZ_PREFAB_BIT_RUN4);
            break;
        default:
            break;
    }
    [_fppopoverCtr dismissPopoverAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end
