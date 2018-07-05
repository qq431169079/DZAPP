//
//  Header.h
//  DZTakeout
//
//  Created by 林鸿键 on 2018/7/5.
//  Copyright © 2018年 HuangPan. All rights reserved.
//

#ifndef HPNETMacro_h
#define HPNETMacro_h

#define DZBaseURL @"http://118.190.149.109:8081"
//新增地址
#define DZAddNewAddr(token) [NSString stringWithFormat:@"%@/DzClient/newAddr/new-addr.html?token=%@",DZBaseURL,token]
//用户地址
#define DZUserAddr(token) [NSString stringWithFormat:@"%@/DzClient/userAddr/user-addr.html?token=%@",DZBaseURL,token]

#endif /* Header_h */
