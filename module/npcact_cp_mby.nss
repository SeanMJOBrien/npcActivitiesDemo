// npcact_cp_mby - NPC ACTIVITIES 6.0 Custom Merchant Profession standard
// By Deva Bryson Winblood.  07/09/2005
#include "npcact_h_cconv"
#include "npcact_h_money"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sSays;
    int nCurrency=GetLocalInt(oMe,"nProfMerchCurrency");
    if (GetLocalInt(oMe,"nProfMerchConvMode")!=2) return FALSE;
    sSays=GetLocalString(oPC,"sProfMerchSays");
    SetCustomToken(99061,sSays);
    sSays=GetWealthCarriedString(oPC,nCurrency,TRUE);
    SetCustomToken(99062,sSays);
    return TRUE;
}
