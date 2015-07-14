///////////////////////////////////////////////////////////////////////
// npcact_cp_m_bh1 - NPC ACTIVITIES 6.0 Professions Merchant
// Has the wealth needed to purchase the item?
// By Deva Bryson Winblood.  07/11/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"

int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nCost=GetLocalInt(oPC,"nProfMerchPrice");
    int nCurrency=GetLocalInt(oMe,"nProfMerchCurrency");
    int nWealth=GetWealth(oPC,nCurrency);
    if (nWealth>=nCost) return TRUE;
    return FALSE;
}
