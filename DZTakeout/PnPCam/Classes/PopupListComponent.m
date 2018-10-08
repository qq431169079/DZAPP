//
//  PopupListComponent.m
//  PopupList
//
//  Created by yan luke on 13-1-8.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import "PopupListComponent.h"
#import "WEPopoverController.h"
@implementation PopupListComponentItem
@synthesize caption,image,itemId,showCaption;

- (id) initWithCaption:(NSString*)caption1 image:(UIImage*)image1 itemId:(int)itemId1 showCaption:(BOOL)showCaption1{
    self = [super init];
    if (self) {
        self.caption = caption1;
        self.image = image1;
        self.itemId = itemId1;
        self.showCaption = showCaption1;
    }
    return self;
}

@end

// Popup list itself
@interface PopupListComponent() <WEPopoverControllerDelegate>

@property (nonatomic, retain) WEPopoverController* myPopover;

// PopoverControllerDelegate methods:
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController;

@end


@implementation PopupListComponent
@synthesize font,textColor,textHilightedColor,buttonSpacing,textPaddingHorizontal,textPaddingVertical,imagePaddingHorizontal,imagePaddingVertical,alignment,allowedArrowDirections,delegate,userInfo;
@synthesize myPopover;

// Definition of Defaults
#define DEFAULT_IPAD_FONT           [UIFont systemFontOfSize:24]
#define DEFAULT_IPAD_FONT_BOLD      [UIFont boldSystemFontOfSize:24]
#define DEFAULT_IPHONE_FONT         [UIFont systemFontOfSize:20]
#define DEFAULT_IPHONE_FONT_BOLD    [UIFont boldSystemFontOfSize:20]
#define DEFAULT_FONT_COLOR          [UIColor whiteColor]
#define DEFAULT_FONT_COLOR_SELECTED [UIColor grayColor]
#define DEFAULT_BUTTON_SPACING      10
#define DEFAULT_TEXT_PADDING_H      10
#define DEFAULT_TEXT_PADDING_V      5
#define DEFAULT_ARROW_DIRECTIONS    UIPopoverArrowDirection
#define LOG YES

#pragma mark - Public Methods

- (id) init
{
    self = [super init];
    if (self) {
        [self useSystemDefaultFontBold];
        self.textColor = DEFAULT_FONT_COLOR;
        self.textHilightedColor = DEFAULT_FONT_COLOR_SELECTED;
        self.buttonSpacing = DEFAULT_BUTTON_SPACING;
        self.textPaddingHorizontal = DEFAULT_TEXT_PADDING_H;
        self.textPaddingVertical = DEFAULT_TEXT_PADDING_V;
        self.imagePaddingHorizontal = DEFAULT_TEXT_PADDING_H;
        self.imagePaddingVertical = DEFAULT_TEXT_PADDING_V;
        self.alignment = UIControlContentHorizontalAlignmentCenter;
        self.allowedArrowDirections = UIPopoverArrowDirectionAny;
        if (LOG) NSLog(@"Default directions: %i", self.allowedArrowDirections);
    }
    return self;
}

