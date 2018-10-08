//
//  Header.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/5.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#ifndef HPNETMacro_h
#define HPNETMacro_h

#define DZBaseURL @"http://39.108.6.102:8080"
//首页
#define DZHomeURL [NSString stringWithFormat:@"%@/DzClient/index/index.html",DZBaseURL]
//新增地址
#define DZAddNewAddr(token) [NSString stringWithFormat:@"%@/DzClient/newAddr/new-addr.html?token=%@",DZBaseURL,token]
//编辑地址
#define DZUserAddrUpdateURL(token,addressID) [NSString stringWithFormat:@"%@/DzClient/userAddr/update-addr.html?token=%@&id=%@",DZBaseURL,token,addressID]
//宝箱
#define DZTreasureURL [NSString stringWithFormat:@"%@/DzClient/treasure/treasure.html",DZBaseURL]
//用户地址
#define DZUserAddr(token) [NSString stringWithFormat:@"%@/DzClient/userAddr/user-addr.html?token=%@",DZBaseURL,token]
//用户订单
#define DZUserAllOrder(token) [NSString stringWithFormat:@"%@/DzClient/allOrder/all-order.html?token=%@",DZBaseURL,token]
//我的收藏
#define DZUserFavorite(token) [NSString stringWithFormat:@"%@/DzClient/favorite/favorite.html?token=%@",DZBaseURL,token]
//我的评论
#define DZUserComment(token) [NSString stringWithFormat:@"%@/DzClient/comment/comment.html?token=%@",DZBaseURL,token]
//活动地址
#define DZActivityURL [NSString stringWithFormat:@"%@/DzClient/activitySearch/ActivitySearch.html",DZBaseURL]
//预定餐桌提示
#define DZBookTimeURL [NSString stringWithFormat:@"%@/Dz/bookTime?view",DZBaseURL]
//预定餐桌提示
#define DZOrderDetailURL [NSString stringWithFormat:@"%@/DzClient/orderDetail/orderindex.html",DZBaseURL]
//订座
#define DZSelectSeatURL [NSString stringWithFormat:@"%@/DzClient/selectSeat/select-seat.html",DZBaseURL]
//订座包厢
#define DZSelectBXURL [NSString stringWithFormat:@"%@/DzClient/selectSeat/select-bx.html",DZBaseURL]
//付款定金
#define DZOrderFoodURL [NSString stringWithFormat:@"%@/DzClient/goodsList/order-food.html",DZBaseURL]
//付款
#define DZClientPayURL [NSString stringWithFormat:@"%@/DzClient/pay/pay.html",DZBaseURL]
//搜索
#define DZClientSearchURL [NSString stringWithFormat:@"%@/DzClient/search/search.html",DZBaseURL]
//食物搜索
#define DZFooderSearchURL [NSString stringWithFormat:@"%@/DzClient/fooderSearch/fooderSearch.html",DZBaseURL]
//食物详情
#define DZFoodDetailURL [NSString stringWithFormat:@"%@/DzClient/foodDetail/shop.html",DZBaseURL]
//确定
#define DZCheckoutURL [NSString stringWithFormat:@"%@/DzClient/checkout/checkout.html",DZBaseURL]
//确定
#define DZCheckURL [NSString stringWithFormat:@"%@/DzClient/check/check.html",DZBaseURL]
//购物车付款确定
#define DZCartOrderDetailURL [NSString stringWithFormat:@"%@/DzClient/checkout/cart-order-detail.html",DZBaseURL]
//订单支付
#define DZTaskPayURL [NSString stringWithFormat:@"%@/DzClient/taskpay/pay.html",DZBaseURL]
//支付成功
#define DZPaySuccessURL [NSString stringWithFormat:@"%@/DzClient/paySuccess/pay-success.html",DZBaseURL]
//订餐成功
#define DZPredeFinedSuccessURL [NSString stringWithFormat:@"%@/DzClient/predefinedSuccess/predefined-success.html",DZBaseURL]
//订餐失败
#define DZPredeFinedFailureURL [NSString stringWithFormat:@"%@/DzClient/predefinedFailure/predefined-failure.html",DZBaseURL]
//商品列表
#define DZGoodsListURL [NSString stringWithFormat:@"%@/DzClient/goodsList/seller-comment.html",DZBaseURL]
//商品列表
#define DZGoodsShowURL [NSString stringWithFormat:@"%@/DzClient/goodsShow/order-food.html",DZBaseURL]
//结算清单
#define DZFoodReservationURL [NSString stringWithFormat:@"%@/DzClient/food_reservation/food_reservation.html",DZBaseURL]
//地图
#define DZMapURL [NSString stringWithFormat:@"%@/DzClient/map/map.html",DZBaseURL]
//评价
#define DZCommentOrderURL [NSString stringWithFormat:@"%@/DzClient/commentOrder/commentOrder.html",DZBaseURL]
#endif /* Header_h */
