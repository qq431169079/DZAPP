//
//  CustomTableAlert.m
//  AlertView
//
//  Created by yan luke on 13-3-1.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import "CustomTableAlert.h"
#import "obj_common.h"
/*#define cTableAlertWidth   284.0
#define cLateralInset       12.0
#define cVerticalInset       8.0
#define cMinAlertHeight    264.0
#define cCancelButtonHeight 44.0
#define cCancelButtonMargin  5.0
#define cTitleLabelMargin   12.0*/

#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      264.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0


@interface CustomTableAlert ()
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIButton* cancelBtn;
@property (nonatomic, retain) UIView* alertBg;
@property (nonatomic, assign) BOOL cellsclection;
- (void)animationIn;

- (void)animationOUT;
@end

@implementation CustomTableAlert

- (id)initWithTitle:(NSString*)title cancelButtonTitle:(NSString*)cancelButtonTitle numberOfRows:(myTableViewRows) rowsblock tablecell:(myTableViewCell)cellblock{
    if (rowsblock == nil || cellblock == nil) {
        [[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"These blocks MUST NOT be nil" userInfo:nil] raise];
        return nil;
    }
    
    self = [super init];
    if (self) {
        _title = title;
        _cancelBtnTitle = cancelButtonTitle;
        _rowBlock = rowsblock;
        _cellBlock = cellblock;
        _height = kMinAlertHeight;
    }
    
    return self;
}

- (void)configureTableViewSelectionRowBlock:(myTableViewSelectionRow)selectionRow Completion:(myTableAlertCompletion)completion{
    self.selectionRowBlock = selectionRow;
    self.completionBlock = completion;
}

- (void)createBackGroundView{
    
    self.frame = [UIScreen mainScreen].bounds;
    
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer* taphesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisstableAlert)];
//    taphesture.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:taphesture];
//    [taphesture release];
   // self.autoresizingMask = UIViewAutoresizingNone;
    //self.autoresizesSubviews = YES;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25f];
    }];
}

- (void)animationIn{
//    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
//        [UIView animateWithDuration:1.0/15 animations:^{
//            self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
//            [UIView animateWithDuration:1.0/7.5 animations:^{
//                self.alertBg.transform = CGAffineTransformIdentity;
//            }];
//        }];
//    }];
    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration:0.2 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.alertBg.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
}

