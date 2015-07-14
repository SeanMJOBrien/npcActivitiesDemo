////////////////////////////////////////////////////////////////////////////////
// NPCACTIVITIESH - This is the header file containing the main movement routines
// as well as the parser functions.
//------------------------------------------------------------------------------
// By Deva Bryson Winblood.  04/27/2004
// Last Modified By: Peak 6/06/10
// Modified for iteration counter debugging by: Peak (Peter D. Busby) 05/21/10
////////////////////////////////////////////////////////////////////////////////
// Individual functions will have notes on who last modified them and a date.
const int DEBUG_NPCACT_ON = FALSE; // set this to false when not debugging
const int DEEP_DEBUG_ON = FALSE; // set this if you need even more verbose debugging
const int DEBUG_INTEGER = FALSE; // set this to debug iteration counters
const int DEBUG_NPCACT_SAME_AREA = FALSE; // set to TRUE if only want messages from same area
const int NPCACT_MAX_SCAN = 20;  // Number of objects to test before stopping
                                 // This helps prevent TOO MANY INSTRUCTION errors
const string DEBUG_TAG = "mWife";     // Set this to a specific NPC if you want only
                                  // messages reguarding a single NPC
const int DEBUG_NPCACT_SILENT = TRUE; // set this to FALSE to send messages, default to log.
const int NPCACT_CUSTOMTRAPS = 0; // Set this to the # of custom traps available
const int DEBUG_NPCCONV_ON = FALSE; // Set this to TRUE if you want it to debug custom conversation
const string NPCACT_VERSION = "6.2"; // This is the current version of NPC ACTIVITIES

////////////////////////
// PROTOTYPES
////////////////////////

// FILE: npcactivitiesh   FUNCTION: fnGetIsBusy()
//-----------------------------------------------
// This function will return TRUE if the NPC is in combat or someone they have
// recently been attacked by is nearby.  It will also return TRUE if they are
// in a conversation.  This function will be used to prevent scripts from doing
// actions that would interfere with combat and/or conversation situations.
int fnGetIsBusy(object oNPC);

// FILE: npcactivitiesh    FUNCTION: fnParse()
//--------------------------------------------
// This function will examine a string and will return the portion that
// occurs before the first sDelimiter it encounters.  This function should
// likely be used in conjunction with fnRemoveParsed().
string fnParse(string sSource,string sDelimiter=".");

// FILE: npcactivitiesh    FUNCTION: fnRemoveParsed()
//---------------------------------------------------
// This function will remove the size of string sRemove from the beginning
// of the string sSource.  If the first character remaining is sDelimiter then
// it will also remove that.  This function is generally used in conjunction
// with fnParse() to provide the remainder of an unparsed string.
string fnRemoveParsed(string sSource,string sRemove,string sDelimiter=".");

// FILE: npcactivitiesh    FUNCTION: fnDebug()
//--------------------------------------------
// This function will provide debugging information and can target a
// specific NPC or AREA.  It can be setup to only display debug information
// to a log file, or to send it to the PC returned by GetFirstPC().  It will
// always debug to a log file but, it can be setup to do both.
// if bDeep=TRUE then it will treat this as a DEEP DEBUG message and will
// not display it unless DEEP_DEBUG_ON constant is set to true in the
// npcactivitiesh file. If sMsg="" then it will return a dump of the
// current NPCs state, destination, actions, etc. at the time.
// For non-scripters: setting module variable sModuleDebugTag to tag of NPC
//  will send deep debugging to nwclientLog1.txt in NWN log directory.
void fnDebug(string sMsg,int bDeep=FALSE);

// FILE: npcactivitiesh    FUNCTION: fnDebugInt()
//--------------------------------------------
// This function will provide debugging information on integers such as
// iteration counters, and can be set for a specific NPC or AREA.  It can be
// setup to display debug information to the PC returned by GetFirstPC()
// as well as to the log file, as above. Also responds to sModuleDebugTag.
void fnDebugInt(string sMsg,int nTarget,int bDisplay=FALSE);

// FILE:npcactivitiesh    FUNCTION: fnGetNPCTag()
// This function was provided to replace GetTag for the NPC.  It will check
// to see if sGNBVirtualTag is defined.  If a virtual tag is defined it will
// return that.   Otherwise, it will return the results of GetTag.   This
// provides the ability to override the NPCs actual tag at any point and make
// them use a virtual tag of your choice which can be changed at any time.
string fnGetNPCTag(object oNPC);


