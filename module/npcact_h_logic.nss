////////////////////////////////////////////////////////////////////////////////
// npcact_h_logic - NPC ACTIVITIES 6.0 Logic Functions
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 06/16/2004
// modified for Virtual Tags 5/10, Gloaming 6/10 Peak
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
/////////////////////////////
// PROTOTYPES
/////////////////////////////

// FILE: npcact_h_logic           FUNCTION: fnNPCACTLogicCore()
// This is the control function for ALL NPC ACTIVIIES 6.0 logic
// tests.  It will call the other functions in this header file.
float fnNPCACTLogicCore(string sCom);

/////////////////////////////
// FUNCTIONS
/////////////////////////////


///////////////////// INTERNAL HEADER FILE USED FUNCTIONS /////////////////////
void NPCACTAbortCommands()
{ // PURPOSE: To trigger the end of commands for this waypoint if a logic check returns FALSE
  // LAST MODIFIED BY: Deva Bryson Winblood
  fnDebug("  NPCACTAbortCommands()",TRUE);
  DeleteLocalString(OBJECT_SELF,"sAct");
} // NPCACTAbortCommands()

void fnLOGICHasRelated(string sCmd,string sP)
{ // PURPOSE: To handle has and has not item situations
  // LAST MODIFIED BY: Deva Bryson Winblood
  int bHas=FALSE;
  int bDesired=FALSE;
  object oItem=GetItemPossessedBy(OBJECT_SELF,sP);
  if (sCmd=="T") bDesired=TRUE;
  if (GetIsObjectValid(oItem)) bHas=TRUE;
  if (bDesired!=bHas)  NPCACTAbortCommands();
} // fnLOGICHasRelated()

