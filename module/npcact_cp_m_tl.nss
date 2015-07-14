// npcact_cp_m_tl - NPC ACTIVITIES 6.0 Custom Merchant Profession Language test
// By Deva Bryson Winblood.  02/02/2005
#include "npcact_h_cconv"
int StartingConditional()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nLang=GetLocalInt(oMe,"nSpeakLanguage");
    string sS;
    string sSpeak="Greetings, how may I help you?";
    object oWP;
    if (nLang==0||GetLocalInt(oPC,"bNPCLanguage"+IntToString(nLang))==TRUE) return FALSE;
    // NPC is speaking a language that the PC does not understand.
    sS=GetLocalString(oMe,"sProfMerchClone_Other");
    if (GetStringLength(sS)>0)
    { // waypoint for cloning
      oWP=GetWaypointByTag(sS);
      if (oWP!=OBJECT_INVALID)
      { // check for greetings
        sS=GetLocalString(oWP,"sProfMerchGreetings");
        if (GetStringLength(sS)>0) sSpeak=sS;
      } // check for greetings
    } // waypoint for cloning
    sS=GetLocalString(oMe,"sProfMerchGreetings");
    if (GetStringLength(sS)>0) sSpeak=sS;
    sS=sSpeak;
    sSpeak=fnTranslateToLanguage(nLang,sSpeak);
    SetCustomToken(99060,sSpeak);
    return TRUE;
}
