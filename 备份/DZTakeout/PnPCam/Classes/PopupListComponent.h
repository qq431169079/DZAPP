//
//  PopupListComponent.h
//  PopupList
//
//  Created by yan luke on 13-1-8.
//  Copyright (c) 2013年 yan luke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@class PopupListComponent;

@protocol PopupListComponentDelegate 

@optional
- (void) popupListcomponent:(PopupListComponent *)sender choseItemWithId:(int)itemId;
- (void) popupListcompoentDidCancel:(PopupListComponent *)sender;

@end

@interface PopupListComponentItem : NSObject{
    NSString* caption;
    UIImage* image;
    int itemId;
    BOOL showCaption;
}
@property (nonatomic, retain) NSString* caption;
@property (nonatomic, retain) UIImage* image;
@property int itemId;
@property BOOL showCaption;

- (id) initWithCaption:(NSString*)caption image:(UIImage*)image itemId:(int)itemId showCaption:(BOOL)showCaption;

@end



@interface PopupListComponent : NSObject{
    id<PopupListComponentDelegate> delegate;
    UIFont* font;
    UIColor* textColor;
    UIColor* textHilightedColor;
    int buttonSpacing;               // default: 10
    int textPaddingHorizontal;       // default: 10
    int textPaddingVertical;         // default:  5
    int imagePaddingHorizontal;      // default: 10
    int imagePaddingVertical;
    UIControlContentHorizontalAlignment alignment;
    UIPopoverArrowDirection allowedArrowDirections;
    id userInfo;
    
}
@property (nonatomic, assign) UIFont* font;        // default: system font, larger on ipad
@property (nonatomic, assign) UIColor* textColor;  // default: white
@property (nonatomic, assign) UIColor* textHilightedColor;  // default: gray
@property int buttonSpacing;               // default: 10
@property int textPaddingHorizontal;       // default: 10
@property int textPaddingVertical;         // default:  5
@property int imagePaddingHorizontal;      // default: 10
@property int imagePaddingVertical;        // default:  5
@property UIControlContentHorizontalAlignment alignment;   // default: center
@property UIPopoverArrowDirection allowedArrowDirections;  // Can OR values together
@property (nonatomic, assign) id<PopupListComponentDelegate> delegate;
@property (nonatomic, assign) id userInfo;
- (id) init;  // Designated initializer

/*
 Call this method to have this object build and show the UI elements for your
 itemList as a popup list. Puts UI on screen and returns. Does not block waiting
 for user input!
 */
- (void) showAnchoredTo: (UIView*)sourceItem inView:(UIView*)parentView withItems:(NSArray*)itemList withDelegate:(id<PopupListComponentDelegate>)delegate;

-(void)showPopFromBarButtonItem:(UIBarButtonItem*)barbuttonItem inView:(UIView*)parentView withItems:(NSArray*)itemList withDelegate:(id<PopupListComponentDelegate>)delegate;

- (void) hide;  // Removes visual components, but leaves this object usable again via another call to showAnchoredTo:...

// Leave size and other aspects alone, but switch to non-bold version:
- (void) useSystemDefaultFontNonBold;
// Leave size and other aspects alone, but switch to bold version:
- (void) useSystemDefaultFontBold; // (this is the default setting)



@end
