//
//  HPSegment.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/23.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "HPSegment.h"
#import "NSString+HPUtil.h"
#import "UIView+HPUtil.h"
#import "POP.h"
#import <CoreText/CoreText.h>

#pragma mark - HPTextLayer
typedef NS_ENUM(NSUInteger, HPRedPointOffsetType) {
    HPRedPointOffsetTypeRightTop        =   0,
    HPRedPointOffsetTypeLeftTop         =   1,
    HPRedPointOffsetTypeRightBottom     =   2,
    HPRedPointOffsetTypeLeftBottom      =   3,
};

@interface HPTextLayer : CATextLayer

@property (nonatomic, assign) BOOL redPoint;
@property (nonatomic, strong) UIColor * pointColor;
@property (nonatomic, assign) CGFloat redPointRadius;
@property (nonatomic, assign) HPRedPointOffsetType offsetType;
@property (nonatomic, assign) CGPoint offsetPoint;

@end

@implementation HPTextLayer
- (instancetype)init{
    if (self = [super init]) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    _pointColor = [UIColor redColor];
    _redPointRadius = 4.0f;
    _offsetType = HPRedPointOffsetTypeRightTop;
    _offsetPoint = CGPointMake(2.0f, 4.0f);
}

- (void)setRedPoint:(BOOL)redPoint {
    if (redPoint != _redPoint) {
        _redPoint = redPoint;
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat scale = self.contentsScale;
    scale = scale > 0.0f ? scale : 1.0f;
    CGFloat yDiff = ( self.bounds.size.height - self.fontSize / scale ) * 0.5f;
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0, yDiff);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
    //
    if ( _redPoint ) {
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        id string = self.string;
        if ([string isKindOfClass:[NSAttributedString class]]) {
            string = [string string];
        }
        CGFloat width = HPTextWidth(string, [UIFont fontWithName:(__bridge NSString *)CTFontCopyPostScriptName(self.font) size:self.fontSize / scale]) * 0.5f;
        CGRect rect = CGRectMake(0.0f, 0.0f, _redPointRadius, _redPointRadius);
        CGFloat centerX = self.bounds.size.width * 0.5f;
        CGFloat centerY = self.bounds.size.height * 0.5f;
        switch ( _offsetType ) {
            case HPRedPointOffsetTypeLeftTop:
                rect.origin.x = centerX - _offsetPoint.x - width;
                rect.origin.y = centerY - _offsetPoint.y - _redPointRadius;
                break;
            case HPRedPointOffsetTypeLeftBottom:
                rect.origin.x = centerX - _offsetPoint.x - width;
                rect.origin.y = centerY + _offsetPoint.y;
                break;
            case HPRedPointOffsetTypeRightBottom:
                rect.origin.x = centerX + _offsetPoint.x + width;
                rect.origin.y = centerY + _offsetPoint.y;
                break;
            default:
                rect.origin.x = centerX + _offsetPoint.x + width;
                rect.origin.y = centerY - _offsetPoint.y - _redPointRadius;
                break;
        }
        CGContextFillEllipseInRect(ctx, rect);
    }
}
@end

#pragma mark - HPSegmentScrollView
@interface HPSegmentScrollView : UIScrollView
@end

@implementation HPSegmentScrollView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}
@end

#pragma mark - HPSegment
@implementation HPSegment{
    UIView * _separatorLine;
    NSMutableArray<NSValue *> * _itemRectList;
    //
    CALayer * _curLayer;
    NSMutableArray<HPTextLayer *> * _cacheLayers;
    //
    HPSegmentScrollView * _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpData];
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpData];
        [self setUp];
    }
    return self;
}

