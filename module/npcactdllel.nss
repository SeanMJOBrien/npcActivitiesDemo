/////////////////////////////////////////////////////////////////////////
// PEAK ACTIVITIES 6.1 - ARMOR LIBRARY
// Version: 1.0
// Library name: EL
//=======================================================================
// Author: PEAK
// Date  : 4/10/2009
//=======================================================================
// This library provides clothing functions as well as special event
// handlers.
//
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
#include "x2_inc_switches"
/* // #Parm1   FUNCTION                   PARAMETERS
//------------------------------------------------------------------------
// 1        If Nearby Object Exists    Object Tag, Branch if true
// 2        If Module Int compares to  Module Int Name, Comparison, #, branch
// 3        If Area Int compares to    Area Int Name, Comparison, #, branch
// 4        Set Module Int             Module Int Name, #
// 5        Set Area Int               Area Int Name, #
// 6        Branch to location         # of commands to skip
// 7        End of this waypoint       none
// 8        Create Event Watcher       Integer Name, number, script name
// 9        Delete Event Watcher       Integer Name, script name
*/
// #Parm1   FUNCTION                   PARAMETERS
//------------------------------------------------------------------------
// 1        Remove 1 layer             Target indiviual

/*
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
*/

void LIB1StripOne(); // use: #el/1 on WP

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
/*    switch(nFuncNum)
    { // switch
      case 1: { LIB1ObjectExists(sParm1,StringToInt(sParm2)); break; }
      default: break;
    } // switch */
    switch(nFuncNum)
    { // switch
      case 1: { LIB1StripOne(); break; }
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
  string sAct=GetLocalString(OBJECT_SELF,"sGNBActions");
  string sParse=fnParseSlash(sAct,".");
  int nC=0;
  while(nC<nBranch&&GetStringLength(sAct)>0)
  { // strip
    sAct=fnStringRemainder(sAct,sParse,".");
    nC++;
  } // strip
  SetLocalString(OBJECT_SELF,"sGNBActions",sAct);
} // fnBranch()

void fnEnd()
{ // and processing commands on this waypoint
  SetLocalString(OBJECT_SELF,"sGNBActions","");
} // fnEnd()

/*
void LIB1ObjectExists(string sObTag,int nBranch)
{ // If object exists
  object oGet=GetNearestObjectByTag(sObTag,OBJECT_SELF,1);
  if (oGet!=OBJECT_INVALID) fnBranch(nBranch);
} // LIB1ObjectExists()
*/

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

void LIB1StripOne()
  // Requires armor tags to have progressive suffixes of type ##
  // Last item removed has suffix 01: blue03 blue02 blue01
  // example blue01 is underwear, blue02 is tunic, blue03 is tunic & shoes
  // create armor in Custom Items, eg under NPC Clothing
{ // Remove 1 layer
  object oStripper = OBJECT_SELF;
  object oApparel = GetItemInSlot (INVENTORY_SLOT_CHEST, oStripper);
  object oNext;
  int nApparel = 0;
  int nNextTag;
  int nNext = 0;
  if (GetIsObjectValid (oApparel))
  {  nApparel = StringToInt (GetStringRight (GetTag (oApparel), 2));
//AssignCommand(oStripper, ActionSpeakString("nApparel "+IntToString(nApparel)));
     DelayCommand(20.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
     SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
     AssignCommand (oStripper, ActionUnequipItem (oApparel));
     oNext = GetFirstItemInInventory (oStripper);
     while (GetIsObjectValid (oNext))
     {  nNextTag = StringToInt (GetStringRight (GetTag (oNext), 2));
//AssignCommand(oStripper, ActionSpeakString("nNextTag "+IntToString(nNextTag)));
        if (nNextTag < nApparel)
           if (nNextTag > nNext)
           {  nNext = nNextTag;
//AssignCommand(oStripper, ActionSpeakString("nNext "+IntToString(nNext)));
              oApparel = oNext;
           }
        oNext = GetNextItemInInventory (oStripper);
     }
//AssignCommand(oStripper, ActionSpeakString("nApparelNew "+GetStringRight (GetTag (oApparel), 2)));
     if ( StringToInt (GetStringRight (GetTag (oApparel), 2)) != nApparel)
     {  float fWait = IntToFloat (10-nApparel);
        AssignCommand (oStripper, ActionEquipItem (oApparel, INVENTORY_SLOT_CHEST));
        AssignCommand (oStripper, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.4f, 4.0f));
        AssignCommand (oStripper, PlayVoiceChat (VOICE_CHAT_PAIN3));
        AssignCommand (oStripper, ActionWait (fWait * 2));
//        AssignCommand (oStripper, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 0.4f));
        AssignCommand (oStripper, ActionWait (4.0));
        DelayCommand(4.5+fWait*2,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
     } // ( StringToInt (GetStringRight (GetTag (oApparel), 2)) != nApparel)
  } // GetIsObjectValid (oApparel)
} // LIB1StripOne(oStripper)

/*    {   nApparel = StringToInt (GetStringRight (GetResRef use tag here (oApparel), 3)) -1;
        SetLocalInt (oPrisoner, "Apparel", nApparel);
        float fWait = IntToFloat ((10-nApparel));
        AssignCommand (oPrisoner, ActionUnequipItem (oApparel));
        oApparel = GetFirstItemInInventory (oPrisoner);
        while (StringToInt (GetStringRight (GetResRef (oApparel), 3)) != nApparel)
            oApparel = GetNextItemInInventory (oPrisoner);

        AssignCommand (oPrisoner, ActionEquipItem (oApparel, INVENTORY_SLOT_CHEST));
        AssignCommand (oPrisoner, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 0.4f, 4.0f));
        AssignCommand (oPrisoner, PlayVoiceChat (VOICE_CHAT_PAIN3));
        AssignCommand (oPrisoner, ActionWait (fWait * 2));
        AssignCommand (oPrisoner, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 0.4f));
    } // if (GetIsObjectValid (oApparel))
} // LIB1StripOne(oStripper)


/*
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


