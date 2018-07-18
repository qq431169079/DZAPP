//
//  SellerBusinessViewController.m
//  DZTakeout
//
//  Created by HuangPan on 2018/6/20.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "SellerBusinessViewController.h"
#import "SellerCommentsAndOrdersContainerController.h"
#import "SellerBusinessRelatedViews.h"
#import "CompanyModel.h"
#import <UIImageView+WebCache.h>
#import "NSString+HPUtil.h"
#import "UIImage+LEAF.h"
#import "DZSearchViewController.h"

#define ASPECT_BLUR_HEIGHT (ASPECT_NAV_HEIGHT * 2.0f)

@interface SellerBusinessViewController ()<UIGestureRecognizerDelegate> {
    CGFloat _maxSlideOriginY;
    CGFloat _minSlideOriginY;
    
    CompanyModel *_companyModel;
    CGRect _oldNameLabelFrame;
}

@property (nonatomic, strong) SellerCommentsAndOrdersContainerController *containerViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *blurImgView;
@property (nonatomic, strong) PartInfo_NavBar *navBar;
@property (nonatomic, strong) PartInfo_Summary *summary;
@property (nonatomic, strong) PartInfo_Details *details;

@end

@implementation SellerBusinessViewController
#pragma mark - Initialize Methods
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _maxSlideOriginY = 250;
    _minSlideOriginY = ASPECT_NAV_HEIGHT;
    
    CGRect frame = self.view.bounds;
    frame.origin.y = ASPECT_BLUR_HEIGHT + 50;
    frame.size.height -= frame.origin.y;
    [self addChildViewController:self.containerViewController];
    [self.containerViewController didMoveToParentViewController:self];
    self.containerViewController.view.frame = frame;
    [self.view addSubview:self.containerViewController.view];
    
    [self addSlideGestureRecognizer];
    
    [self fetchCompanyInfoFromServer];
    
    __weak typeof(self) wself = self;
    [UserHelper temporaryCacheObject:wself forKey:kOrderDetailsCacheKey];
}

- (void)onReturnBackComplete:(void (^)(void))complete {
    [UserHelper removeTemporaryObjectForKey:kOrderDetailsCacheKey];
    [super onReturnBackComplete:complete];
}

- (void)setupSubviews {
    [self.view addSubview:self.blurImgView];
    [self.view addSubview:self.summary];
    [self.view addSubview:self.details];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.nameLabel];
    
    @weakify(self);
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ASPECT_NAV_HEIGHT);
    }];
    [self.blurImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ASPECT_BLUR_HEIGHT);
    }];
    [self.summary mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ASPECT_BLUR_HEIGHT - 65);
        make.height.mas_equalTo(80);
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.blurImgView.mas_bottom);
    }];
    _oldNameLabelFrame = CGRectMake(115, ASPECT_NAV_HEIGHT - 12, SCREEN_WIDTH - 105, 44);
    self.nameLabel.frame = _oldNameLabelFrame;
}

- (CGFloat)slideViewRatio {
    return 0.5f;
}

- (void)updateUIIfNeeded {
    self.summary.model = _companyModel;;
    
    self.details.items = _companyModel.list;
    
    [self.blurImgView sd_setImageWithURL:[NSURL URLWithString:_companyModel.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *blurImage = [image blurWithRadius:10.0f tintColor:[UIColor colorWithWhite:0.0f alpha:0.2f] saturationDeltaFactor:2.0 maskImage:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                self.blurImgView.image = blurImage;
            });
         });
    }];
    
    CGFloat maxWidth = SCREEN_WIDTH - 100;
    CGFloat width = [_companyModel .name sizeWithMaxWidth:CGFLOAT_MAX font:self.nameLabel.font].width;
    width = MIN(maxWidth, width);
    CGRect rect = _oldNameLabelFrame;
    rect.size.width = width;
    _oldNameLabelFrame = rect;
    self.nameLabel.frame = rect;
    self.nameLabel.text = _companyModel.name;
    
    // 更新物流费
    self.containerViewController.logisticsPrice = _companyModel.assess;
}

