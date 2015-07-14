// npcact_cms_ctn1t = - 10 okay
int StartingConditional()
{
    int nAmount=-10;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount>=0) return TRUE;
    return FALSE;
}
