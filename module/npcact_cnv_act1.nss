///////////////////////////////////////////////////////////////////////////////
// NPCACT_CNV_ACT# - NPC ACTIVITIES 6.0 Custom Conversation add-on
// By Deva Bryson Winblood.  09/03/2004
//---------------------------------------------------------------------------
// This is the actions portion of custom conversation for the NPCs speech.
//////////////////////////////////////////////////////////////////////////////
#include "npcact_h_cconv"
//////////////////////////
// CONSTANTS
//////////////////////////
const int CTEST_NUM=1;
//////////////////////////
// PROTOTYPES
//////////////////////////


////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oPC=GetPCSpeaker();
   object oMe=OBJECT_SELF;
   string sS;
   string sTest;
   string sAct;
   string sLang;
   int nDepth; // depth within conversation tree
   int nConsecutive; // consecutives
   //////////////////
   nDepth=GetLocalInt(oPC,"nGNBConvDepth");
   nConsecutive=GetLocalInt(oPC,"nGNBConvConsec");
   sS=GetLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nConsecutive));
   if (GetStringLength(sS)>0)
   { // found control variable
     sLang=fnParse(sS);
     sS=fnRemoveParsed(sS,sLang);
     sTest=fnParse(sS);
     sS=fnRemoveParsed(sS,sTest);
     sAct=fnParse(sS);
     if (GetStringLength(sAct)>0&&sAct!="NA"&&sAct!="na"&&sAct!="0")
     { // process actions
       fnConvActions(oMe,oPC,sAct);
     } // process actions
   } // found control variable
}
////////////////////////////////////////////////////////////////// MAIN

//////////////////////////
// FUNCTIONS
//////////////////////////