- (void)setUpData {
    self.backgroundColor = RGB(256.0f, 256.0f, 256.0f);
    self.horizontalGap = 26.0f;
    self.type = HPSegmentTypeDynamicWidth;
    //
    _normalFont = [UIFont systemFontOfSize:13.0f];
    _selectedFont = [UIFont systemFontOfSize:14.0f];
    _normalColor = COLOR_HEX(0x848484);
    _selectedColor = NAV_FGC;
    _itemLineInsets = UIEdgeInsetsMake(1.5f, 10.0f, 3.0f, 10.0f);
    //
    _itemRectList = [NSMutableArray array];
    _cacheLayers = [NSMutableArray array];
    _selectedIndex = -1;//必须为－1
}

- (void)setUp {
    _scrollView = [[HPSegmentScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    //
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = COLOR_HEX(0xdddddd);
    [self addSubview:_separatorLine];
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_separatorLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.6f]];
    // 底部Layer
    _curLayer = [CALayer layer];
    // _curLayer.cornerRadius = 1.0f;
    _curLayer.backgroundColor = NAV_FGC.CGColor;
    _curLayer.zPosition = 1;
    [_scrollView.layer addSublayer:_curLayer];
}

- (void)setItems:(NSArray<NSString *> *)items oneWidth:(CGFloat) width {
    _type = HPSegmentTypeFixedWidth;
    _itemFixedWidth = width;
    [self setItems:items];
}

- (void)setItems:(NSArray<NSString *> *)items {
    [_itemRectList removeAllObjects];
    //计算段宽需要用到参数
    __block CGFloat originX = 0.0f;
    CGFloat originY = _itemLineInsets.top;
    CGFloat sizeHeight = self.height - _itemLineInsets.bottom;
    UIFont * font = self.normalFont;
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectMake(originX, originY, 0.0f, sizeHeight);
        rect.origin.x = originX;
        if ( self.type == HPSegmentTypeFixedWidth ) {
            rect.size.width = self.itemFixedWidth;
            originX = originX + rect.size.width;
        } else {
            rect.size.width = HPTextWidth(obj, font) + self.horizontalGap;
            originX = originX + rect.size.width;
        }
        NSValue * value = [NSValue valueWithCGRect:rect];
        [self->_itemRectList addObject:value];
        //
        HPTextLayer * textLayer = nil;
        if ( idx < self->_cacheLayers.count ) {
            textLayer = [self->_cacheLayers objectAtIndex:idx];
            textLayer.redPoint = NO;
        } else {
            textLayer = [self createTextLayer];
            [self->_scrollView.layer addSublayer:textLayer];
            [self->_cacheLayers addObject:textLayer];
        }
        textLayer.string = [self attributedTitleForString:obj isSelected:NO];
        textLayer.frame = rect;
    }];
    //移除越界的layer
    if ( items.count < _cacheLayers.count ) {
        NSRange removeRange = NSMakeRange(items.count, _cacheLayers.count - items.count);
        NSArray<CATextLayer *> * removeArray = [_cacheLayers subarrayWithRange:removeRange];
        [removeArray enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
        [_cacheLayers removeObjectsInRange:removeRange];
    }
    //
    _scrollView.contentSize = CGSizeMake(originX, self.height);
    //重置选中0
    self.selectedIndex = 0;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex && selectedIndex < _cacheLayers.count) {
        [self setIndex:_selectedIndex isSelected:NO];
        _selectedIndex = selectedIndex;
        [self setIndex:_selectedIndex isSelected:YES];
        [self resetCurIndex];
    }
}

- (void)setIndex:(NSInteger)index isSelected:(BOOL)isSelected {
    if (self.selectedIndex >= 0 && self.selectedIndex < _cacheLayers.count) { //过滤越界
        CATextLayer * textLayer = [_cacheLayers objectAtIndex:self.selectedIndex];
        NSAttributedString * string = textLayer.string;
        textLayer.string = [self attributedTitleForString:string.string isSelected:isSelected];
    }
}

