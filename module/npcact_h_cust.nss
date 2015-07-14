////////////////////////////////////////////////////////////////////////////////
// NPCACT_H_CUST - NPC ACTIVITIES 6.0 Customization commands header
//------------------------------------------------------------------------------
// By Deva Bryson Winblood.   04/31/2004
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 6/22/2004
// comments & corrections: peak 5/10
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
////////////////////////////
// PROTOTYPES
////////////////////////////

// FILE: npcact_h_cust        FUNCTION: fnNPCACTAtScript()
// This function when passed an @<script> combination such as
// @cool_script will execute the script in question and pass
// any fDelay information from the script back to the main program
// The @cool_script would result in ExecuteScript("cool_script",OBJECT_SELF);
float fnNPCACTAtScript(string sCom);

// FILE: npcact_h_cust        FUNCTION: fnNPCACTLibCall()
// This function will make a call to npcactdll<lib> and pass
// parameters to it as sLIBParm
float fnNPCACTLibCall(string sCom);

// FILE: npcact_h_cust        FUNCTION: fnNPCACTProfCall()
// This function will make a call to npcact_p_<lib> and pass
// parameters to it as sArgV#  - upper case call valid Peak 5/10
float fnNPCACTProfCall(string sCom); //scripter's option available to pass some parameters - time limits, shift length etc

// FILE: npcact_h_cust        FUNCTION: fnNPCACTScriptSet()
// This function will set a custom script to a specific script
// See documentation for full description.
float fnNPCACTScriptSet(string sCom);

// FILE: npcact_h_cust        FUNCTION: fnNPCACTInsertTimedEvent()
// This function will insert an event on the module object that will
// cause the module object to execute a script at a certain time
// it will also pass the script a parameter stating who placed the
// even in the event queue.
float fnNPCACTInsertTimedEvent(string sCom);

// FILE: npcact_h_cust        FUNCTION: fnNPCACTSetBaseScripts()
// This function will set the base event scripts that this NPC
// uses simply by changing a single variable.
float fnNPCACTSetBaseScripts(string sCom);

////////////////////////////
// FUNCTIONS
////////////////////////////

float fnNPCACTSetBaseScripts(string sCom)
{ // PURPOSE: To set the base script sets used by this NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oMe=OBJECT_SELF;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-2);
  if (sS=="1")  SetLocalInt(oMe,"nWrap_Mode",3);     // Bioware Standard
  else if (sS=="2") SetLocalInt(oMe,"nWrap_Mode",4); // Bioware henchmen
  else if (sS=="3") SetLocalInt(oMe,"nWrap_Mode",1); // NPC Activities
  else if (sS=="4") SetLocalInt(oMe,"nWrap_Mode",1); // Professions
  return 0.0;
} // fnNPCACTSetBaseScripts()

float fnNPCACTInsertTimedEvent(string sCom)
{ // PURPOSE: To put a timed event on the module object
  // LAST MODIFIED BY: Deva Bryson Winblood
  // @@@expand for weekly, other intervals, festivals etc
  object oMe=OBJECT_SELF;
  object oMod=GetModule();
  int nDay=GetCalendarDay(); // can be # or E for every day or T for today
  int nHour=GetTimeHour();   // can be # or E for every hour or N for next hour
  int nN;
  int nL;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-1);
  string sDay=fnParse(sS,"/");
  string sHour;
  string sTimes; // can be S for single, # for number of times, or I for infinite
  string sEvent;
  string sEID;
  object oOb;
  sS=fnRemoveParsed(sS,sDay,"/");
  sHour=fnParse(sS,"/");
  sS=fnRemoveParsed(sS,sHour,"/");
  sTimes=fnParse(sS,"/");
  sEvent=fnRemoveParsed(sS,sTimes,"/");
  if (sDay=="T") sDay=IntToString(nDay);
  if (sHour=="N")
  {
    nHour++;
    if (nHour>23) nHour=0;
    sHour=IntToString(nHour);
  }
  sEID="TIMED"+sDay+"_"+sHour+"_";
  nN=1;
  while(GetLocalObject(oMod,"o"+sEID+IntToString(nN))!=OBJECT_INVALID&&nN!=-1)
  { // look for next slot
    oOb=GetLocalObject(oMod,"o"+sEID+IntToString(nN));
    if (oOb==oMe) nN=-1; // event already exists
    else
    { // keep looking
      nN++;
    } // keep looking
  } // look for next slot
  if (nN!=-1)
  { // set event
    SetLocalString(oMod,"s"+sEID+IntToString(nN),sEvent);
    SetLocalObject(oMod,"o"+sEID+IntToString(nN),oMe);
    SetLocalString(oMod,"st"+sEID+IntToString(nN),sTimes);
  } // set event
  return 0.0;
} // fnNPCACTInsertTimedEvent()

