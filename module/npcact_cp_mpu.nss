// npcact_cp_mpu - NPC ACTIVITIES 6.0 Custom Merchant Profession standard
// By Deva Bryson Winblood.  07/09/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sS=GetLocalString(oPC,"sMerchSay");
    if (GetLocalInt(oMe,"nProfMerchConvMode")!=3) return FALSE;
    SetCustomToken(99062,sS);
    return TRUE;
}