- (void)resetCurIndex {
    NSValue * value = [_itemRectList objectAtIndex:self.selectedIndex];
    CGRect rect = [value CGRectValue];
    CGFloat newX = CGRectGetMidX(rect);
    CGFloat newWidth = rect.size.width - _itemLineInsets.left - _itemLineInsets.right;
    //
    POPSpringAnimation * anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.fromValue = @(_curLayer.position.x);
    anim.toValue = @(newX);
    anim.springSpeed = 8;
    [_curLayer pop_addAnimation:anim forKey:@"MOVING"];
    POPSpringAnimation * anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    anim2.fromValue = [NSValue valueWithCGSize:_curLayer.bounds.size];
    anim2.toValue = [NSValue valueWithCGSize:CGSizeMake(newWidth, 3.0f)];
    [_curLayer pop_addAnimation:anim2 forKey:@"MOVING2"];
    //
    CGFloat offsetX = newX - self.width * 0.5f;
    offsetX = MAX(-_scrollView.contentInset.left, offsetX);
    offsetX = MIN(_scrollView.contentSize.width + _scrollView.contentInset.right > self.width ? _scrollView.contentSize.width + _scrollView.contentInset.right - self.width : 0.0f, offsetX);
    offsetX = self.width == 0 ? -_scrollView.contentInset.left : offsetX;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:YES];
}

- (void)didChangedSegmentValue:(NSInteger)value {
    [self setSelectedIndex:value];
    if ( self.segmentDidChangeSelectedValue ) {
        self.segmentDidChangeSelectedValue(self.selectedIndex);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //校正底部滑动layer位置
    CGRect frame = _curLayer.frame;
    frame.origin.y = self.height - _itemLineInsets.bottom + 0.8f;
    _curLayer.frame = frame;
    //校正高
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, self.height);
    //校正所有文案位置
    CGFloat originY = _itemLineInsets.top;
    CGFloat sizeHeight = self.height - _itemLineInsets.bottom;
    [_cacheLayers enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.origin.y = originY;
        frame.size.height = sizeHeight;
        obj.frame = frame;
    }];
}

#pragma mark - Helper
- (HPTextLayer *) createTextLayer {
    HPTextLayer * layer = [HPTextLayer layer];
    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    //
    return layer;
}

- (NSAttributedString *)attributedTitleForString:(NSString *)string isSelected:(BOOL)isSelected {
    string = string ? string : @"NAN";
    return [[NSAttributedString alloc] initWithString:string attributes:
            @{
              NSFontAttributeName : isSelected ? _selectedFont : _normalFont,
              NSForegroundColorAttributeName : isSelected ? (__bridge id)self.selectedColor.CGColor : (__bridge id)self.normalColor.CGColor,
              }
            ];
}

#pragma mark - Touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if ( CGRectContainsPoint(self.bounds, touchLocation) ) {
        CGFloat pointX = _scrollView.contentOffset.x + touchLocation.x;
        __block NSInteger index = -1;
        [_itemRectList enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = [obj CGRectValue];
            if ( rect.origin.x <= pointX && rect.origin.x + rect.size.width >= pointX ) {
                index = idx;
                *stop = YES;
            }
        }];
        if (index != -1) {
            [self didChangedSegmentValue:index];
        }
    }
}

#pragma mark - RedPoint
- (void)addRedPointAtIndex:(NSUInteger)index {
    if (index < _cacheLayers.count) {
        HPTextLayer *layer = [_cacheLayers objectAtIndex:index];
        layer.redPoint = YES;
    }
}

- (void)removeRedPointAtIndex:(NSUInteger)index {
    if (index < _cacheLayers.count) {
        HPTextLayer * layer = [_cacheLayers objectAtIndex:index];
        layer.redPoint = NO;
    }
}

- (BOOL)hadRedPointAtIndex:(NSUInteger)index {
    if (index < _cacheLayers.count) {
        HPTextLayer *layer = [_cacheLayers objectAtIndex:index];
        return layer.redPoint;
    }
    return NO;
}
@end