float fnNPCACTAtScript(string sCom)
{ // PURPOSE: Execute a custom script
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fDelay;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-1);
  fnDebug("["+GetTag(OBJECT_SELF)+"] ExecuteScript("+sS+")",TRUE);
  DeleteLocalFloat(OBJECT_SELF,"fDelay");
  ExecuteScript(sS,OBJECT_SELF);
  fDelay=GetLocalFloat(OBJECT_SELF,"fDelay");
  return fDelay;
} // fnNPCACTAtScript()

float fnNPCACTLibCall(string sCom)
{ // PURPOSE: Execute a call to an npcactdll<lib>
  // LAST MODIFIED BY: Deva Bryson Winblood
  // modified for upper-case call, e.g. #NL/7 - peak 5/10
  float fDelay;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-1);
  string sP;
  string sLib;
  int nC;
  DeleteLocalFloat(OBJECT_SELF,"fDelay");
  // determine library and parameters
  sP=fnParse(sS,"/");
  sS=fnRemoveParsed(sS,sP,"/");
  sLib="npcactdll"+GetStringLowerCase(sP);  //modPeak 5/10
  SetLocalString(OBJECT_SELF,"sLIBParm",sS);
  fnDebug("["+GetTag(OBJECT_SELF)+"] ExecuteScript("+sLib+")",TRUE);
  ExecuteScript(sLib,OBJECT_SELF);
  fDelay=GetLocalFloat(OBJECT_SELF,"fDelay");
  return fDelay;
} // fnNPCACTLibCall()

float fnNPCACTProfCall(string sCom)
{ // PURPOSE: Execute a call to an npcact_p_<prof>
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fDelay;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-1); //strip *
  string sP;
  string sLib;
  int nC;
  DeleteLocalFloat(OBJECT_SELF,"fDelay");
  // determine library and parameters
  sP=fnParse(sS,"/");
  sS=fnRemoveParsed(sS,sP,"/");
  sLib="npcact_p_"+GetStringLowerCase(sP); // to match variables Peak 5/10
  nC=1;
  while(GetStringLength(sS)>0)
  { // get parameters
    sP=fnParse(sS,"/");
    sS=fnRemoveParsed(sS,sP,"/");
    SetLocalString(OBJECT_SELF,"sArgV"+IntToString(nC),sP);
    SetLocalInt(OBJECT_SELF,"nArgC",nC);
    nC++;
  } // get parameters
  // make call to library
  ExecuteScript(sLib,OBJECT_SELF);
  fDelay=GetLocalFloat(OBJECT_SELF,"fDelay");
  if(fDelay==0.0) { fDelay=IntToFloat(GetLocalInt(OBJECT_SELF,"nGNBProfFail")); }
  return fDelay;
} // fnNPCACTProfCall()

float fnNPCACTScriptSet(string sCom)
{ // PURPOSE: to set one of the custom scripts to a specific script
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oMe=OBJECT_SELF;
  string sS=GetStringRight(sCom,GetStringLength(sCom)-1);
  string sTC=GetStringLeft(sCom,1);
  sS=GetStringRight(sS,GetStringLength(sS)-1);
  if (sTC=="1")
  { //
    SetLocalString(oMe,"sCRSPBlocked",sS);
  } //
  else if (sTC=="2")
  { //
    SetLocalString(oMe,"sCRSPCRE",sS);
  } //
  else if (sTC=="3")
  { //
    SetLocalString(oMe,"sCRSPConversation",sS);
  } //
  else if (sTC=="4")
  { //
    SetLocalString(oMe,"sCRSPDamaged",sS);
  } //
  else if (sTC=="5")
  { //
    SetLocalString(oMe,"sCRSPDeath",sS);
  } //
  else if (sTC=="6")
  { //
    SetLocalString(oMe,"sCRSPDisturbed",sS);
  } //
  else if (sTC=="7")
  { //
    SetLocalString(oMe,"sCRSPHB",sS);
  } //
  else if (sTC=="8")
  { //
    SetLocalString(oMe,"sCRSPPerception",sS);
  } //
  else if (sTC=="9")
  { //
    SetLocalString(oMe,"sCRSPPA",sS);
  } //
  else if (sTC=="A")
  { //
    SetLocalString(oMe,"sCRSPRested",sS);
  } //
  else if (sTC=="B")
  { //
    SetLocalString(oMe,"sCRSPSpawn",sS);
  } //
  else if (sTC=="C")
  { //
    SetLocalString(oMe,"sCRSPSCA",sS);
  } //
  else if (sTC=="D")
  { //
    SetLocalString(oMe,"sCRSPUser",sS);
  } //
  else if (sTC=="E")
  { //
    SetLocalString(oMe,"sCRSPConvN",sS);
  } //
  else if (sTC=="F")
  { //
    SetLocalString(oMe,"sCRSPConvA",sS);
  } //
  return 0.0;
} // fnNPCACTScriptSet()

//void main(){} //comment out after compile
