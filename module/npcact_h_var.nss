////////////////////////////////////////////////////////////////////////////////
// npcact_h_var - NPC ACTIVITIES 6.0  Variable Commands
//------------------------------------------------------------------------------
// By Deva Bryson Winblood            05/31/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/16/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
///////////////////////////////
// PROTOTYPES
///////////////////////////////

// FILE: npcact_h_var                FUNCTION: fnNPCACTSetVariable()
// This will set variables on the NPC to the specified value
float fnNPCACTSetVariable(string sCom);

// FILE: npcact_h_var                FUNCTION: fnNPCACTAddSubtract()
// This function handles addition and subtraction done to NPC variables.
float fnNPCACTAddSubtract(string sCom);

///////////////////////////////
// FUNCTIONS
///////////////////////////////

float fnNPCACTSetVariable(string sCom)
{ // PURPOSE: To set or initialize variables on the NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm=GetStringRight(sCom,GetStringLength(sCom)-2);
  string sT=GetSubString(sCom,1,1);
  string sVar1=fnParse(sParm,"/");
  string sVar2=fnRemoveParsed(sParm,sVar1,"/");
  fnDebug(" fnNPCACTSetVariable("+sT+","+sVar1+","+sVar2+")",TRUE);
  if (sT=="A") SetLocalInt(OBJECT_SELF,sVar1,GetAppearanceType(OBJECT_SELF));
  else if (sT=="H") SetLocalInt(OBJECT_SELF,sVar1,GetTimeHour());
  else if (sT=="I") SetLocalInt(OBJECT_SELF,sVar1,StringToInt(sVar2));
  else if (sT=="i") SetLocalInt(OBJECT_SELF,sVar1,GetLocalInt(OBJECT_SELF,sVar2));
  else if (sT=="R") SetLocalInt(OBJECT_SELF,sVar1,Random(StringToInt(sVar2))+1);
  else if (sT=="S") SetLocalString(OBJECT_SELF,sVar1,sVar2);
  else if (sT=="s") SetLocalString(OBJECT_SELF,sVar1,GetLocalString(OBJECT_SELF,sVar2));
  return 0.1;
} // fnNPCACTSetVariable()

float fnNPCACTAddSubtract(string sCom)
{ // PURPOSE: This function handles addition and subtraction of NPC variables
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm=GetStringRight(sCom,GetStringLength(sCom)-2);
  string sT=GetSubString(sCom,1,1);
  string sVar1=fnParse(sParm,"/");
  string sVar2=fnRemoveParsed(sParm,sVar1,"/");
  int nVal=1;
  fnDebug(" fnNPCACTAddSubtract("+sT+","+sVar1+","+sVar2+")",TRUE);
  if (GetStringLeft(sCom,1)=="-") nVal=-1;
  if (sT=="I") SetLocalInt(OBJECT_SELF,sVar1,GetLocalInt(OBJECT_SELF,sVar1)+(StringToInt(sVar2)*nVal));
  else if (sT=="i") SetLocalInt(OBJECT_SELF,sVar1,GetLocalInt(OBJECT_SELF,sVar1)+(GetLocalInt(OBJECT_SELF,sVar2)*nVal));
  else if (sT=="S") SetLocalString(OBJECT_SELF,sVar1,GetLocalString(OBJECT_SELF,sVar1)+sVar2);
  return 0.1;
} // fnNPCACTAddSubtract()

//void main(){}
