// npcact_cp_m_em - NPC ACTIVITIES 6.0 Custom Merchant Profession employer
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_prof"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sID=GetLocalString(oMe,"sProfMerchHiredBy");
    if (GetStringLength(sID)>0&&GetPCPlayerID(oPC)==sID) return TRUE;
    return FALSE;
}
