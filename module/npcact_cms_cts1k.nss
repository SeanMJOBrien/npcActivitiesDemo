// npcact_cms_cts1k = + 1K okay
int StartingConditional()
{
    int nAmount=1000;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount<=nMax) return TRUE;
    return FALSE;
}
