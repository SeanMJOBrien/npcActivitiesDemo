// npcact_cms_cts1t = + 10 okay
int StartingConditional()
{
    int nAmount=10;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount<=nMax) return TRUE;
    return FALSE;
}