void fnLOGICInteger(string sCmd,string sP)
{ // PURPOSE: To handle integer related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm1=fnParse(sP,"/");
  string sParm2=fnRemoveParsed(sP,sParm1,"/");
  int bResults=FALSE;
  if (sCmd=="E"&&GetLocalInt(OBJECT_SELF,sParm1)==StringToInt(sParm2)) bResults=TRUE;
  else if (sCmd=="e"&&GetLocalInt(OBJECT_SELF,sParm1)==GetLocalInt(OBJECT_SELF,sParm2)) bResults=TRUE;
  else if (sCmd=="G"&&GetLocalInt(OBJECT_SELF,sParm1)>StringToInt(sParm2)) bResults=TRUE;
  else if (sCmd=="g"&&GetLocalInt(OBJECT_SELF,sParm1)>GetLocalInt(OBJECT_SELF,sParm2)) bResults=TRUE;
  else if (sCmd=="L"&&GetLocalInt(OBJECT_SELF,sParm1)<StringToInt(sParm2)) bResults=TRUE;
  else if (sCmd=="l"&&GetLocalInt(OBJECT_SELF,sParm1)<GetLocalInt(OBJECT_SELF,sParm2)) bResults=TRUE;
  else if (sCmd=="n"&&GetLocalInt(OBJECT_SELF,sParm1)!=GetLocalInt(OBJECT_SELF,sParm2)) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICInteger()

void fnLOGICString(string sCmd,string sP)
{ // PURPOSE: To handle string related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm1=fnParse(sP,"/");
  string sParm2=fnRemoveParsed(sP,sParm1,"/");
  int bResults=FALSE;
  if (sCmd=="E"&&GetLocalString(OBJECT_SELF,sParm1)==sParm2) bResults=TRUE;
  else if (sCmd=="e"&&GetLocalString(OBJECT_SELF,sParm1)==GetLocalString(OBJECT_SELF,sParm2)) bResults=TRUE;
  else if (sCmd=="N"&&GetLocalString(OBJECT_SELF,sParm1)!=sParm2) bResults=TRUE;
  else if (sCmd=="n"&&GetLocalString(OBJECT_SELF,sParm1)!=GetLocalString(OBJECT_SELF,sParm2)) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICString()

void fnLOGICWeather(string sP)
{ // PURPOSE: To handle weather related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  int bResults=FALSE;
  if ((sP=="C"||sP=="c")&&GetWeather(GetArea(OBJECT_SELF))==WEATHER_CLEAR) bResults=TRUE;
  else if ((sP=="R"||sP=="r")&&GetWeather(GetArea(OBJECT_SELF))==WEATHER_RAIN) bResults=TRUE;
  else if ((sP=="S"||sP=="s")&&GetWeather(GetArea(OBJECT_SELF))==WEATHER_SNOW) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICWeather()

void fnLOGICAlignment(string sP)
{ // PURPOSE: To handle alignment related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nAGE=GetAlignmentGoodEvil(OBJECT_SELF);
  int nALC=GetAlignmentLawChaos(OBJECT_SELF);
  int bResults=FALSE;
  if (sP=="LAW"&&nALC==ALIGNMENT_LAWFUL) bResults=TRUE;
  else if (sP=="CHA"&&nALC==ALIGNMENT_CHAOTIC) bResults=TRUE;
  else if (sP=="GOO"&&nAGE==ALIGNMENT_GOOD) bResults=TRUE;
  else if (sP=="EVI"&&nAGE==ALIGNMENT_EVIL) bResults=TRUE;
  else if (sP=="LG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_LAWFUL) bResults=TRUE;
  else if (sP=="NG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_NEUTRAL) bResults=TRUE;
  else if (sP=="CG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_CHAOTIC) bResults=TRUE;
  else if (sP=="LN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_LAWFUL) bResults=TRUE;
  else if (sP=="TN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_NEUTRAL) bResults=TRUE;
  else if (sP=="CN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_CHAOTIC) bResults=TRUE;
  else if (sP=="LE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_LAWFUL) bResults=TRUE;
  else if (sP=="NE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_NEUTRAL) bResults=TRUE;
  else if (sP=="CE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_CHAOTIC) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICAlignment()

void fnLOGICAppearance(string sP)
{ // PURPOSE: To handle appearance related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nNum=GetAppearanceType(OBJECT_SELF);
  if (nNum!=StringToInt(sP)) NPCACTAbortCommands();
} // fnLOGICAppearance()

void fnLOGICResRef(string sP)
{ // PURPOSE: To handle resref related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  if (GetResRef(OBJECT_SELF)!=sP) NPCACTAbortCommands();
} // fnLOGICResRef()

void fnLOGICSpecificTag(string sP)
{ // PURPOSE: To handle a specific tagged NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  if (fnGetNPCTag(OBJECT_SELF)!=sP) NPCACTAbortCommands();   //modified for Virtual Tags peak 5/10
} // fnLOGICSpecificTag()

void fnLOGICTime(string sP)
{ // PURPOSE: To handle time related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  // added Gloaming 6/16/10 Peak
  int bResults=FALSE;
  sP=GetStringUpperCase(sP);
  if (sP=="D"&&GetIsDay()==TRUE) bResults=TRUE;
  else if (sP=="N"&&GetIsNight()==TRUE) bResults=TRUE;
  else if (sP=="U"&&GetIsDusk()==TRUE) bResults=TRUE;
  else if (sP=="W"&&GetIsDawn()==TRUE) bResults=TRUE;
  else if (sP=="G"&&(GetIsDawn()==TRUE||GetIsDusk()==TRUE)) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICTime()

void fnLOGICRaceGender(string sCmd,string sP)
{ // PURPOSE: To handle Race/Gender related logic
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nGender=GetGender(OBJECT_SELF);
  int nRace=GetRacialType(OBJECT_SELF);
  int bResults=FALSE;
  if (sCmd=="D"&&nRace==RACIAL_TYPE_DWARF) bResults=TRUE;
  else if (sCmd=="e"&&nRace==RACIAL_TYPE_HALFELF) bResults=TRUE;
  else if (sCmd=="E"&&nRace==RACIAL_TYPE_ELF) bResults=TRUE;
  else if (sCmd=="f"&&nGender==GENDER_FEMALE) bResults=TRUE;
  else if (sCmd=="G"&&nRace==RACIAL_TYPE_GNOME) bResults=TRUE;
  else if (sCmd=="h"&&nRace==RACIAL_TYPE_HALFLING) bResults=TRUE;
  else if (sCmd=="H"&&nRace==RACIAL_TYPE_HUMAN) bResults=TRUE;
  else if (sCmd=="m"&&nRace==GENDER_MALE) bResults=TRUE;
  else if (sCmd=="O"&&nRace==RACIAL_TYPE_HALFORC) bResults=TRUE;
  else if (sCmd=="C"&&nRace==RACIAL_TYPE_CONSTRUCT) bResults=TRUE;
  else if (sCmd=="o"&&nRace==RACIAL_TYPE_OUTSIDER) bResults=TRUE;
  else if (sCmd=="U"&&nRace==RACIAL_TYPE_UNDEAD) bResults=TRUE;
  else if (sCmd=="F"&&nRace==RACIAL_TYPE_FEY) bResults=TRUE;
  else if (sCmd=="g"&&nRace==RACIAL_TYPE_GIANT) bResults=TRUE;
  if (!bResults) NPCACTAbortCommands();
} // fnLOGICRaceGender()

///////////////////////////////////////// [ CORE ] /////////////////////////////
float fnNPCACTLogicCore(string sCom)
{ // PURPOSE: To encapsulate all the logic testing functions of NPC ACTIVITIES 6.0
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fDur=0.0;
  string sIn=GetStringRight(sCom,GetStringLength(sCom)-1);
  string sCmd=GetStringLeft(sIn,2);
  string sParameters=GetStringRight(sIn,GetStringLength(sIn)-2);
  string sL1=GetStringLeft(sCmd,1);
  string sLast=GetStringRight(sCmd,1);
  fnDebug(" fnNPCACTLogicCore("+sCmd+","+sParameters+")",TRUE);
  // call the individual functions
  if (sL1=="H")
  { // has and has not items
    fnLOGICHasRelated(sLast,sParameters);
  } // has and has not items
  else if (sL1=="I")
  { // integer logic
    fnLOGICInteger(sLast,sParameters);
  } // integer logic
  else if (sL1=="S")
  { // string logic
    fnLOGICString(sLast,sParameters);
  } // string logic
  else if (sCmd=="UW")
  { // Weather
    fnLOGICWeather(sParameters);
  } // Weather
  else if (sCmd=="UA")
  { // Alignment
    fnLOGICAlignment(sParameters);
  } // Alignment
  else if (sCmd=="Ua")
  { // Appearance #
    fnLOGICAppearance(sParameters);
  } // Appearance #
  else if (sCmd=="UR")
  { // ResRef
    fnLOGICResRef(sParameters);
  } // ResRef
  else if (sCmd=="UT")
  { // Time of Day
    fnLOGICTime(sParameters);
  } // Time of Day
  else if (sCmd=="US")
  { // Tag
    fnLOGICSpecificTag(sParameters);
  } // Tag
  else if (sL1=="U")
  { // Race, Gender
    fnLOGICRaceGender(sCmd,sParameters);
  } // Race, Gender
  return fDur;
} // fnNPCACTLogicCore()

//void main(){}
