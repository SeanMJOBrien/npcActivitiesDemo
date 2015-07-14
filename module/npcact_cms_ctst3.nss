// npcact_cms_cts3
int StartingConditional()
{
    object oPC=GetPCSpeaker();
    string sS=GetLocalString(oPC,"sCMSSelection");
    int nS=GetLocalInt(oPC,"nCMSSelection");
    SetCustomToken(999991,sS);
    SetCustomToken(999992,IntToString(nS));
    if (GetLocalInt(oPC,"nCMSMode")>0) return TRUE;
    return FALSE;
}