- (void) useSystemDefaultFontNonBold
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.font = DEFAULT_IPAD_FONT;
    }
    else {
        self.font = DEFAULT_IPHONE_FONT;
    }
}
- (void) useSystemDefaultFontBold
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.font = DEFAULT_IPAD_FONT_BOLD;
    }
    else {
        self.font = DEFAULT_IPHONE_FONT_BOLD;
    }
}
- (void) showAnchoredTo: (UIView*)sourceItem inView:(UIView*)parentView withItems:(NSArray*)itemList withDelegate:(id<PopupListComponentDelegate>)delegate1
{
    if (LOG) NSLog(@"In showAnchoredTo, parentView.frame = %@", NSStringFromCGRect(parentView.frame));
    if (LOG) NSLog(@"In showAnchoredTo, parentView.bounds = %@", NSStringFromCGRect(parentView.bounds));
    
    if (self.myPopover && [self.myPopover isPopoverVisible]) {
        // Do nothing. We got activated again while already showing
        // popup content, so want to let cancel handlers run.
        return;
    }
    
    self.delegate = delegate1;
    
    // Create underlying GUI/Controller objects if needed
    if(!self.myPopover) {
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        UIView* contents = [self _makeContentsFromItemList: itemList];
        viewCon.view = contents;
        //[parentView addSubview:contents];
        viewCon.contentSizeForViewInPopover = contents.frame.size;
        //[parentView addSubview:contents];
        //if (LOG) NSLog(@"View size for popover: %@", NSStringFromCGSize(viewCon.contentSizeForViewInPopover));
        //if (LOG) NSLog(@"ViewController frame : %@", NSStringFromCGRect(viewCon.view.frame));
        
        self.myPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        
        [self.myPopover setDelegate:self];  // as <PopoverControllerDelegate>
    }
    
    // Show popup
    //return;
    CGRect anchorRect = [[sourceItem superview] convertRect:sourceItem.frame toView:parentView];//sourceItem.frame;
    if (LOG) NSLog(@"Anchoring popup to frame : %@", NSStringFromCGRect(anchorRect));
    
    if (LOG) NSLog(@"Showing with directions: %i", self.allowedArrowDirections);
    /*[self.myPopover presentPopoverFromRect: anchorRect
                                    inView: parentView
                  permittedArrowDirections: self.allowedArrowDirections
                                  animated: YES];*/
    [self.myPopover presentPopoverFromRect:anchorRect inView:parentView permittedArrowDirections:self.allowedArrowDirections animated:YES];

}

-(void)showPopFromBarButtonItem:(UIBarButtonItem*)barbuttonItem inView:(UIView*)parentView withItems:(NSArray*)itemList withDelegate:(id<PopupListComponentDelegate>)delegate1{
    if (LOG) NSLog(@"In showAnchoredTo, parentView.frame = %@", NSStringFromCGRect(parentView.frame));
    if (LOG) NSLog(@"In showAnchoredTo, parentView.bounds = %@", NSStringFromCGRect(parentView.bounds));
    
    if (self.myPopover && [self.myPopover isPopoverVisible]) {
        // Do nothing. We got activated again while already showing
        // popup content, so want to let cancel handlers run.
        return;
    }
    
    self.delegate = delegate1;
    
    // Create underlying GUI/Controller objects if needed
    if(!self.myPopover) {
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        UIView* contents = [self _makeContentsFromItemList: itemList];
        viewCon.view = contents;
        viewCon.contentSizeForViewInPopover = contents.frame.size;
        //[parentView addSubview:contents];
        //if (LOG) NSLog(@"View size for popover: %@", NSStringFromCGSize(viewCon.contentSizeForViewInPopover));
        //if (LOG) NSLog(@"ViewController frame : %@", NSStringFromCGRect(viewCon.view.frame));
        
        self.myPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        
        [self.myPopover setDelegate:self];  // as <PopoverControllerDelegate>
    }
    
    // Show popup
    
    //CGRect anchorRect = sourceItem.frame;
    //if (LOG) NSLog(@"Anchoring popup to frame : %@", NSStringFromCGRect(anchorRect));
    
    if (LOG) NSLog(@"Showing with directions: %i", self.allowedArrowDirections);
    
    [self.myPopover presentPopoverFromBarButtonItem:barbuttonItem permittedArrowDirections:self.allowedArrowDirections animated:YES];

}

// Creator/invoker telling us to hide the popup
-(void) hide
{
    [self _manualDismissPopover];
}

#pragma mark - <PopoverControllerDelegate> protocol implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
    if (LOG) NSLog(@"<PopoverControllerDelegate> Did dismiss");
    [self.myPopover setDelegate:nil];
    self.myPopover = nil;
    [self notifyDelegateOfCancel];
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController
{
    if (LOG) NSLog(@"<PopoverControllerDelegate> Should dismiss");
    return YES;
}

