// npcact_cms_ctn1h = - 100 okay
int StartingConditional()
{
    int nAmount=-100;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount>=0) return TRUE;
    return FALSE;
}
