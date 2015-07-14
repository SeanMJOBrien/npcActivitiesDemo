// npcact_cms_ctn1k = - 1000 okay
int StartingConditional()
{
    int nAmount=-1000;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount>=0) return TRUE;
    return FALSE;
}
