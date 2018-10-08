

#include "PPPPChannelManagement.h"
//#include "libH264Dec.h"
#import "MagPPPPStrand.h"

CPPPPChannelManagement::CPPPPChannelManagement()
{
    memset(&m_PPPPChannel, 0 ,sizeof(m_PPPPChannel));
    
    m_Lock = [[NSCondition alloc] init];
    
    //PPPP_Initialize((CHAR*)"EFGFFBBOKAIEGEJKEIHCFPEGGOIHHHIADPBBFEHLBANJKKLMHBBHGCKHDLODNDLPFMNMLC");
    //PPPP_Initialize((CHAR*)"BPGBBOEOKJMBHJNCFFDFAEEJCMMHDANKDFADBNHDBGJMLDLOCIACCJOPHMLCJPKJABMELOCMOCJKABHGIANGNPBLIPOIFPCPAIGJDCFDMMLCEFHLACBDPGNA");
    //PPPP_Initialize((CHAR*)"EBGAEOBOKHJMHMJMENGKFIEEHBMDHNNEGNEBBCCCBIIHLHLOCIACCJOFHHLLJEKHBFMPLMCHPHMHAGDHJNNHIFBAMC");
    
    
    //InitH264Decoder();
    
    pCameraViewController = nil;
}

CPPPPChannelManagement::~CPPPPChannelManagement()
{
    StopAll();
    
    if (m_Lock != nil) {
        m_Lock = nil;
    }
    
    //PPPP_DeInitialize();
    
    //UninitH264Decoder();
    
}

int CPPPPChannelManagement::Start(const char * szDID, const char *user, const char *pwd, NSString * initializeStr,int LanSearch)
{
    if (NULL == szDID){
        return 0;
    }
    
//    if (g_IsAppEnterBackground) {
//        NSLog(@"CPPPPChannelManagement::Start APP进入后台 Start失效");
//        return 0;
//    }
    
#ifdef RICKY_PRINT_LOG
    NSLog(@"CPPPPChannelManagement::%s beg:%s.......%s....\n",__FUNCTION__,szDID,pwd);
#endif
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            [m_Lock lock];
            m_PPPPChannel[i].pPPPPChannel->ReconnectImmediately();
            [m_Lock unlock];
            
#ifdef RICKY_PRINT_LOG
            NSLog(@"CPPPPChannelManagement::%s END1:%s.......%s....\n",__FUNCTION__,szDID,pwd);
#endif
            return 1;
        }
    }
    
    NSString *subStr = [ [NSString stringWithUTF8String:szDID] substringWithRange:NSMakeRange(0, 4)];
    NSString* strP2PStrand  = [[MagPPPPStrand sharedInstance] getP2PStrand:[subStr uppercaseString]];
    if (strP2PStrand == nil || [strP2PStrand length] == 0) {
        NSLog(@"CPPPPChannelManagement::%s uid:%s P2PStrand not find Strand\n",__FUNCTION__,szDID);
        strP2PStrand = initializeStr;
        
        if (strP2PStrand == nil || [strP2PStrand length] == 0) {
            NSLog(@"CPPPPChannelManagement::%s uid:%s initializeStr not find Strand\n",__FUNCTION__,szDID);
            NSLog(@"CPPPPChannelManagement::%s END2:%s.......%s....\n",__FUNCTION__,szDID,pwd);
            return 0;
        }
    }
    
    if ([strP2PStrand length] == 0 ) {
        return 0;
    }
    
    int np2plib = USE_P2PVER_XQP2P;
    if ([strP2PStrand rangeOfString:@"-"].location == NSNotFound )
        np2plib =  USE_P2PVER_PPPP;
    else
        np2plib =  USE_P2PVER_XQP2P;
    
    NSLog(@"use P2PStrand UID:%@ PVer:%d Strand:%@ ",subStr,np2plib,strP2PStrand);
    
    [m_Lock lock];
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 0)
        {
            NSLog(@"CPPPPChannelManagement::%s new:%s.......%s....\n",__FUNCTION__,szDID,pwd);
            m_PPPPChannel[i].bValid = 1;
            strcpy(m_PPPPChannel[i].szDID, szDID);
            CCircleBuf *pVideoBuf = new CCircleBuf();
            m_PPPPChannel[i].pVideoBuf = pVideoBuf;
            
            CCircleBuf *pPlaybackVideoBuf = new CCircleBuf();
            m_PPPPChannel[i].pPlaybackVideoBuf = pPlaybackVideoBuf;
            m_PPPPChannel[i].pPPPPChannel = new CPPPPChannel(pVideoBuf, pPlaybackVideoBuf, szDID, user, pwd, strP2PStrand);
            m_PPPPChannel[i].pPPPPChannel->m_PPPPStatusDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->m_CameraViewSnapshotDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->m_SensorStatusDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->m_SensorAlarmDelegate = pCameraViewController;
            //m_PPPPChannel[i].pPPPPChannel->m_CameraDeviceTypeDelegate = pCameraViewController;
            //m_PPPPChannel[i].pPPPPChannel->m_CameraSensorListDelegate = pCameraViewController;
            m_PPPPChannel[i].pPPPPChannel->initializeStr = strP2PStrand;
            m_PPPPChannel[i].pPPPPChannel->nP2pLanSearch = LanSearch;
            m_PPPPChannel[i].pPPPPChannel->m_nP2pVer    = np2plib;
            m_PPPPChannel[i].pPPPPChannel->Start();
            [m_Lock unlock];
            
#ifdef RICKY_PRINT_LOG
            NSLog(@"CPPPPChannelManagement::%s END2:%s.......%s....\n",__FUNCTION__,szDID,pwd);
#endif
            return 1;
        }
    }
    
    [m_Lock unlock];
