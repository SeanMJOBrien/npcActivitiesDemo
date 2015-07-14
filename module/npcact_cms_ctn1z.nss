// npcact_cms_ctn1z = - 1 okay
int StartingConditional()
{
    int nAmount=-1;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount>=0) return TRUE;
    return FALSE;
}
