// npcact_cms_cts10 = + 10K okay
int StartingConditional()
{
    int nAmount=10000;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount<=nMax) return TRUE;
    return FALSE;
}