#ifdef RICKY_PRINT_LOG
    NSLog(@"CPPPPChannelManagement::%s END:%s.......%s....\n",__FUNCTION__,szDID,pwd);
#endif
    return 0;
}

int CPPPPChannelManagement::Stop(const char * szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            memset(m_PPPPChannel[i].szDID, 0, sizeof(m_PPPPChannel[i].szDID));
            SAFE_DELETE(m_PPPPChannel[i].pPPPPChannel);
            SAFE_DELETE(m_PPPPChannel[i].pVideoBuf);
            //SAFE_DELETE(m_PPPPChannel[i].pEglDisplay);
            SAFE_DELETE(m_PPPPChannel[i].pPlaybackVideoBuf);
            m_PPPPChannel[i].bValid = 0;
            
            [m_Lock unlock];
            
            return 1;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

void CPPPPChannelManagement::StopAll()
{
    [m_Lock lock];
    
    NSLog(@"StopAll begin....");
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1)
        {
            m_PPPPChannel[i].pPPPPChannel->SetStop();
        }
    }
    
    //  NSLog(@"StopAll 1111111");
    
    PPPP_Connect_Break();
    
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1)
        {
            //          NSLog(@"StopAll  channel: %d", i);
            memset(m_PPPPChannel[i].szDID, 0, sizeof(m_PPPPChannel[i].szDID));
            SAFE_DELETE(m_PPPPChannel[i].pPPPPChannel);
            SAFE_DELETE(m_PPPPChannel[i].pVideoBuf);
            //SAFE_DELETE(m_PPPPChannel[i].pEglDisplay);
            m_PPPPChannel[i].bValid = 0;
        }
    }
    
    //NSLog(@"StopAll end...");
    [m_Lock unlock];
}

int CPPPPChannelManagement::StartPPPPAudio(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StartAudio(1);
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPAudio(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StopAudio(1);
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StartPPPPTalk(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StartTalk();
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPTalk(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->StopTalk();
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::TalkAudioData(const char *szDID, const char *data, int len)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int nRet = m_PPPPChannel[i].pPPPPChannel->TalkAudioData(data, len);
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StartPPPPLivestream(const char * szDID, int streamid, int substreamID, id delegate)
{
    [m_Lock lock];
    NSLog(@"cpp liveStream");
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewPPPPStatusDelegate(delegate);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(delegate);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewImageNotifyDelegate(delegate);
            int nRet = m_PPPPChannel[i].pPPPPChannel->cgi_livestream(1, streamid,substreamID);
            [m_Lock unlock];
            return nRet;
        }
    }
    
    [m_Lock unlock];
    
    return 0;
}

int CPPPPChannelManagement::StopPPPPLivestream(const char * szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewPPPPStatusDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewImageNotifyDelegate(nil);
            m_PPPPChannel[i].pPPPPChannel->cgi_livestream(0, 16,4);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::GetCGI(const char* szDID, int cgi)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->get_cgi(cgi);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::GetJsonCGI(const char* szDID, int cgi,char *json){
    if (NULL == szDID) {
        return 0;
    }
    int i;
    [m_Lock lock];
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->get_json_cgi(cgi, json);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::PTZ_Control(const char *szDID, int command)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->PTZ_Control(command);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::CameraControl(const char *szDID, int param, int value)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->CameraControl(param, value);
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::Snapshot(const char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->Snapshot();
            [m_Lock unlock];
            return 1;
        }
    }
    
    [m_Lock unlock];
    return 0;
}

void CPPPPChannelManagement::SetPlaybackDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetPlaybackDelegate(delegate);
            [m_Lock unlock];
            return ;
        }
    }
    
    [m_Lock unlock];
    return ;
}

