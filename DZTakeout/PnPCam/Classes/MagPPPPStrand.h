#ifndef _HMagPPPPStrand_H_
#define _HMagPPPPStrand_H_
#include <stdio.h>
#import <Foundation/Foundation.h>

enum EM_USE_P2PVER
{
    USE_P2PVER_PPPP = 0,
    USE_P2PVER_XQP2P  =1,
};

@interface MagPPPPStrand: NSObject
+(id)sharedInstance;

-(NSString*) getP2PStrand:(NSString*)strUidPrefix;
-(void) P2PStrandSynchronize;

@end

#endif
