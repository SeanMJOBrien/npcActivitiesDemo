/////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - LOGIC LIBRARY
// Version: 1.0
// Library name: NL
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 10/11/2003
// LIB 10, 11, 12 added 5/10, 13 6/10 - Peak
// Last modified 6/18/10 Peak
//=======================================================================
// This library provides advanced logic functions as well as special event
// handlers.
//
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
#include "npcactivitiesh"
// #Parm1   FUNCTION                   PARAMETERS
//------------------------------------------------------------------------
// 1        If Nearby Object Exists    Object Tag, Branch if true
// 2        If Module Int compares to  Module Int Name, Comparison, #, branch opt.
// 3        If Area Int compares to    Area Int Name, Comparison, #, branch opt.
// 4        Set Module Int             Module Int Name, #
// 5        Set Area Int               Area Int Name, #
// 6        Branch to location         # of commands to skip
// 7        End of this waypoint       none
// 8        Create Event Watcher       Integer Name, number, script name
// 9        Delete Event Watcher       Integer Name, script name
// 10       Test sunrise, sunset       # of commands to skip
// 11       Delete local integer       Integer Name on NPC
// 12       Delete local string        String Name on NPC
// 13       Test Int on NPC            NPC Tag, Int Name, Comparison, #
//                                Note: skips next instruction on WP if TRUE
// This allows one NPC to react to an Int on another, e.g. what ProfState it has
// Example: 00.00.W.A.D.#NL/13/Boss/nProfState/G/3.#NL/7.*Harvest might have
// farm hand waiting until Boss is moving to work site before starting work.
///////////////////////////////// PROTOTYPES //////////////////////////////
void LIB1ObjectExists(string sObTag,int nBranch);
void LIB2ModuleIntCompare(string sInt,string sCompare,int nNum,int nBranch);
void LIB3AreaIntCompare(string sInt,string sCompare,int nNum,int nBranch);
void LIB4SetModuleInt(string sInt,int nNum);
void LIB5SetAreaInt(string sInt,int nNum);
void LIB6Branch(int nBranch);
void LIB7End();
void LIB8CreateEventWatcher(string sInt, int nNum,string sScript);
void LIB9DeleteEventWatcher(string sInt, string sScript);
void LIB10DawnDusk(int nBranch); // for milking, collecting eggs, worship - peak 5/10
void LIB11DeleteLocalInteger(string sNam); // PURPOSE: To delete local integer on NPC
void LIB12DeleteLocalString(string sNam); // PURPOSE: To delete local string on NPC
void LIB13TestIntOnNPC(string sNPCTag, string sInt, string sCompare, int nNum);

/////////////////////////////////////////////////////////////////// MAIN
void main()
{
  string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
  DeleteLocalString(OBJECT_SELF,"sLIBParm");
  fnTokenizeParameters(sParmIn);
  int nArgC=GetLocalInt(OBJECT_SELF,"nArgc");
  string sParm;
  int nFuncNum; // function number
  string sParm1;
  string sParm2;
  string sParm3;
  string sParm4;
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
      case 1: { LIB1ObjectExists(sParm1,StringToInt(sParm2)); break; }
      case 2: { LIB2ModuleIntCompare(sParm1,sParm2,StringToInt(sParm3),StringToInt(sParm4)); break; }
      case 3: { LIB3AreaIntCompare(sParm1,sParm2,StringToInt(sParm3),StringToInt(sParm4)); break; }
      case 4: { LIB4SetModuleInt(sParm1,StringToInt(sParm2)); break; }
      case 5: { LIB5SetAreaInt(sParm1,StringToInt(sParm2)); break; }
      case 6: { LIB6Branch(StringToInt(sParm1)); break; }
      case 7: { LIB7End(); break; }
      case 8: { LIB8CreateEventWatcher(sParm1,StringToInt(sParm2),sParm3); break; }
      case 9: { LIB9DeleteEventWatcher(sParm1,sParm2); break; }
      case 10: { LIB10DawnDusk(StringToInt(sParm1)); break; } // sunrise, sunset - peak 5/10 #NL/10/2.DoThis (Day/Night).#NL/7.ElseDoThis (atDawnDusk)
      case 11: { LIB11DeleteLocalInteger(sParm1); break; } //  peak 5/10 #NL/11/nRemoveThisIntegerVariable
      case 12: { LIB12DeleteLocalString(sParm1); break; } // peak 5/10 #NL/12/sRemoveThisStringVariable
      case 13: { LIB13TestIntOnNPC(sParm1,sParm2,sParm3,StringToInt(sParm4)); break; }
      default: break;
    } // switch
  } // arguments were passed
  fnFreeParms();
}
/////////////////////////////////////////////////////////////////// MAIN

////////////////////////////////////////////////////////////////////
//  LIBRARY SUPPORT FUNCTIONS
////////////////////////////////////////////////////////////////////
void fnBranch(int nBranch)
{ // branch nBranch # of commands
  string sAct=GetLocalString(OBJECT_SELF,"sAct");  // corPeak 5/10 was sGNBActions
  string sParse;  //corPeak
  int nC=0;
  while(nC<nBranch&&GetStringLength(sAct)>0)
  { // strip
    sParse=fnParseSlash(sAct,".");
    sAct=fnStringRemainder(sAct,sParse,".");
    nC++;
  } // strip
  SetLocalString(OBJECT_SELF,"sAct",sAct);  // corPeak 5/10 was sGNBActions
} // fnBranch()