int CPPPPChannelManagement::PPPPStartPlayback(char *szDID, char *szFileName, int offset)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            if(1 == m_PPPPChannel[i].pPPPPChannel->StartPlayback(szFileName, offset))
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPGetSDCardRecordFileList(char *szDID, int PageIndex, int PageSize)
{
    [m_Lock lock];
    NSLog(@"szDID  %s  PageIndex  %d    PageSize   %d",szDID,PageIndex,PageSize);
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            STRU_SEARCH_SDCARD_RECORD_FILE sdcardsearch;
            memset(&sdcardsearch, 0, sizeof(sdcardsearch));
            sdcardsearch.PageIndex = PageIndex;
            sdcardsearch.PageSize = PageSize;
            if(1 == m_PPPPChannel[i].pPPPPChannel->SetSystemParams(MSG_TYPE_GET_RECORD_FILE, (char*)&sdcardsearch, sizeof(sdcardsearch)))
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPStopPlayback(char *szDID)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            if(1 == m_PPPPChannel[i].pPPPPChannel->StopPlayback())
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::PPPPSetSystemParams(char * szDID,int type,char * msg,int len)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            if(1 == m_PPPPChannel[i].pPPPPChannel->SetSystemParams(type, msg, len))
            {
                [m_Lock unlock];
                return 1;
            }
            else
            {
                [m_Lock unlock];
                return 0;
            }
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetSettingViewControllerParamsDelegate(char *szDID, id delegate){
    [m_Lock lock];
    int i;
    for (i = 0; i < MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0) {
            m_PPPPChannel[i].pPPPPChannel->SetPlayViewParamNotifyDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetWifiParamDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetWifiParamsDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetWifi(char *szDID, int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetWifi(enable, szSSID, channel, mode, authtype, encrypt, keyformat, defkey, strKey1, strKey2, strKey3, strKey4, key1_bits, key2_bits, key3_bits, key4_bits, wpa_psk);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}



int CPPPPChannelManagement::SetUserPwdParamDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetUserPwdParamsDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetUserPwd(char *szDID,char *user1,char *pwd1,char *user2,char *pwd2,char *user3,char *pwd3)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetUserPwd(user1, pwd1, user2, pwd2, user3, pwd3);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetDateTimeDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetDateTimeParamsDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}
int CPPPPChannelManagement::SetDateTime(char *szDID,int now,int tz,int ntp_enable,char *ntp_svr)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetDateTime(now, tz, ntp_enable, ntp_svr);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetAlarmDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetAlarmParamsDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetSDCardSearchDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetSDCardSearchDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetMailDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetMailDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetMail(char *szDID, char *sender, char *smtp_svr, int smtp_port, int ssl, int auth, char *user, char *pwd, char *recv1, char *recv2, char *recv3, char *recv4)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            int result = m_PPPPChannel[i].pPPPPChannel->SetMail(sender, smtp_svr, smtp_port, ssl, auth, user, pwd, recv1, recv2, recv3, recv4);
            [m_Lock unlock];
            return result;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}


int CPPPPChannelManagement::SetFTPDelegate(char *szDID, id delegate)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetFtpDelegate(delegate);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetFTP(char *szDID, char *szSvr, char *szUser, char *szPwd, char *dir, int port, int uploadinterval, int mode)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetFtp(szSvr, szUser, szPwd, dir, port, uploadinterval, mode);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
    
}

