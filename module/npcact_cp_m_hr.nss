// npcact_cp_m_hr - NPC ACTIVITIES 6.0 Custom Merchant Profession can hire rate
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
#include "npcact_h_money"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nN;
    string sS;
    object oWP;
    int nCurrency=GetLocalInt(oMe,"nCurrency");
    sS=GetLocalString(oMe,"sProfMerchHiredBy");
    if (GetStringLength(sS)>0) return FALSE;

    return TRUE;
}