// ------------------------------------------
//  Action messages to our delegate
// ------------------------------------------

#pragma mark -  Action messages out to delegate

- (void) notifyDelegateOfCancel
{
    if (self.delegate) {
        [self.delegate popupListcompoentDidCancel: self];
    }
}

- (void) notifyDelegateOfSelection:(int)itemId
{
    if (self.delegate) {
        [self.delegate popupListcomponent:self choseItemWithId:itemId];
    }
}


// ------------------------------------------
//  GUI Construction
// ------------------------------------------

#pragma mark -  Build/Show GUI Elements

- (UIButton*) _makeButtonForItem: (PopupListComponentItem*)item
                         yOffset: (int)yoffset  xOffset:(int)xOffset
                callbackSelector: (SEL)selector
               withButtonMaxSize: (CGSize) buttonFrameSize
{
    CGRect frame = CGRectMake(0, 0, buttonFrameSize.width, buttonFrameSize.height);
    
    // else if (align = left) {
    //    create buttons framed exactly to text, and zero left edge <--
    // else  align right {
    //    create buttons framed exactly to text and put right edge --> buttonFrameSize.maxX
    
    CGRect buttonFrame = CGRectMake(xOffset, yoffset, frame.size.width, frame.size.height);
    if (LOG) NSLog(@"Creating button at: %@", NSStringFromCGRect(buttonFrame));
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    if (item.image) {
        [button setImage:item.image forState:UIControlStateNormal];
    }
    if (item.showCaption && item.caption) {
        
        UIColor* textColor1 = self.textColor;
        UIColor* textColorActive = self.textHilightedColor;
        
        [button setTitleColor:textColor1 forState:UIControlStateNormal];
        [button setTitleColor:textColorActive forState:UIControlStateHighlighted];
        [button setTitle:item.caption forState:UIControlStateNormal];
        button.titleLabel.font = self.font;
        button.contentHorizontalAlignment =  self.alignment;
    }
    
    // Apply any insets/padding user may have specified:
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(self.imagePaddingVertical, self.imagePaddingHorizontal,
                                                self.imagePaddingVertical, self.imagePaddingHorizontal);
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(self.textPaddingVertical, self.textPaddingHorizontal,
                                                self.textPaddingVertical, self.textPaddingHorizontal);
    if (item.image) {
        button.imageEdgeInsets = imageInsets;
    }
    if (item.showCaption && item.caption) {
        if (item.image) {
            // Image is on left, so have to add in insets for that since user's intention is
            // to have <image><title>. If we slide over image, have to move starting edge of title
            // over by same amount to match what user will expect as starting point for inset.
            titleInsets.left = titleInsets.left + imageInsets.left + imageInsets.right;
            button.titleEdgeInsets = titleInsets;
        }
        
    }
    
    
    button.tag = item.itemId;   // Gets sent as param to selector on button activation
    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    if (LOG) NSLog(@"buttonFrame Frame: %@", NSStringFromCGRect(buttonFrame));
    
    return button;
}