#include "npcact_h_moving"
// #include "x3_inc_string" used for StringParse and StringRemoveParsed
////////////////////////
// FUNCTIONS
////////////////////////

int fnGetIsBusy(object oNPC) // returns T/F
{ // PURPOSE: Returns TRUE if the NPC is in combat, conversation, or attacker nearby
  // LAST MODIFIED BY: Deva Bryson Winblood   04/27/2004
  object oAttacker=GetLastAttacker(oNPC);
  object oEnemy=GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oNPC,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
  if (GetIsDMPossessed(oNPC)) return TRUE;
  if (GetIsObjectValid(oEnemy)) fnDebug("I detect an enemy nearby",TRUE);
  if (GetIsInCombat(oNPC)==TRUE) return TRUE;
  else if (IsInConversation(oNPC)==TRUE) return TRUE;
  else if (oAttacker!=OBJECT_INVALID&&GetObjectSeen(oAttacker,oNPC)==TRUE&&GetIsEnemy(oAttacker,oNPC)==TRUE&&GetIsDead(oAttacker)==FALSE) return TRUE;
  else if (oEnemy!=OBJECT_INVALID&&GetLocalInt(oNPC,"bGNBNoPerceiveEnemy")!=TRUE) return TRUE;
 return FALSE;
} // fnGetIsBusy()

/////////////////////////////////////////////////////////////// BEGIN PARSER
string fnParse(string sSource,string sDelimiter=".")
{ // PURPOSE: To strip the portion of the string occuring before the delimiter
  // LAST MODIFIED BY: Deva Bryson Winblood   04/29/2004
  // Note: 1.69 has similar ScriptParse(), default delimiter " ", can also parse from end.
  string sRet="";
  int nPos=0;
  string sS=GetSubString(sSource,nPos,1);
  while(nPos<GetStringLength(sSource)&&sS!=sDelimiter)
  { // build return string
    sRet=sRet+sS;
    nPos++;
    sS=GetSubString(sSource,nPos,1);
  } // build return string
  return sRet;
} // fnParse()

string fnRemoveParsed(string sSource,string sRemove,string sDelimiter=".")
{ // PURPOSE: To remove a previously parsed string from source string
  // LAST MODIFIED BY: Deva Bryson Winblood   04/29/2004
  // Note: 1.69 has StringRemoveParsed(), as above.
  string sRet="";
  int nSL=GetStringLength(sSource);
  int nRL=GetStringLength(sRemove);
  if (nSL>=nRL)
  { // valid lengths
    sRet=GetStringRight(sSource,(nSL-nRL));
    if (GetStringLeft(sRet,1)==sDelimiter) sRet=GetStringRight(sRet,GetStringLength(sRet)-1);
  } // valid lengths
  return sRet;
} // fnRemoveParsed()
/////////////////////////////////////////////////////////////// END PARSER