void fnEnd()
{ // end processing commands on this waypoint
  SetLocalString(OBJECT_SELF,"sAct","");  // corPeak 5/10 was sGNBActions
} // fnEnd()

void LIB1ObjectExists(string sObTag,int nBranch)
{ // If object exists
  object oGet=GetNearestObjectByTag(sObTag,OBJECT_SELF,1);
  if (oGet!=OBJECT_INVALID) fnBranch(nBranch);
} // LIB1ObjectExists()

void fnCompare(object oOb,string sInt,string sCompare,int nNum,int nBranch)
{ // compare
  int bTrue=FALSE;
  if ((sCompare=="E"||sCompare=="EQ")&&GetLocalInt(oOb,sInt)==nNum) bTrue=TRUE;
  else if ((sCompare=="N"||sCompare=="NE")&&GetLocalInt(oOb,sInt)!=nNum) bTrue=TRUE;
  else if ((sCompare=="L"||sCompare=="LT")&&GetLocalInt(oOb,sInt)<nNum) bTrue=TRUE;
  else if ((sCompare=="G"||sCompare=="GT")&&GetLocalInt(oOb,sInt)>nNum) bTrue=TRUE;
  if (bTrue==TRUE)
  { // true
    if (nBranch!=0) fnBranch(nBranch);
  } // true
  else
  { // false
    if (nBranch==0) fnEnd();
  } // false
} // fnCompare()

void LIB2ModuleIntCompare(string sInt,string sCompare,int nNum,int nBranch)
{ // compare # on Module
  object oMod=GetModule();
  fnCompare(oMod,sInt,sCompare,nNum,nBranch);
} // LIB2ModuleIntCompare()

void LIB3AreaIntCompare(string sInt,string sCompare,int nNum,int nBranch)
{ // Compare # on Area
  object oArea=GetArea(OBJECT_SELF);
  fnCompare(oArea,sInt,sCompare,nNum,nBranch);
} // LIB3AreaIntCompare()

void LIB4SetModuleInt(string sInt,int nNum)
{ // Set Module Int
  object oMod=GetModule();
  SetLocalInt(oMod,sInt,nNum);
} // LIB4SetModuleInt()

void LIB5SetAreaInt(string sInt,int nNum)
{ // Set Area Int
  object oArea=GetArea(OBJECT_SELF);
  SetLocalInt(oArea,sInt,nNum);
} // LIB5SetAreaInt()

void LIB6Branch(int nBranch)
{ // skip nBranch # of commands
  fnBranch(nBranch);
} // LIB6Branch()

void LIB7End()
{ // end commands on this waypoint
  fnEnd();
} // LIB7End()

void fnEventWatcher(string sEvent,int nNum,string sInt,string sScript)
{ // watch for the event
  object oMod=GetModule();
  if (GetLocalInt(oMod,sInt)==nNum)
  { // event happened
    ExecuteScript(sScript,OBJECT_SELF);
    DeleteLocalInt(OBJECT_SELF,sEvent);
  } // event happened
  else if (GetLocalInt(OBJECT_SELF,sEvent)==TRUE)
  { // event not happened - event watcher still active
    DelayCommand(6.0,fnEventWatcher(sEvent,nNum,sInt,sScript));
  } // event not happened - event watcher still active
} // fnEventWatcher()

void LIB8CreateEventWatcher(string sInt, int nNum,string sScript)
{ // Create an event watcher
  string sEvent=sInt+sScript;
  if (GetLocalInt(OBJECT_SELF,sEvent)!=TRUE)
  { // create the EVENT
    SetLocalInt(OBJECT_SELF,sEvent,TRUE);
    fnEventWatcher(sEvent,nNum,sInt,sScript);
  } // create the EVENT
} // LIB8CreateEventWatcher()

void LIB9DeleteEventWatcher(string sInt, string sScript)
{ // Delete Event Watcher
  string sEvent=sInt+sScript;
  DeleteLocalInt(OBJECT_SELF,sEvent);
} // LIB9DeleteEventWatcher()

void LIB10DawnDusk(int nBranch)
{ //sunrise sunset
  int bHorizon=FALSE;
  if(GetIsDawn()||GetIsDusk())
    bHorizon=TRUE;
  fnDebug("NL LIB10: That it is in the gloaming is "+IntToString(bHorizon));
  if (bHorizon==TRUE) fnBranch(nBranch);
} //sunrise sunset

void LIB11DeleteLocalInteger(string sNam) { // PURPOSE: To delete local integer on NPC
  // LAST MODIFIED BY: peak (Peter D Busby) 5/10 #NL/11/sNam
  DeleteLocalInt(OBJECT_SELF,sNam);
} // LIB11DeleteLocalInteger

void LIB12DeleteLocalString(string sNam) { // PURPOSE: To delete local integer on NPC
  // LAST MODIFIED BY: peak (Peter D Busby) 5/10 #NL/12/sNam
  DeleteLocalString(OBJECT_SELF,sNam);
} // LIB12DeleteLocalString

void LIB13TestIntOnNPC(string sNPCTag, string sInt, string sCompare, int nNum)
{ // compare # on another NPC
  object oNPC=GetNearestObjectByTag(sNPCTag);
  if(oNPC==OBJECT_INVALID) oNPC=GetObjectByTag(sNPCTag);
  fnCompare(oNPC,sInt,sCompare,nNum,1);
} // LIB13TestIntOnNPC()

