// npcact_cp_m_srv - NPC ACTIVITIES 6.0 Custom Merchant Profession services
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sS;
    object oWP;
    sS=GetLocalString(oMe,"sProfMerchServiceName1");
    if (GetStringLength(sS)>0) return TRUE;
    sS=GetLocalString(oMe,"sProfMerchClone_Categories");
    if (GetStringLength(sS)>0)
    { // categories clone specified
      oWP=GetWaypointByTag(sS);
      if (oWP!=OBJECT_INVALID)
      { // check for categories definition
        return TRUE;
      } // check for categories definition
    } // categories clone specified
    return FALSE;
}
