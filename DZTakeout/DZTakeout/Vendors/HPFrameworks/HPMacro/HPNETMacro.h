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
//新增地址
#define DZAddNewAddr(token) [NSString stringWithFormat:@"%@/DzClient/newAddr/new-addr.html?token=%@",DZBaseURL,token]
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
#endif /* Header_h */
