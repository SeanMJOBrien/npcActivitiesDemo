// npcact_cp_m_ni - NPC ACTIVITIES 6.0 Custom Merchant Profession standard
// By Deva Bryson Winblood.  07/09/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    if (GetLocalInt(oMe,"nProfMerchConvMode")!=1) return FALSE;
    return TRUE;
}
