// npcact_cms_ca1 - Set Mode for SPLIT
void main()
{
    object oPC=GetPCSpeaker();
    object oItem=GetLocalObject(oPC,"oCMSItem");
    int nCurr=GetLocalInt(oItem,"nCurrency");
    int nCoins=GetLocalInt(oItem,"nCoins");
    string sS;
    SetLocalInt(oPC,"nCMSMax",(nCoins-1)); // must leave at least one coin original stack
    sS="You have "+IntToString(nCoins)+" of those coins that can be split.";
    SetLocalString(oPC,"sCMSSelection",sS);
    DeleteLocalInt(oPC,"nCMSSelection");
    SetLocalInt(oPC,"nCMSMode",1);
}