- (CGSize) _calculateNeededButtonSize: (NSArray*) popupListComponentItems
{
    CGSize globalMax = CGSizeMake(0, 0);
    
    
    for (PopupListComponentItem* item in popupListComponentItems) {
        
        CGSize imageSize = CGSizeMake(0, 0);
        CGSize textSize = CGSizeMake(0, 0);
        
        if (item.image) {
            CGSize size = [item.image size];
            NSInteger x = size.width  + 2*self.imagePaddingHorizontal;
            NSInteger y = size.height + 2*self.imagePaddingVertical;
            imageSize.width = x;
            imageSize.height = y;
        }
        
        if (item.showCaption && item.caption) {
            CGSize size;
            if (item.caption.length < 3)
                size = [@"MM." sizeWithFont: self.font]; // Use minimum visual size to make large enough for finger select
            else
                size = [item.caption sizeWithFont: self.font];
            
            NSInteger x = size.width  + 2*self.textPaddingHorizontal;
            NSInteger y = size.height + 2*self.textPaddingVertical;
            textSize.width = x;
            textSize.height = y;
        }
        
        CGSize itemSize;
        if (item.image && item.showCaption && item.caption) {
            // Size = img + txt
            itemSize = CGSizeMake(imageSize.width + textSize.width, MAX(imageSize.height, textSize.height));
        }
        else if (item.image) {
            // no text, so size of image
            itemSize = imageSize;
        }
        else {
            // no image, so size of text
            itemSize = textSize;
        }
        
        globalMax.width  = MAX(itemSize.width, globalMax.width);
        globalMax.height = MAX(itemSize.height, globalMax.height);
    }
    
    return globalMax;
}


- (UIView*) _makeContentsFromItemList:(NSArray*) popupListComponentItems
{
    int numButtons = popupListComponentItems.count;
    
    CGSize buttonFrameSize = [self _calculateNeededButtonSize:popupListComponentItems];
    
    
    SEL selector = @selector(selectionMadeCallback:);
    
    NSMutableArray* buttonArray = [[NSMutableArray alloc] initWithCapacity: numButtons];
    
    NSInteger maxY = 0;
    NSInteger maxX = 0;
    
    NSInteger yoffset = 0;
    for (PopupListComponentItem* item in popupListComponentItems) {
        
        UIButton* option = [self _makeButtonForItem:item yOffset:yoffset  xOffset:0  callbackSelector:selector withButtonMaxSize: buttonFrameSize];
        
        CGPoint origin = option.frame.origin;
        CGSize size = option.frame.size;
        if (maxY < origin.y + size.height) {
            maxY = origin.y + size.height;
        }
        if (maxX < origin.x + size.width) {
            maxX = origin.x + size.width;
        }
        [buttonArray addObject:option];
        
        // Figure offset for next button to be created
        yoffset += size.height + self.buttonSpacing;
    }
    
    CGRect rect = CGRectMake(0, 0, maxX + 10 , maxY + 10);
    //CGSize size = CGSizeMake(maxX, maxY + 10);
    UIView* view = [[UIView alloc] initWithFrame: rect];
    
    view.backgroundColor = [UIColor blackColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4.0f;
   
   /* UIImage* image = [UIImage imageNamed:@"popoverBg"];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:rect];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:newimage];*/
    for (int i=0; i<numButtons; i++) {
        UIButton* b = (UIButton*) [buttonArray objectAtIndex:i];
        
        b.frame = CGRectMake(b.frame.origin.x + 5,b.frame.origin.y + 5, b.frame.size.width , b.frame.size.height );
        //b.backgroundColor = [UIColor whiteColor];
        b.layer.masksToBounds = YES;
        b.layer.cornerRadius = 4.0f;
        b.layer.borderColor = [UIColor blackColor].CGColor;
        b.layer.borderWidth = 1.0f;
        [view addSubview:b];
    }
    
    return view;

}


// Invoked by popup when an item is selected by user.
// Notify delegate and cancel/remove popup.
- (void) selectionMadeCallback: (id) sender
{
    if (LOG) NSLog(@"popoverButtonTouchUpInside callback activated by: %@", sender);
    
    UIButton* b = (UIButton*) sender;
    
    NSInteger tag = b.tag;
    [self notifyDelegateOfSelection: tag];
}


// Used by local code here in this component to handle manual hiding of popup
// (vs WEPopup internal code that hides when user taps outside popoup in parent view)
- (void) _manualDismissPopover
{
    // Note: safe to call even if self.myPopover is nil
    [self.myPopover dismissPopoverAnimated:YES];
    [self.myPopover setDelegate:nil];
    self.myPopover = nil;
}




@end