#pragma mark - Network
- (void)fetchCompanyInfoFromServer {
    if (self.companyId.length == 0) {return;}
    NSDictionary *params = @{@"id":self.companyId,
                             @"location":@"22.6733000000,114.0651500000",
                             @"find":@""
                             };
    [DZRequests post:@"FindCompany" parameters:params success:^(id record) {
        _companyModel = [CompanyModel modelWithJSON:record];
        [self updateUIIfNeeded];
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}
//收藏
-(void)collectionBusiness{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.companyId,@"cid",
                            [UserHelper userToken],@"token",
                            nil];
    [DZRequests post:@"saveORupdate" parameters:params success:^(id record) {
        _companyModel = [CompanyModel modelWithJSON:record];
        occasionalHint(@"收藏成功");
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

//搜索页面
-(void)gotoSearchVC{
    DZSearchViewController *searchVC = [[DZSearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
}

- (void)addSlideGestureRecognizer {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleChildPanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [self.containerViewController.view
     addGestureRecognizer:self.panGestureRecognizer];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *sender = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint offset = [sender translationInView:sender.view];
        CGRect frame = self.containerViewController.view.frame;
        return ((offset.y <= 0 && frame.origin.y > _minSlideOriginY) || (offset.y > 0.0f && frame.origin.y < _maxSlideOriginY));
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleChildPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGFloat offset = [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
    static BOOL shouldAnimateBegin = NO;
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            //当顶部并未出现而向上滑动时要触发动画｜当顶部已经出现且向下滑动时要触发动画
            CGRect frame = self.containerViewController.view.frame;
            shouldAnimateBegin = ((offset <= 0 && frame.origin.y > _minSlideOriginY) || (offset > 0.0f && frame.origin.y < _maxSlideOriginY));;
        }   break;
        case UIGestureRecognizerStateChanged: {
            if (shouldAnimateBegin) {
                [self animatingWhenPanGestureTranslatingY:offset];
            }
        }   break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            if (shouldAnimateBegin) {
                //[self animationWhenPanGestureStop];
                shouldAnimateBegin = NO;
            }
        }   break;
        default: break;
    }
    [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
}

- (void)animationWhenPanGestureStop {

    CGFloat currentTop = self.containerViewController.view.frame.origin.y;
    CGFloat percentage = (currentTop - _minSlideOriginY) / (_maxSlideOriginY - _minSlideOriginY);
    NSTimeInterval duration = 0.5f; //全程动画执行时间
    BOOL isAppearBackground = percentage >= 0.5f;   //是否需要自动下拉打开背景显示
    duration = isAppearBackground ? (1.0f - percentage) * duration : percentage * duration;
    //新的frame
    CGRect frame = isAppearBackground ? CGRectMake(0.0f, _maxSlideOriginY, self.view.bounds.size.width, self.view.bounds.size.height - _maxSlideOriginY) : CGRectMake(0.0f, _minSlideOriginY, self.view.bounds.size.width, self.view.bounds.size.height - _minSlideOriginY);
    [UIView animateWithDuration:duration animations:^{
        self.containerViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        self.panGestureRecognizer.enabled = YES;
    }];
}

#pragma mark - 动画响应
- (void)animatingWhenPanGestureTranslatingY:(CGFloat)offset {
    //调整子视图到顶部的距离
    CGRect frame = self.containerViewController.view.frame;
    frame.origin.y = frame.origin.y + offset;
    frame.origin.y = frame.origin.y > _minSlideOriginY ? frame.origin.y : _minSlideOriginY;
    frame.origin.y = frame.origin.y < _maxSlideOriginY ? frame.origin.y : _maxSlideOriginY;
    frame.size.height = SCREEN_HEIGHT - frame.origin.y;
    self.containerViewController.view.frame = frame;
    
    CGFloat progress = (frame.origin.y - _minSlideOriginY)/(_maxSlideOriginY - _minSlideOriginY);
    [self.navBar setAnimationProgress:progress];
    [self.summary setAnimationProgress:progress];
    [self setAnimationsProgress:progress];
}

#pragma mark - Private Functions
- (void)setAnimationsProgress:(CGFloat)progress {
    if (progress < 0) { progress = 0; }
    if (progress > 1) { progress = 1; }
    // 标题动画
    CGFloat inNavBarX = 40.0f;
    CGFloat inNavBarY = ASPECT_STATUS_BAR_H;
    CGFloat oldX = CGRectGetMinX(_oldNameLabelFrame);
    CGFloat oldY = CGRectGetMinY(_oldNameLabelFrame);
    CGFloat startX = MIN(inNavBarX, oldX);
    CGFloat dx = MAX(inNavBarX, oldX) - startX;
    CGFloat startY = MIN(inNavBarY, oldY);
    CGFloat dy = MAX(inNavBarY, oldY) - startY;
    self.nameLabel.frame = CGRectMake(startX + dx * progress, startY + dy * progress, _oldNameLabelFrame.size.width, _oldNameLabelFrame.size.height);
    // 毛玻璃背景动画
    dy = ASPECT_NAV_HEIGHT + (ASPECT_BLUR_HEIGHT - ASPECT_NAV_HEIGHT) * progress;
    [self.blurImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(dy);
    }];
}

#pragma mark - Getter & Setter
- (PartInfo_NavBar *)navBar {
    if (!_navBar) {
        _navBar = [PartInfo_NavBar new];
        _navBar.backgroundColor = [UIColor clearColor];
        @weakify(self);
        _navBar.onPopBackHandler = ^{
            @strongify(self);
            [self onReturnBackComplete:nil];
        };
        //收藏
        _navBar.onCheckMoreHandler = ^{
            @strongify(self);
            [self collectionBusiness];
        };
        //搜索
        _navBar.onSearchHandler = ^{
            @strongify(self);
            [self gotoSearchVC];
        };
    }
    return _navBar;
}

- (PartInfo_Summary *)summary {
    if (!_summary) {
        _summary = [PartInfo_Summary new];
        _summary.backgroundColor = [UIColor clearColor];
    }
    return _summary;
}

- (PartInfo_Details *)details {
    if (!_details) {
        _details = [PartInfo_Details new];
    }
    return _details;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    return _nameLabel;
}

- (UIImageView *)blurImgView {
    if (!_blurImgView) {
        _blurImgView = [UIImageView new];
        _blurImgView.contentMode = UIViewContentModeScaleAspectFill;
        _blurImgView.clipsToBounds = YES;
    }
    return _blurImgView;
}

- (SellerCommentsAndOrdersContainerController *)containerViewController {
    if (!_containerViewController) {
        _containerViewController = [SellerCommentsAndOrdersContainerController controller];
        _containerViewController.companyId = self.companyId;
    }
    return _containerViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
