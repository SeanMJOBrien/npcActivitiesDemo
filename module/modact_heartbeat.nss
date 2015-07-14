////////////////////////////////////////////////////////////////////////////////
// modact_heartbeat - Module Activities Heartbeat Event script
// Part of NPC ACTIVITIS 6.0.  - This script is required for timed events to
// function.
//==============================================================================
// By Deva Bryson Winblood.   06/22/2004
// LAST MODIFIED DATE: 06/22/2004   BY: Deva Bryson Winblood
////////////////////////////////////////////////////////////////////////////////
// MODULE ACTIVITIES VARIABLE
// sMODACT_HB# - Custom script to run in addition to this script
// bMODACT_NODEFAULTHB - If set to true will not run the default Heartbeat Script
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcactstackh"
///////////////////////
// PROTOTYPES
///////////////////////
void fnCheckForTimedEvents(int nHour,int nDay);


///////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMod=GetModule();
   int nLastHour=GetLocalInt(oMod,"nNPCACTMOD_Hour");
   int nLastDay=GetLocalInt(oMod,"nNPCACTMOD_Day");
   int nHour=GetTimeHour();
   int nDay=GetCalendarDay();
   int nC=1;
   string sScript;
   string sDefaultScript="";
   string sHeader="sMODACT_HB";
   string sNoDEFAULT="bMODACT_NODEFAULTHB";
   if (nLastHour==0&&nLastDay==0)
   { // initialize
     SetLocalInt(oMod,"nNPCACTMOD_Hour",nHour);
     SetLocalInt(oMod,"nNPCACTMOD_Day",nDay);
   } // initialize
   else
   { // already initialized
     if (nHour!=nLastHour)
     { // Check for timed events
       fnCheckForTimedEvents(nHour,nDay);
       SetLocalInt(oMod,"nNPCACTMOD_Hour",nHour);
       SetLocalInt(oMod,"nNPCACTMOD_Day",nDay);
     } // Check for timed events
   } // already initialized
   sScript=GetLocalString(oMod,sHeader+IntToString(nC));
   while(GetStringLength(sScript)>0)
   { // execute custom scripts
     ExecuteScript(sScript,oMod);
     nC++;
     sScript=GetLocalString(oMod,sHeader+IntToString(nC));
   } // execute custom scripts
   if (!GetLocalInt(oMod,sNoDEFAULT)&&GetStringLength(sDefaultScript)>1) ExecuteScript(sDefaultScript,oMod);
}
///////////////////////////////////////////////////////////////////// MAIN

////////////////////////
// FUNCTIONS
////////////////////////
void fnInterpret(string sEvent,string sBase)
{ // PURPOSE: To interpret an event and cause it to happen
  // LAST MODIFIED BY: Deva Bryson Winblood
  // LAST MODIFIED DATE: 06/22/2004
  object oMod=GetModule();
  object oOb=GetLocalObject(oMod,"o"+sBase);
  object oActor=oMod;
  string sL1=GetStringLeft(sEvent,1);
  string sL2=GetStringLeft(sEvent,2);
  string sMaster;
  string sParse;
  if (sL1=="#"||sL1=="&"||sL1=="^") oActor=oOb;
  if (sBase=="NA") oActor=oMod;
  if (GetIsObjectValid(oActor))
  { // valid actor
    if (sL2=="!n"||sL2=="&n")
    { // set integer
      sMaster=GetStringRight(sEvent,GetStringLength(sEvent)-2);
      sParse=fnParse(sMaster,"/");
      sMaster=fnRemoveParsed(sMaster,sParse,"/");
      SetLocalInt(oActor,sParse,StringToInt(sMaster));
    } // set integer
    else if (sL2=="!s"||sL2=="&s")
    { // set string
      sMaster=GetStringRight(sEvent,GetStringLength(sEvent)-2);
      sParse=fnParse(sMaster,"/");
      sMaster=fnRemoveParsed(sMaster,sParse,"/");
      SetLocalString(oActor,sParse,sMaster);
    } // set string
    else if (sL1=="@"||sL1=="#")
    { // custom script
      sMaster=GetStringRight(sEvent,GetStringLength(sEvent)-1);
      ExecuteScript(sMaster,oActor);
    } // custom script
    else if (sL1=="^")
    { // jump to location
      sMaster=GetStringRight(sEvent,GetStringLength(sEvent)-1);
      sParse=fnParse(sMaster,"/");
      sMaster=fnRemoveParsed(sMaster,sParse,"/");
      oActor=GetObjectByTag(sParse);
      if (GetIsObjectValid(oActor)&&GetObjectType(oActor)==OBJECT_TYPE_CREATURE)
      { // valid object
        oOb=GetWaypointByTag(sMaster);
        if (GetIsObjectValid(oOb))
        { // valid waypoint
          AssignCommand(oActor,JumpToObject(oOb));
        } // valid waypoint
      } // valid object
    } // jump to location
  } // valid actor
} // fnInterpret(sCur)

