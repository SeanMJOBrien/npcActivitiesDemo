// npcact_cp_m_pc1 - NPC ACTIVITIES 6.0 Custom Merchant Profession purchase cat1
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    int nNum=1;
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sS;
    object oWP;
    string sToken;
    sS=GetLocalString(oMe,"sProfMerchCatName"+IntToString(nNum));
    if (GetStringLength(sS)<1) return FALSE;
    sToken=sS;
    sS=GetLocalString(oMe,"sProfMerchClone_Categories");
    if (GetStringLength(sS)>0&&GetStringLength(sToken)<1)
    { // categories clone specified
      oWP=GetWaypointByTag(sS);
      if (oWP!=OBJECT_INVALID)
      { // check for categories definition
        sS=GetLocalString(oWP,"sProfMerchCatName"+IntToString(nNum));
        if (GetStringLength(sS)<1) return FALSE;
        sToken=sS;
      } // check for categories definition
    } // categories clone specified
    SetCustomToken(99060+nNum,sToken);
    return TRUE;
}
