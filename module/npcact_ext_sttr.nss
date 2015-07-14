////////////////////////////////////////////////////////////////////////////////
// npcact_ext_STTR - NPC ACTIVITIES 6.0  Set Trap external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"

void main()
{
  float fDelay=0.5;
  if (GetHasSkill(SKILL_SET_TRAP)==TRUE)
  { // has set trap skill
  object oItem=GetItemPossessedBy(OBJECT_SELF,"NW_IT_TRAP035");
  object oWhere=GetNearestObjectByTag("NPC_TRAP_POINT");
  int nCount=35;
  location lTrap=GetLocation(oWhere);
  string sTrapTag;
  object oArea=GetArea(OBJECT_SELF);
  object oNewTrap;
  int nWorkVar;
  int nRadius;
  int nDetectDC;
  int nDisarmDC;
  int nSingleFire;
  string sScript;
  string sWork;
  // <radius>.<detect>.<disarm>.<single>.<script>
  string sName; // name for NPC_TRAP_POINT
  while(nCount>1&&oItem==OBJECT_INVALID)
  { // check to see if possess trap
    nCount--;
    sTrapTag="NW_IT_TRAP0";
    if (nCount>9) sTrapTag=sTrapTag+IntToString(nCount);
    else sTrapTag=sTrapTag+"0"+IntToString(nCount);
    oItem=GetItemPossessedBy(OBJECT_SELF,sTrapTag);
  } // check to see if possess trap
  if(oItem==OBJECT_INVALID)
  { // fine then search for custom traps
    if (NPCACT_CUSTOMTRAPS>0)
    { // there are custom traps
      nCount=1;
      sTrapTag="NPCACT_TRAP_1";
      oItem=GetItemPossessedBy(OBJECT_SELF,sTrapTag);
      while(oItem==OBJECT_INVALID&&nCount<NPCACT_CUSTOMTRAPS)
      { // poll inventory
        nCount++;
        sTrapTag="NPCACT_TRAP_"+IntToString(nCount);
        oItem=GetItemPossessedBy(OBJECT_SELF,sTrapTag);
      } // poll inventory
    } // there are custom traps
  } // fine then search for custom traps
  if (oItem!=OBJECT_INVALID&&oWhere!=OBJECT_INVALID)
  { // !OI
    fDelay=12.0;
    ActionForceMoveToObject(oWhere,FALSE,0.5);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,4.0);
    ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,OBJECT_SELF));
    oNewTrap=CreateObject(OBJECT_TYPE_PLACEABLE,"npcact_trap_invis",lTrap,FALSE);
    if (oNewTrap==OBJECT_INVALID)
    { // did not work
      ActionSpeakString("Humphhhh... my trap did not work");
    } // did not work
    else
    { // trap set
      nWorkVar=GetLocalInt(oArea,"nNPCACTTraps");
      nWorkVar++;
      SetLocalInt(oArea,"nNPCACTTraps",nWorkVar);
      sName=GetName(oWhere);
      while(GetStringLeft(sName,1)!="."&&GetStringLength(sName)>0)
      { // build radius
        sWork=sWork+GetStringLeft(sName,1);
        sName=GetStringRight(sName,GetStringLength(sName)-1);
      } // build radius
      if (GetStringLeft(sName,1)==".") sName=GetStringRight(sName,GetStringLength(sName)-1);
      nRadius=StringToInt(sWork);
      sWork="";
       while(GetStringLeft(sName,1)!="."&&GetStringLength(sName)>0)
      { // detect DC
        sWork=sWork+GetStringLeft(sName,1);
        sName=GetStringRight(sName,GetStringLength(sName)-1);
      } // detect DC
      if (GetStringLeft(sName,1)==".") sName=GetStringRight(sName,GetStringLength(sName)-1);
      nDetectDC=StringToInt(sWork);
      sWork="";
       while(GetStringLeft(sName,1)!="."&&GetStringLength(sName)>0)
      { // Disarm DC
        sWork=sWork+GetStringLeft(sName,1);
        sName=GetStringRight(sName,GetStringLength(sName)-1);
      } // Disarm DC
      if (GetStringLeft(sName,1)==".") sName=GetStringRight(sName,GetStringLength(sName)-1);
      nDisarmDC=StringToInt(sWork);
      while(GetStringLeft(sName,1)!="."&&GetStringLength(sName)>0)
      { // single usage
        sWork=sWork+GetStringLeft(sName,1);
        sName=GetStringRight(sName,GetStringLength(sName)-1);
      } // single usage
      if (GetStringLeft(sName,1)==".") sName=GetStringRight(sName,GetStringLength(sName)-1);
      nSingleFire=StringToInt(sWork);
      sScript=sName;
      SetLocalInt(oNewTrap,"nRadius",nRadius);
      SetLocalInt(oNewTrap,"nDetect",nDetectDC);
      SetLocalInt(oNewTrap,"nDisarm",nDisarmDC);
      SetLocalInt(oNewTrap,"nSingleFire",nSingleFire);
      if(sScript!="DEFAULT")
       {
        SetLocalString(oNewTrap,"sScript",sScript);
       }
      else
      { // default script
        sWork=GetTag(oItem);
        if (GetStringLength(sWork)>9) sWork=GetStringRight(sWork,9);
        sScript="DOTRAP_"+sWork;
        SetLocalString(oNewTrap,"sScript",sScript);
      } // default script
      DestroyObject(oItem);
    } // trap set
   } // !OI
 } // has set trap skill
 SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
}// NPCActionSetTrap()
