////////////////////////////////////////////////////////////////////////
// npcact_cp_m_bann - NPC ACTIVITIES 6.0 Profession Merchant
// Is this PC banned from speaking with this merchant?
// By Deva Bryson Winblood. 07/21/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"
int StartingConditional()
{
    object oMerchant=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nTime=GetBanTime();
    int nBan=GetMerchantBan(oMerchant,oPC);
    string sS;
    int nR;
    nR=d4();
    if (nR==1) sS="I have no interest in speaking to you!";
    else if (nR==2) sS="Go away!";
    else if (nR==3) sS="I already told you!  Go away!";
    else if (nR==4) sS="Go get what you need elsewhere! I am done with you!";
    SetCustomToken(99065,sS);
    if (nBan==-1) return TRUE;
    if (nBan>0)
    { // ban does or did exist
      if (nBan>nTime) return TRUE;
      else
      { // ban has expired
        SetMerchantBan(oMerchant,oPC,0);
      } // ban has expired
    } // ban does or did exist
    return FALSE;
}
