// npcact_cms_ctst2 - Count specific amount of coins

int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oItem=GetLocalObject(oPC,"oCMSItem");
    int nAmount=GetLocalInt(oItem,"nCoins");
    SetCustomToken(999993,IntToString(nAmount));
    return TRUE;
}