int CPPPPChannelManagement::SetAlarm(char *szDID,
                                     int motion_armed,
                                     int motion_sensitivity,
                                     int input_armed,
                                     int ioin_level,
                                     int alarmpresetsit,
                                     int iolinkage,
                                     int ioout_level,
                                     int mail,
                                     int upload_interval,
                                     int record)
{
    [m_Lock lock];
    
    int i;
    for(i = 0; i < MAX_PPPP_CHANNEL_NUM; i++)
    {
        if(m_PPPPChannel[i].bValid == 1 && strcmp(m_PPPPChannel[i].szDID, szDID) == 0)
        {
            m_PPPPChannel[i].pPPPPChannel->SetAlarm(motion_armed, motion_sensitivity, input_armed,  ioin_level, alarmpresetsit, iolinkage, ioout_level, mail,upload_interval,record);
            [m_Lock unlock];
            return 1;
            
        }
    }
    
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetSDcardScheduleDelegate(char *szDID, id delegate){
    [m_Lock lock];
    // NSLog(@"CPPPPChannelManagement::SetSDcardScheduleDelegate---11");
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            // NSLog(@"CPPPPChannelManagement::SetSDcardScheduleDelegate---222");
            m_PPPPChannel[i].pPPPPChannel->SetSDCardScheduleDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int CPPPPChannelManagement::SetSDcardScheduleParams(char *szDID,
                                                    int cover_enable,
                                                    int timeLength,
                                                    int fixed_enable,
                                                    int record_schedule_sun_0,
                                                    int record_schedule_sun_1,
                                                    int record_schedule_sun_2,
                                                    int record_schedule_mon_0,
                                                    int record_schedule_mon_1,
                                                    int record_schedule_mon_2,
                                                    int record_schedule_tue_0,
                                                    int record_schedule_tue_1,
                                                    int record_schedule_tue_2,
                                                    int record_schedule_wed_0,
                                                    int record_schedule_wed_1,
                                                    int record_schedule_wed_2,
                                                    int record_schedule_thu_0,
                                                    int record_schedule_thu_1,
                                                    int record_schedule_thu_2,
                                                    int record_schedule_fri_0,
                                                    int record_schedule_fri_1,
                                                    int record_schedule_fri_2,
                                                    int record_schedule_sat_0,
                                                    int record_schedule_sat_1,
                                                    int record_schedule_sat_2){
    [m_Lock lock];
    for (int i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID,szDID)==0) {
            int result= m_PPPPChannel[i].pPPPPChannel->SetSDCardScheduleParams(
                                                                               cover_enable,
                                                                               timeLength,
                                                                               fixed_enable,
                                                                               record_schedule_sun_0,
                                                                               record_schedule_sun_1,
                                                                               record_schedule_sun_2,
                                                                               record_schedule_mon_0,
                                                                               record_schedule_mon_1,
                                                                               record_schedule_mon_2,
                                                                               record_schedule_tue_0,
                                                                               record_schedule_tue_1,
                                                                               record_schedule_tue_2,
                                                                               record_schedule_wed_0,
                                                                               record_schedule_wed_1,
                                                                               record_schedule_wed_2,
                                                                               record_schedule_thu_0,
                                                                               record_schedule_thu_1,
                                                                               record_schedule_thu_2,
                                                                               record_schedule_fri_0,
                                                                               record_schedule_fri_1,
                                                                               record_schedule_fri_2,
                                                                               record_schedule_sat_0,
                                                                               record_schedule_sat_1,
                                                                               record_schedule_sat_2);
            [m_Lock unlock];
            return result;
        }
    }
    [m_Lock unlock];
    return 0;
}

int CPPPPChannelManagement::SetCameraSDCardStatusDelegate(char *szDID, id delegate){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetCameraSDCardStatusDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int CPPPPChannelManagement::SetCameraStatusDelegate(char *szDID, id delegate){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->SetCameraStatusDelegate(delegate);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

int CPPPPChannelManagement::FirmwareUpgrade(const char *szDID, char *downloadserverAdd, char *downfilename, int FirmwareType){
    [m_Lock lock];
    int i;
    for (i=0; i<MAX_PPPP_CHANNEL_NUM; i++) {
        if (m_PPPPChannel[i].bValid==1&&strcmp(m_PPPPChannel[i].szDID, szDID)==0) {
            m_PPPPChannel[i].pPPPPChannel->FirmwareUpgrade(downloadserverAdd, downfilename, FirmwareType);
            [m_Lock unlock];
            return 1;
        }
    }
    [m_Lock unlock];
    return  0;
}

