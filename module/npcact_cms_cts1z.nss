// npcact_cms_cts1z = + 1 okay
int StartingConditional()
{
    int nAmount=1;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount<=nMax) return TRUE;
    return FALSE;
}