- (void)animationOUT{
    [UIView animateWithDuration:1.0/7.5 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
				self.alpha = 0.3;
			} completion:^(BOOL finished){
				// table alert not shown anymore
				[self removeFromSuperview];
			}];
		}];
	}];

}
- (void)show{
    [self createBackGroundView];
	
	// alert view creation
	self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.alertBg];
	// setting alert background image
    UIImageView *alertBgImage = [[UIImageView alloc] initWithImage:/*[[UIImage imageNamed:@"MLTableAlertBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 30, 15) resizingMode:UIImageResizingModeStretch]] ;//*/[[UIImage imageNamed:@"MLTableAlertBackground.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
	[self.alertBg addSubview:alertBgImage];
	
	// alert title creation
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
	self.titleLabel.text = self.title;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.alertBg addSubview:self.titleLabel];
	
	// table view creation
	self.contentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.contentTable.frame = CGRectMake(kLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - kCancelButtonMargin - kCancelButtonHeight);
	self.contentTable.layer.cornerRadius = 6.0;
	self.contentTable.layer.masksToBounds = YES;
	self.contentTable.delegate = self;
	self.contentTable.dataSource = self;
	self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.contentTable.backgroundView = [[UIView alloc] init];
	[self.alertBg addSubview:self.contentTable];
	
	// setting white-to-gray gradient as table view's background
	CAGradientLayer *tableGradient = [CAGradientLayer layer];
	tableGradient.frame = CGRectMake(0, 0, self.contentTable.frame.size.width, self.contentTable.frame.size.height);
	tableGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] CGColor], nil];
	[self.contentTable.backgroundView.layer insertSublayer:tableGradient atIndex:0];
	
	// adding inner shadow mask on table view
	UIImageView *maskShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertShadowMask.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7]];
	maskShadow.userInteractionEnabled = NO;
	maskShadow.layer.masksToBounds = YES;
	maskShadow.layer.cornerRadius = 5.0;
	maskShadow.frame = self.contentTable.frame;
	[self.alertBg addSubview:maskShadow];
	
	// cancel button creation
	self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.cancelBtn.frame = CGRectMake(kLateralInset, self.contentTable.frame.origin.y + self.contentTable.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
	self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	self.cancelBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.cancelBtn.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.cancelBtn.titleLabel.textColor = [UIColor redColor];
	[self.cancelBtn setTitle:self.cancelBtnTitle forState:UIControlStateNormal];
	//[self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.cancelBtn setBackgroundColor:[UIColor clearColor]];
	[self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	self.cancelBtn.opaque = NO;
	self.cancelBtn.layer.cornerRadius = 5.0;
	[self.cancelBtn addTarget:self action:@selector(dismisstableAlert) forControlEvents:UIControlEventTouchUpInside];
	[self.alertBg addSubview:self.cancelBtn];
	
    UIImage* infoimage = [UIImage imageNamed:@"info"];
    UIImageView* infoimageview = [[UIImageView alloc] initWithImage:infoimage];
    infoimageview.frame = CGRectMake(1, -infoimage.size.height/2, infoimage.size.width, infoimage.size.height);
    [self.alertBg addSubview:infoimageview];
    
	// setting alert and alert background image frames
	self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2 + 22.f, kTableAlertWidth, self.height - kVerticalInset * 2);
	alertBgImage.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, self.height);
	
	// the alert will be the first responder so any other controls,
	// like the keyboard, will be dismissed before the alert
	[self becomeFirstResponder];
	
	// show the alert with animation
	[self animationIn];

    
   /* [self createBackGroundView];
    self.cellsclection = NO;
    self.alertBg = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [self addSubview:self.alertBg];
    
   // UIImageView* alertbgimage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 15, 35, 15)]];
    UIImageView* alertbgimage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground"] stretchableImageWithLeftCapWidth:15.f topCapHeight:35.f]];
    //UIImageView* alertbgimage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popoverBg@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(65, 45, 65, 45)]];
    [self.alertBg addSubview:alertbgimage];
    
    self.titleLabel = [[[UILabel alloc] init] autorelease];
    //self.titleLabel.text = @"Custom TAlert";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.frame = CGRectMake(cLateralInset, 10.0f, cTableAlertWidth - cLateralInset*2, 20.f);
    [self.alertBg addSubview:self.titleLabel];
    
    self.contentTable = [[[UITableView alloc] initWithFrame:CGRectMake(cLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + cTitleLabelMargin, cTableAlertWidth - cLateralInset*2, (self.height - cVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height -cTitleLabelMargin - cCancelButtonMargin - cCancelButtonHeight) style:UITableViewStylePlain] autorelease];
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTable.dataSource = self;
    self.contentTable.delegate = self;
    self.contentTable.layer.cornerRadius = 8.f;
    self.contentTable.layer.masksToBounds = YES;
    self.contentTable.backgroundView = [[UIView alloc] init];
    [self.alertBg addSubview:self.contentTable];
    
    CAGradientLayer *tableGradient = [CAGradientLayer layer];
	tableGradient.frame = CGRectMake(0, 0, self.contentTable.frame.size.width, self.contentTable.frame.size.height);
	tableGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] CGColor], nil];
	[self.contentTable.backgroundView.layer insertSublayer:tableGradient atIndex:0];
    
    UIImageView* maskShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertShadowMask.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7]];
    maskShadow.userInteractionEnabled = NO;
    maskShadow.layer.cornerRadius = 5.0f;
    maskShadow.layer.masksToBounds = YES;
    maskShadow.frame = self.contentTable.frame;
    [self.alertBg addSubview:maskShadow];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelBtn.frame = CGRectMake(cLateralInset, self.contentTable.frame.origin.y + self.contentTable.frame.size.height + cCancelButtonMargin, cTableAlertWidth - cLateralInset*2, cCancelButtonHeight);
    
    [self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton"] stretchableImageWithLeftCapWidth:5.f topCapHeight:6.f] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed"] stretchableImageWithLeftCapWidth:5.f topCapHeight:6.f] forState:UIControlStateHighlighted];
    //[self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.f, 5.f, 6.f, 5.f)] forState:UIControlStateNormal];
    //[self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.f, 5.f, 6.f, 5.f)] forState:UIControlStateHighlighted];
    self.cancelBtn.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.cancelBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelBtn addTarget:self action:@selector(dismisstableAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBg addSubview:self.cancelBtn];
    
    UIImage* infoimage = [UIImage imageNamed:@"info"];
    UIImageView* infoimageview = [[UIImageView alloc] initWithImage:infoimage];
    infoimageview.frame = CGRectMake(1, -infoimage.size.height/2, infoimage.size.width, infoimage.size.height);
    [self.alertBg addSubview:infoimageview];
    [infoimageview release];
    
    self.alertBg.frame = CGRectMake((self.frame.size.width - cTableAlertWidth)/2, (self.frame.size.height - _height )/2 + 44.f, cTableAlertWidth, _height );
    //alertbgimage.frame= CGRectMake(- 8, -8, cTableAlertWidth + 16, self.height + 8);
    alertbgimage.frame= CGRectMake(0, 0, cTableAlertWidth, self.height);
    [self becomeFirstResponder];
    [self animationIn];
    [alertbgimage release];
    [maskShadow release];*/
}



- (void)setHeight:(CGFloat)height{
    if (height > kMinAlertHeight) {
        _height = height;
    }else{
        _height = kMinAlertHeight;
    }
}

- (void)dismisstableAlert{
    [self animationOUT];
    if (self.completionBlock != nil) {
        if (self.cellsclection == NO) {
            self.completionBlock();
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowBlock();
    //return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellBlock(self,indexPath);
//    static NSString* iden = @"iden";
//    
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
//    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.cellsclection = YES;
    [self dismisstableAlert];
    if (self.selectionRowBlock != nil) {
        self.selectionRowBlock(indexPath);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
