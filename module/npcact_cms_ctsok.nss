// npcact_cms_ctsok - Is it okay to split?
int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oItem=GetLocalObject(oPC,"oCMSItem");
    if (GetLocalInt(oItem,"nCoins")>1) return TRUE;
    return FALSE;
}
