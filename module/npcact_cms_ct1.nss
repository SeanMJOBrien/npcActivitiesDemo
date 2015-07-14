// npcact_cms_ct1 - Target selected with coins was self
#include "npcact_h_money"

int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oTarget=GetLocalObject(oPC,"oCMSTarget");
    object oItem=GetLocalObject(oPC,"oCMSItem");
    string sS;
    int nC=GetLocalInt(oItem,"nCurrency");
    if (oTarget==oPC)
    { // self target
      sS=GetWealthCarriedString(oPC,nC);
      SetCustomToken(999990,sS);
      return TRUE;
    } // self target
    return FALSE;
}
