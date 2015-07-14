///////////////////////////////////////////////////////////////////////////////
// NPCACT_CNV_A# - NPC ACTIVITIES 6.0 Custom Conversation add-on
// By Deva Bryson Winblood.  09/03/2004
//---------------------------------------------------------------------------
// This is the actions portion of custom conversation for the NPCs speech.
//////////////////////////////////////////////////////////////////////////////
#include "npcact_h_cconv"
//////////////////////////
// CONSTANTS
//////////////////////////
const int CTEST_NUM=5;
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
   sS=GetLocalString(oMe,"sNPCConvResp"+IntToString(nDepth)+"_"+IntToString(nConsecutive)+"_"+IntToString(CTEST_NUM));
   fnConvDebug(oPC,"npcact_cnv_a1: [Depth="+IntToString(nDepth)+"  Consecutive="+IntToString(nConsecutive)+"]");
   fnConvDebug(oPC,"   parameter:"+sS);
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
     if (!(GetLocalInt(oPC,"nGNBConvDepth")!=nDepth||GetLocalInt(oPC,"nGNBConvConsec")!=nConsecutive))
     { // don't speak some more
       fnConvDebug(oPC,"   don't fire custom conversation again.");
       AssignCommand(oMe,ClearAllActions());
       AssignCommand(oMe,ActionStartConversation(oPC,"npcact_cust_end",FALSE,FALSE));
     } // don't speak some more
   } // found control variable
   fnConvDebug(oPC,"exit npcact_cnv_a1: [Depth="+IntToString(GetLocalInt(oPC,"nGNBConvDepth"))+"  Consecutive="+IntToString(GetLocalInt(oPC,"nGNBConvConsec"))+"]");
}
////////////////////////////////////////////////////////////////// MAIN

//////////////////////////
// FUNCTIONS
//////////////////////////
