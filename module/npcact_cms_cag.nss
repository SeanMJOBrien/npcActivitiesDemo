// npcact_cms_cag - Set Mode for Give
void main()
{
    object oPC=GetPCSpeaker();
    object oItem=GetLocalObject(oPC,"oCMSItem");
    int nCurr=GetLocalInt(oItem,"nCurrency");
    int nCoins=GetLocalInt(oItem,"nCoins");
    string sS;
    SetLocalInt(oPC,"nCMSMax",nCoins); // must leave at least one coin original stack
    sS="You have "+IntToString(nCoins)+" of those coins that you can give to "+GetName(GetLocalObject(oPC,"oCMSTarget"))+".";
    SetLocalString(oPC,"sCMSSelection",sS);
    DeleteLocalInt(oPC,"nCMSSelection");
    SetLocalInt(oPC,"nCMSMode",2);
}
