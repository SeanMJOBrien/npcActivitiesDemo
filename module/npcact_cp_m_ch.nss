// npcact_cp_m_ch - NPC ACTIVITIES 6.0 Custom Merchant Profession can hire
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int bHireable;
    string sS;
    object oWP;
    bHireable=GetLocalInt(oMe,"bProfMerchHireable");
    if (bHireable) return TRUE;
    sS=GetLocalString(oMe,"sProfMerchClone_Other");
    if (GetStringLength(sS)>0)
    { // clone specified
      oWP=GetWaypointByTag(sS);
      if (oWP!=OBJECT_INVALID)
      { // check for definition
        bHireable=GetLocalInt(oWP,"bProfMerchHireable");
        if (bHireable) return TRUE;
      } // check for definition
    } // clone specified
    return FALSE;
}
