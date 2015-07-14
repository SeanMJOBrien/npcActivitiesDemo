// npcact_cms_cts1h = + 1h okay
int StartingConditional()
{
    int nAmount=100;
    int nMax=GetLocalInt(GetPCSpeaker(),"nCMSMax");
    int nCur=GetLocalInt(GetPCSpeaker(),"nCMSSelection");
    if (nCur+nAmount<=nMax) return TRUE;
    return FALSE;
}
