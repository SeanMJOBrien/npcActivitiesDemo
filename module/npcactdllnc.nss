/////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - AI CONTROL LIBRARY
// Version: 1.0
// Library name: NC
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 10/11/2003
// Modified: added #NC/6 6/18/10 - Peak
//=======================================================================
// This library provides access to the SetAILevel() commands
// #NC/6/<sNewTag>/<sOldTag==""> sets Virtual Tag on calling NPC, or optionally
//   on another NPC, and resets its npcact_state to 0 (go to POST/NIGHT)
//   #NC/6 with no parameters resets NPC to original tag - Peak 6/18/10
//
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
// #Parm1   FUNCTION                   PARAMETERS
//    6   Virtual Tag   <sNewTag> - sets sGNBVirtualTag on NPC, State=0 (sends to POST/NIGHT_<VT>
//    6   Virtual Tag   <sNewTag>/<OldTag> - sets VT on NPC tagged OldTag
// This allows WP for one NPC to control VT on another - to summon help, etc
//    6   Virtual Tag   no parameters, deletes sGNBVirtualTag
//    6   Virtual Tag   //<OldTag> deletes sGNBVirtualTag on NPC tagged OldTag
//------------------------------------------------------------------------


///////////////////////////////// PROTOTYPES //////////////////////////////
void fnSetVirtualTag(string sNewTag="", string sOldTag="");
/////////////////////////////////////////////////////////////////// MAIN
void main()
{
  string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
  DeleteLocalString(OBJECT_SELF,"sLIBParm");
  fnTokenizeParameters(sParmIn);
  int nArgC=GetLocalInt(OBJECT_SELF,"nArgc");
  string sParm, sParm1, sParm2, sParm3, sParm4;
  int nFuncNum; // function number
  if (nArgC>0)
  { // arguments were passed
    sParm=GetLocalString(OBJECT_SELF,"sArgv1");
    nFuncNum=StringToInt(sParm);
    if (nArgC>1) sParm1=GetLocalString(OBJECT_SELF,"sArgv2");
    if (nArgC>2) sParm2=GetLocalString(OBJECT_SELF,"sArgv3");
    if (nArgC>3) sParm3=GetLocalString(OBJECT_SELF,"sArgv4");
    if (nArgC>4) sParm4=GetLocalString(OBJECT_SELF,"sArgv5");
    switch(nFuncNum)
    { // switch
      case 1: { SetAILevel(OBJECT_SELF,AI_LEVEL_DEFAULT); break; }
      case 2: { SetAILevel(OBJECT_SELF,AI_LEVEL_VERY_LOW); break; }
      case 3: { SetAILevel(OBJECT_SELF,AI_LEVEL_LOW); break; }
      case 4: { SetAILevel(OBJECT_SELF,AI_LEVEL_NORMAL); break; }
      case 5: { SetAILevel(OBJECT_SELF,AI_LEVEL_HIGH); break; }
      case 6: { fnSetVirtualTag(sParm1,sParm2); break; }
      default: { SetAILevel(OBJECT_SELF,AI_LEVEL_DEFAULT); break; }
    } // switch
  } // arguments were passed
  fnFreeParms();
}
/////////////////////////////////////////////////////////////////// MAIN
void fnSetVirtualTag(string sNewTag="", string sOldTag="")
{
  object oNPC=OBJECT_SELF;
  if(sOldTag!="") oNPC=GetNearestObjectByTag(sOldTag);
  SetLocalString(oNPC,"sGNBVirtualTag",sNewTag);
  SetLocalInt(oNPC,"nGNBState",0);
}
////////////////////////////////////////////////////////////////////
//  LIBRARY SUPPORT FUNCTIONS
////////////////////////////////////////////////////////////////////