/////////////////////////////////////////////////////////////// BEGIN DEBUG
void fnDebug(string sMsg,int bDeep=FALSE)
{ // PURPOSE: To output debug messages adhering to debug constants set in this file
  // LAST MODIFIED BY: Deva Bryson Winblood  04/29/2004
  // modified: module variable sModuleDebugTag set to NPC tag will generate
  //  deep debugs to log: leave DEBUG_NPCACT_SILENT==TRUE on debugged scripts so
  //  non-scripters have a way to generate debug logs  - Peak 6/06/10
  //SendMessageToPC(GetFirstPC(),"[DEBUG]");
  string sModuleDebugTag=GetLocalString(GetModule(),"sModuleDebugTag"); // set module variable to tag of NPC to generate deep debug log
  if (DEBUG_NPCACT_ON==FALSE&&sModuleDebugTag=="") return;
  if (bDeep==TRUE&&DEEP_DEBUG_ON==FALSE&&sModuleDebugTag=="") return;
  object oMe=OBJECT_SELF;
  if (DEBUG_NPCACT_SAME_AREA&&GetArea(oMe)!=GetArea(GetFirstPC())) return;
  if (GetTag(oMe)!=DEBUG_TAG&&GetTag(oMe)!=sModuleDebugTag) return;
  string sOutput="["+GetName(oMe)+" TAG:"+GetTag(oMe)+"](Area:"+GetName(GetArea(oMe))+")";
  if (GetStringLength(sMsg)>1) sOutput=sOutput+sMsg;
  else
  { // dump
    sOutput=sOutput+"STATE:"+IntToString(GetLocalInt(oMe,"nGNBState"))+" StateSpeed:";
    sOutput=sOutput+IntToString(GetLocalInt(oMe,"nGNBStateSpeed"))+" Dest:";
    object oDest=GetLocalObject(oMe,"oDest");
    if (oDest==OBJECT_INVALID) sOutput=sOutput+"NA";
    else { sOutput=sOutput+GetTag(oDest)+"in area '"+GetName(GetArea(oDest))+"'";   }
    sOutput=sOutput+" sAct="+GetLocalString(oMe,"sAct");
  } // dump
  PrintString("NPC ACTIVITIES:==> "+sOutput);
  if (DEBUG_NPCACT_SILENT!=TRUE) SendMessageToPC(GetFirstPC(),sOutput);
} // fnDebug()
/////////////////////////////////////////////////////////////// END DEBUG

/////////////////////////////////////////////////////////////// BEGIN DEBUG INT
void fnDebugInt(string sMsg,int nTarget,int bDeep=FALSE)
{ // PURPOSE: To output debug messages re integers adhering to the debug constant set in this file
  // LAST MODIFIED BY: Peak (Peter D. Busby) 05/21/10 sModuleDebugTag 6/06/10
  //SendMessageToPC(GetFirstPC(),"[DEBUG_INTEGER]");
  string sModuleDebugTag=GetLocalString(GetModule(),"sModuleDebugTag"); // set module variable to tag of NPC to generate deep debug log
  if (DEBUG_INTEGER==FALSE&&sModuleDebugTag=="") return;
  if ((bDeep==TRUE&&DEEP_DEBUG_ON==FALSE)&&sModuleDebugTag=="") return;
  object oMe=OBJECT_SELF;
  if (DEBUG_NPCACT_SAME_AREA&&GetArea(oMe)!=GetArea(GetFirstPC())) return;
  if (GetTag(oMe)!=DEBUG_TAG&&GetTag(oMe)!=sModuleDebugTag) return;
  string sOutput="["+GetName(oMe)+" TAG:"+GetTag(oMe)+"](Area:"+GetName(GetArea(oMe))+") "+sMsg+": "+IntToString(nTarget);
  PrintString("NPC ACTIVITIES:==> "+sOutput);
  if (DEBUG_NPCACT_SILENT!=TRUE) SendMessageToPC(GetFirstPC(),sOutput);
} // fnDebugInt()
/////////////////////////////////////////////////////////////// END DEBUG INT

///////////////////////////////////////////////////////////// BEGIN VIRTUAL TAG
string fnGetNPCTag(object oNPC)
{ // PURPOSE: To provide the tag NPC ACTIVITIES should use and supporting
  // the sGNBVirtualTag override variable - see also #NC/6
  string sRet=GetTag(oNPC);
  string sVirtual=GetLocalString(oNPC,"sGNBVirtualTag");
  if (GetStringLength(sVirtual)>0) sRet=sVirtual;
  return sRet;
} // fnGetNPCTag()
///////////////////////////////////////////////////////////// END VIRTUAL TAG

/////////////////////////////////////////////////////////////// BEGIN MOVEMENT

/////////////////////////////////////////////////////////////////// END MOVEMENT

//////////////////////////
// VERSION HISTORY NOTES
//////////////////////////
// 6.2 Beta: Peak's public release with Professions and Pathways 7/04/10
// 6.1 Deva Bryson Winblood's public NPC Activities release
// 6.0 Beta 13 Patch 1 - Fixes to npcact_h_moving compliments of Lissa.
//       Support for DM POSSESSION to prevent NPC ACTIVITIES from interfering
//       with possessed creatures.  Added oGNBArrived variable to store info
//       about the destination when it is reached.  This was needed by some
//       people who use this script.
// 6.0 -> Beta 13 - Previous public releases

//void main(){} // after compiling, comment out & resave
