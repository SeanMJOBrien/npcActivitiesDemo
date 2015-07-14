// npcact_cp_m_p1 - NPC ACTIVITIES 6.0 Custom Merchant Profession purchase 1
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sS;
    object oWP;
    sS=GetLocalString(oMe,"sProfMerchCatName1");
    if (GetStringLength(sS)>0) return FALSE;
    sS=GetLocalString(oMe,"sProfMerchClone_Categories");
    if (GetStringLength(sS)>0)
    { // categories clone specified
      oWP=GetWaypointByTag(sS);
      if (oWP!=OBJECT_INVALID)
      { // check for categories definition
        sS=GetLocalString(oWP,"sProfMerchCatName1");
        if (GetStringLength(sS)>0) return FALSE;
      } // check for categories definition
    } // categories clone specified
    return TRUE;
}
