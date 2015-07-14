// npcact_cms_ctn10 = - 10000 okay
int StartingConditional()
{
    int nAmount=-10000;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount>=0) return TRUE;
    return FALSE;
}
