//
//  DZSearchViewController.m
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/4.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#import "DZSearchViewController.h"

#import "DZSearchTipCollectionView.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "DZSearchResultCollectionView.h"

#import "DZBMKLocationTool.h"
#import <MJRefresh/MJRefresh.h>
#import "CompanyModel.h"
@interface DZSearchViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) DZSearchTipCollectionView *searchTipCollectionView;
@property (nonatomic,weak) DZSearchResultCollectionView *searchResultCollectionView;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSMutableArray *searchHistoryArray;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,strong) NSString *curKeyWord;
@end

@implementation DZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self resetUI];
    [self getSearchTip];
    //重新获取当前坐标
    [[DZBMKLocationTool sharedInstance] requestLocationWithReGeocode:NO withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化修改
-(void)resetUI{

}

-(void)getSearchTip{
    DZWeakSelf(self)
    [self requestSearchHotTipSuccess:^(NSDictionary *record) {
        if ([[record allKeys]containsObject:@"list"]) {
            NSArray *list = record[@"list"];
            weakSelf.searchTipCollectionView.hotSearchArray = [NSArray arrayWithArray:list];
            [weakSelf.searchTipCollectionView reloadData];
        }
    }];
}
#pragma mark - Network
- (void)requestSearchHotTipSuccess:(void(^)(NSDictionary *record))success {
    [DZRequests post:@"SearchHotTip" parameters:nil success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            if (success) {
                success(recordDict);
            }
        }

    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}
//搜索
-(void)searchWithKeyWord:(NSString *)keyWord{
    self.searchTipCollectionView.hidden = YES;
    self.searchResultCollectionView.hidden = NO;
    
    
    self.curKeyWord = keyWord;
    self.curPage = 0;
    if(![self.searchHistoryArray containsObject:keyWord]){
        [self.searchHistoryArray addObject:keyWord];
        [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArray forKey:kDZSearchWordHistory];
    }else{
        [self.searchHistoryArray removeObject:keyWord];
        [self.searchHistoryArray insertObject:keyWord atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.searchHistoryArray forKey:kDZSearchWordHistory];
    }
    self.searchTipCollectionView.recordSearchArray = [NSMutableArray arrayWithArray:self.searchHistoryArray];
    [self.searchTipCollectionView reloadData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DZWeakSelf(self)
    [self.searchResultCollectionView.mj_footer resetNoMoreData];
    self.searchResultCollectionView.mj_footer.hidden = NO;
    [self requestSearchWithKeyWord:keyWord Success:^(NSDictionary *record) {
        if ([[record allKeys]containsObject:@"list"]) {
            NSArray *companyModelList = record[@"list"];
            NSArray *companyModelArray = [CompanyModel modelsWithArray:companyModelList];
            weakSelf.searchResultCollectionView.searchResultArray = [NSMutableArray arrayWithArray:companyModelArray];
            [weakSelf.searchResultCollectionView reloadData];
            if (companyModelList.count<10) {
                [weakSelf.searchResultCollectionView.mj_footer endRefreshingWithNoMoreData];
                weakSelf.searchResultCollectionView.mj_footer.hidden = YES;
            }
        }
    }];
}
//加载更多
-(void)addMoreList{
    self.curPage++;
    DZWeakSelf(self)
    [self requestSearchWithKeyWord:self.curKeyWord Success:^(NSDictionary *record) {
        if (record) {
            [weakSelf.searchResultCollectionView.mj_footer endRefreshing];
            if ([[record allKeys]containsObject:@"list"]) {
                NSArray *companyModelList = record[@"list"];
                NSArray *companyModelArray = [CompanyModel modelsWithArray:companyModelList];
                [weakSelf.searchResultCollectionView.searchResultArray addObjectsFromArray:companyModelArray];
                [weakSelf.searchResultCollectionView reloadData];
            }
        }else{
            [weakSelf.searchResultCollectionView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.searchResultCollectionView.mj_footer.hidden = YES;
        }
    }];
}
- (void)requestSearchWithKeyWord:(NSString *)keyWord Success:(void(^)(NSDictionary *record))success {
    BMKLocation *location = [DZBMKLocationTool sharedInstance].curLocation;
        NSString *coordinate = [NSString stringWithFormat:@"%f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                coordinate,@"location",
                                [NSString stringWithFormat:@"%ld",(long)self.curPage],@"start",
                                @"10",@"limit",
                                @"score",@"sort",
                                keyWord,@"keyword",
                                nil];
    [DZRequests post:@"SearchFoodKeyWord" parameters:parameters success:^(id record) {
        if ([record isKindOfClass:[NSDictionary class]]) {
            NSDictionary *recordDict = (NSDictionary *)record;
            if (success) {
                success(recordDict);
            }
        }
        
    } failure:^(HPRequestsError type, NSError *error) {
        occasionalHint(error.localizedDescription);
    }];
}

#pragma mark - 点击

- (IBAction)sartSearch:(id)sender {
    NSString *keyWord = self.searchTextField.text;
    [self searchWithKeyWord:keyWord];
}

- (IBAction)backBtnClick:(id)sender {
    if (_searchResultCollectionView && _searchResultCollectionView.hidden == NO) {
        self.searchResultCollectionView.hidden = YES;
        self.searchTipCollectionView.hidden = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

#pragma mark - 懒加载
-(DZSearchTipCollectionView *)searchTipCollectionView{
    if (_searchTipCollectionView == nil) {
        JYEqualCellSpaceFlowLayout *layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:5.0];
        
        layout.sectionInset = UIEdgeInsetsMake(8 , 12, 8, 12);
        DZSearchTipCollectionView *searchTipCollectionView = [[DZSearchTipCollectionView alloc]initWithFrame:self.mainView.bounds collectionViewLayout:layout];

        searchTipCollectionView.backgroundColor = RGB(245, 245, 245);
        DZWeakSelf(self)
        searchTipCollectionView.SearchTipBlock = ^(NSString *keyWord) {
            weakSelf.searchTextField.text = keyWord;
            [weakSelf searchWithKeyWord:keyWord];
        };
        searchTipCollectionView.clearHistorySearchTipBlock = ^{
            weakSelf.searchHistoryArray = nil;
        };
        [self.mainView addSubview:searchTipCollectionView];
        _searchTipCollectionView = searchTipCollectionView;
    }
    return _searchTipCollectionView;
}

-(DZSearchResultCollectionView *)searchResultCollectionView{
    if (_searchResultCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(100, 110);
        layout.minimumLineSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        DZSearchResultCollectionView *searchResultCollectionView = [[DZSearchResultCollectionView alloc]initWithFrame:self.mainView.bounds collectionViewLayout:layout];
        DZWeakSelf(self)
        searchResultCollectionView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf addMoreList];
        }];
        searchResultCollectionView.allowsMultipleSelection = NO;
        [self.mainView addSubview:searchResultCollectionView];
        _searchResultCollectionView = searchResultCollectionView;
    }
    return _searchResultCollectionView;
}

-(NSMutableArray *)searchHistoryArray{

    if (_searchHistoryArray == nil) {
        _searchHistoryArray = [NSMutableArray array];
        NSArray *searchHistoryArray = [[NSUserDefaults standardUserDefaults] objectForKey:kDZSearchWordHistory];
        if (searchHistoryArray) {
            [_searchHistoryArray addObjectsFromArray:searchHistoryArray];
        }
    }
    return _searchHistoryArray;
}
@end