void fnCheckForWaypointEvents(int nHour,int nDay)
{ // PURPOSE: To look for NPCACT_EVENT<month>_<day>_<hour>_# waypoints
  // and handle those events as needed
  object oMod=GetModule();
  string sRegular="NPCACT_EVENT"+IntToString(GetCalendarMonth())+"_"+IntToString(nDay)+"_"+IntToString(nHour)+"_";
  string sEveryMonth="NPCACT_EVENTE"+"_"+IntToString(nDay)+"_"+IntToString(nHour)+"_";
  string sEveryDay="NPCACT_EVENTE_E_"+IntToString(nHour)+"_";
  string sEveryHour="NPCACT_EVENTE_E_E_";
  int nC;
  object oWP;
  string sEvent;
  // every hour first
  nC=1;
  oWP=GetWaypointByTag(sEveryHour+IntToString(nC));
  while(GetIsObjectValid(oWP))
  { // valid
    sEvent=GetName(oWP);
    DelayCommand(1.0,fnInterpret(sEvent,"NA"));
    nC++;
    oWP=GetWaypointByTag(sEveryHour+IntToString(nC));
  } // valid
  // every day
  nC=1;
  oWP=GetWaypointByTag(sEveryDay+IntToString(nC));
  while(GetIsObjectValid(oWP))
  { // valid
    sEvent=GetName(oWP);
    DelayCommand(2.0,fnInterpret(sEvent,"NA"));
    nC++;
    oWP=GetWaypointByTag(sEveryDay+IntToString(nC));
  } // valid
  // every month
  nC=1;
  oWP=GetWaypointByTag(sEveryMonth+IntToString(nC));
  while(GetIsObjectValid(oWP))
  { // valid
    sEvent=GetName(oWP);
    DelayCommand(3.0,fnInterpret(sEvent,"NA"));
    nC++;
    oWP=GetWaypointByTag(sEveryMonth+IntToString(nC));
  } // valid
  // base
  nC=1;
  oWP=GetWaypointByTag(sRegular+IntToString(nC));
  while(GetIsObjectValid(oWP))
  { // valid
    sEvent=GetName(oWP);
    DelayCommand(3.0,fnInterpret(sEvent,"NA"));
    nC++;
    oWP=GetWaypointByTag(sRegular+IntToString(nC));
  } // valid
} // fnCheckForWaypointEvents()

void fnCheckForTimedEvents(int nHour,int nDay)
{ // PURPOSE: To handle timed events created using NPC ACTIVITIES
  // LAST MODIFIED BY: Deva Bryson Winblood
  // LAST MODIFIED DATE: 06/22/2004
  object oMod=GetModule();
  string sBEID="TIMED"+IntToString(nDay)+"_"+IntToString(nHour)+"_";  // base numeric
  string sEEID="TIMEDE"+"_"+IntToString(nHour)+"_"; // every day
  string sEHEID="TIMEDE_E_"; // every day every hour
  int nC=1;
  int nN1;
  int nN2;
  string sT;
  string sCur;
  string sVal;
  object oOb;
  // Check everyday every hour events
  sCur=sEHEID+IntToString(nC);
  while(GetStringLength(GetLocalString(oMod,"s"+sCur))>0)
  { // every day every hour events
    sVal=GetLocalString(oMod,"s"+sCur);
    nN1=GetLocalInt(oMod,"n"+sCur);
    sT=GetLocalString(oMod,"st"+sCur);
    if (sT=="S"&&nN1==0) DelayCommand(2.0,fnInterpret(sVal,sCur));
    else if (StringToInt(sT)>nN1||sT=="I") DelayCommand(2.0,fnInterpret(sVal,sCur));
    nN1++;
    SetLocalInt(oMod,"n"+sCur,nN1);
    nC++;
    sCur=sEHEID+IntToString(nC);
  } // every day every hour events
  // Check for every day specific hour
  nC=1;
  sCur=sEEID+IntToString(nC);
  while(GetStringLength(GetLocalString(oMod,"s"+sCur))>0)
  { // every day every hour events
    sVal=GetLocalString(oMod,"s"+sCur);
    nN1=GetLocalInt(oMod,"n"+sCur);
    sT=GetLocalString(oMod,"st"+sCur);
    if (sT=="S"&&nN1==0) DelayCommand(3.0,fnInterpret(sVal,sCur));
    else if (StringToInt(sT)>nN1||sT=="I") DelayCommand(3.0,fnInterpret(sVal,sCur));
    nN1++;
    SetLocalInt(oMod,"n"+sCur,nN1);
    nC++;
    sCur=sEEID+IntToString(nC);
  } // every day every hour events
  // specific day and specific hour
  nC=1;
  sCur=sBEID+IntToString(nC);
  while(GetStringLength(GetLocalString(oMod,"s"+sCur))>0)
  { // every day every hour events
    sVal=GetLocalString(oMod,"s"+sCur);
    nN1=GetLocalInt(oMod,"n"+sCur);
    sT=GetLocalString(oMod,"st"+sCur);
    if (sT=="S"&&nN1==0) DelayCommand(4.0,fnInterpret(sVal,sCur));
    else if (StringToInt(sT)>nN1||sT=="I") DelayCommand(4.0,fnInterpret(sVal,sCur));
    nN1++;
    SetLocalInt(oMod,"n"+sCur,nN1);
    nC++;
    sCur=sBEID+IntToString(nC);
  } // every day every hour events
  // check for module defined waypoints----------------------------------------
  DelayCommand(6.0,fnCheckForWaypointEvents(nHour,nDay));
} // fnCheckForTimedEvents()

